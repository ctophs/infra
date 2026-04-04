# Gemeinsame Locals für alle Workloads einer Management-Group.
#
# Bündelt managementgroup.hcl (MG-spezifisch: name, location, subscriptions)
# und catalog.hcl (repo-weit: catalog url + ref) in einem einzelnen Read,
# damit Workload-Stacks nur noch diese eine Datei einlesen müssen.
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
