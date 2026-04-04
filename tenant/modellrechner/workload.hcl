locals {
  mgmt_group  = read_terragrunt_config("${get_terragrunt_dir()}/managementgroup.hcl")
  catalog     = read_terragrunt_config(find_in_parent_folders("catalog.hcl"))
  location    = local.mgmt_group.locals.location
  name        = local.mgmt_group.locals.name
  catalog_url = local.catalog.locals.url
  catalog_ref = local.catalog.locals.ref
}
