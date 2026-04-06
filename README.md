# Infrastruktur-Repository — Anleitung

Dieses Repository enthält die umgebungsspezifische Konfiguration der Azure-Infrastruktur.
Wiederverwendbare Bausteine (Terraform-Module, Terragrunt-Units und -Stacks) liegen im
separaten [Catalog-Repository](https://github.com/ctophs/catalog.git) und werden per Git
referenziert.

---

## Verzeichnisstruktur

```
infra/
├── catalog.hcl                          # Catalog-URL und Git-Ref (einzige Quelle der Wahrheit)
└── tenant/
    ├── root.hcl                         # Provider-Generierung, gemeinsame Locals für alle Units
    ├── tenant.hcl                       # Tenant-ID und -Name
    └── <management-group>/              # z. B. modellrechner/
        ├── managementgroup.hcl          # Name, Region, Subscriptions je Stage
        ├── workload.hcl                 # Bündelt MG- und Catalog-Daten für Workload-Stacks
        └── <workload>/                  # z. B. container_app_environment/
            └── terragrunt.stack.hcl     # Stack-Definition mit dev/prod-Blöcken
```

---

## Schlüsseldateien

### `catalog.hcl`

Definiert die Git-URL und den Ref (Branch/Tag) des Catalog-Repos.
Diese Datei ist die **einzige Stelle**, an der die Catalog-Quelle festgelegt wird.
Alle anderen Dateien lesen sie per `find_in_parent_folders("catalog.hcl")`.

```hcl
locals {
  url = "git::https://github.com/ctophs/catalog.git"
  ref = "master"
}
```

Um auf einen anderen Branch oder Tag zu wechseln, nur `ref` anpassen.

### `tenant/root.hcl`

Wird von jeder Unit per `include "root"` eingebunden (`expose = true`).
Stellt bereit:

- `catalog_url` / `catalog_ref` — für `terraform { source = ... }` in Units
- `tenant_id` / `tenant_name` — aus `tenant.hcl`
- `management_group_name` / `subscription_id` — aus `managementgroup.hcl`
- `stage` — aus dem generierten Pfad abgeleitet (`dev` / `test` / `prod`)
- Provider-Generierung (`providers.tf`) mit der korrekten `subscription_id`

### `tenant/tenant.hcl`

Enthält die unveränderlichen Tenant-Daten (ID, Name).

### `<management-group>/managementgroup.hcl`

Beschreibt die Management-Group: Name, Azure-Region und die Subscription-IDs je Stage.
Diese Datei bleibt bewusst von `workload.hcl` getrennt — sie beschreibt die fachliche
Identität der MG, während `workload.hcl` eine rein technische Komfort-Schicht ist.

### `<management-group>/workload.hcl`

Bündelt `managementgroup.hcl` und `catalog.hcl` in einem einzigen Read, damit
Workload-Stacks nicht beide Dateien separat einlesen müssen.
Bei einer neuen Management-Group diese Datei **unverändert kopieren** — sie enthält
keine MG-spezifischen Werte.

### `<management-group>/<workload>/terragrunt.stack.hcl`

Definiert die Stacks je Stage (dev, prod). Da Terragrunt-Stacks kein `include`
unterstützen, werden die gemeinsamen Locals aus `workload.hcl` hier explizit
ausgepackt. Einzig `component_name` ist workload-spezifisch.

---

## Einen neuen Workload anlegen

1. Verzeichnis unter `tenant/<management-group>/<workload-name>/` anlegen.
2. `terragrunt.stack.hcl` anlegen:

```hcl
locals {
  workload       = read_terragrunt_config(find_in_parent_folders("workload.hcl"))
  name           = local.workload.locals.name
  location       = local.workload.locals.location
  catalog_url    = local.workload.locals.catalog_url
  catalog_ref    = local.workload.locals.catalog_ref
  component_name = "<name>"   # <-- anpassen
}

stack "dev" {
  source = "${local.catalog_url}//stacks/<stack-name>?ref=${local.catalog_ref}"
  path   = "dev"
  values = {
    # Stack-spezifische Eingabewerte
  }
}

stack "prod" {
  source = "${local.catalog_url}//stacks/<stack-name>?ref=${local.catalog_ref}"
  path   = "prod"
  values = {
    # Stack-spezifische Eingabewerte
  }
}
```

3. Verfügbare Stacks im Catalog-Repo unter `stacks/` nachschlagen.

---

## Eine neue Management-Group anlegen

1. Verzeichnis `tenant/<mg-name>/` anlegen.
2. `managementgroup.hcl` anlegen:

```hcl
locals {
  name     = basename(get_terragrunt_dir())
  location = "westeurope"

  subscriptions = {
    dev  = { name = "S_${upper(local.name)}_DEV",  id = "<subscription-id>" }
    test = { name = "S_${upper(local.name)}_TEST", id = "<subscription-id>" }
    prod = { name = "S_${upper(local.name)}_PROD", id = "<subscription-id>" }
  }
}
```

3. `workload.hcl` aus einer bestehenden Management-Group **unverändert** kopieren.
4. Workloads wie oben beschrieben anlegen.

---

## Stacks generieren und testen

```bash
# Stack-Dateien generieren (erzeugt .terragrunt-stack/-Verzeichnisse)
terragrunt stack generate

# Generierte Dateien aufräumen
terragrunt stack clean

# Alle Units eines Stacks planen (Dry-Run, kein Azure-Zugriff nötig)
terragrunt run --all plan

# Einzelnen Stack planen
cd tenant/modellrechner/container_app_environment
terragrunt stack generate
terragrunt run plan
terragrunt stack clean
```

---

## Catalog-Version aktualisieren

Nur `ref` in `catalog.hcl` anpassen:

```hcl
locals {
  url = "git::https://github.com/ctophs/catalog.git"
  ref = "v1.2.0"   # Branch, Tag oder Commit-SHA
}
```

Danach `stack generate` und `run --all plan` ausführen, um Auswirkungen zu prüfen.

---

## Häufige Fehler

| Fehler | Ursache | Lösung |
|--------|---------|--------|
| `ref not found` | Branch/Tag existiert nicht im Catalog | `ref` in `catalog.hcl` prüfen |
| `relative path requires module with pwd` | Relativer Pfad in git::-Quelle | Vollständige `git::https://`-URL verwenden |
| `values.* not accessible in include` | `values.*` nur in Units direkt nutzbar, nicht in included Configs | `expose = true` + `include.root.locals.*` verwenden |
| Stack-Locals fehlen | Stacks unterstützen kein `include` | Locals aus `workload.hcl` explizit auspacken |
