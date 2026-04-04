#!/usr/bin/env bash
# Legt einen neuen Workload-Stack unter einer Management-Group an.
#
# Verwendung:
#   ./scripts/new-workload.sh <management_group> <workload_name> <catalog_stack>
#
# Beispiel:
#   ./scripts/new-workload.sh modellrechner redis container_app
#
# Erzeugt:
#   tenant/<management_group>/<workload_name>/terragrunt.stack.hcl

set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "Verwendung: $0 <management_group> <workload_name> <catalog_stack>" >&2
  echo "Beispiel:   $0 modellrechner redis container_app" >&2
  echo "" >&2
  echo "Verfuegbare Catalog-Stacks:" >&2
  ls -1 "$(dirname "$0")/../../catalog/stacks/" 2>/dev/null \
    | sed 's/^/  /' >&2 || echo "  (catalog-Verzeichnis nicht gefunden)" >&2
  exit 1
fi

mg="$1"
workload="$2"
catalog_stack="$3"

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
target_dir="${repo_root}/tenant/${mg}/${workload}"

if [[ -d "$target_dir" ]]; then
  echo "Fehler: ${target_dir} existiert bereits." >&2
  exit 1
fi

if [[ ! -f "${repo_root}/tenant/${mg}/managementgroup.hcl" ]]; then
  echo "Fehler: Management-Group '${mg}' nicht gefunden (tenant/${mg}/managementgroup.hcl fehlt)." >&2
  exit 1
fi

if [[ ! -f "${repo_root}/tenant/${mg}/workload.hcl" ]]; then
  echo "Fehler: workload.hcl fehlt in tenant/${mg}/. Bitte zuerst anlegen." >&2
  exit 1
fi

mkdir -p "$target_dir"

cat > "${target_dir}/terragrunt.stack.hcl" << 'TEMPLATE'
# Terragrunt-Stacks unterstuetzen kein include — daher muessen die
# gemeinsamen Locals aus workload.hcl hier explizit ausgepackt werden.
# Nur component_name ist workload-spezifisch, der Rest ist Boilerplate.
locals {
  workload       = read_terragrunt_config(find_in_parent_folders("workload.hcl"))
  name           = local.workload.locals.name
  location       = local.workload.locals.location
  catalog_url    = local.workload.locals.catalog_url
  catalog_ref    = local.workload.locals.catalog_ref
  component_name = "WORKLOAD_NAME"
}

stack "dev" {
  source = "${local.catalog_url}//stacks/CATALOG_STACK?ref=${local.catalog_ref}"
  path   = "dev"
  values = {
    name     = local.component_name
    location = local.location
    # TODO: workload-spezifische Values ergaenzen
  }
}

stack "prod" {
  source = "${local.catalog_url}//stacks/CATALOG_STACK?ref=${local.catalog_ref}"
  path   = "prod"
  values = {
    name     = local.component_name
    location = local.location
    # TODO: workload-spezifische Values ergaenzen
  }
}
TEMPLATE

sed -i "s/WORKLOAD_NAME/${workload}/g" "${target_dir}/terragrunt.stack.hcl"
sed -i "s/CATALOG_STACK/${catalog_stack}/g" "${target_dir}/terragrunt.stack.hcl"

echo "Workload angelegt: tenant/${mg}/${workload}/terragrunt.stack.hcl"
echo "Naechste Schritte:"
echo "  1. Values in den Stack-Bloecken ergaenzen (siehe TODO)"
echo "  2. terragrunt stack generate ausfuehren"
echo "  3. terragrunt run --all validate ausfuehren"
