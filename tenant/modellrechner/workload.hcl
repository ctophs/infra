# Gemeinsame Locals für alle Workloads einer Management-Group.
#
# Bündelt managementgroup.hcl (MG-spezifisch: name, location, subscriptions)
# und catalog.hcl (repo-weit: catalog url + ref) in einem einzelnen Read,
# damit Workload-Stacks nur noch diese eine Datei einlesen m��ssen.
#
# managementgroup.hcl bleibt bewusst als eigene Datei bestehen:
# Sie beschreibt die Identität der Management-Group (Name, Region,
# Subscriptions) — Daten, die sich selten ändern und fachlich nichts
# mit dem Catalog zu tun haben. workload.hcl hingegen ist eine rein
# technische Komfort-Schicht, die diese Quellen für Workloads bündelt.
# Die Trennung wahrt das Single-Responsibility-Prinzip.
#
# Bei einer neuen Management-Group diese Datei unverändert kopieren —
# managementgroup.hcl wird relativ zum aufrufenden Workload-Verzeichnis
# aufgelöst.

locals {
  mgmt_group  = read_terragrunt_config("${get_terragrunt_dir()}/managementgroup.hcl")
  catalog     = read_terragrunt_config(find_in_parent_folders("catalog.hcl"))
  location    = local.mgmt_group.locals.location
  name        = local.mgmt_group.locals.name
  catalog_url = local.catalog.locals.url
  catalog_ref = local.catalog.locals.ref
}
