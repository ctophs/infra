locals {
  mgmt_group = read_terragrunt_config(find_in_parent_folders("managementgroup.hcl"))
  location   = local.mgmt_group.locals.location
}

stack "dev" {
  source = "../../../stacks/environment"
  path   = "dev"
  values = {
    name                = "xxx-dev"
    location            = local.location
    resource_group_name = "rg-xxx-dev"
  }
}

stack "prod" {
  source = "../../../stacks/environment"
  path   = "prod"
  values = {
    name                = "xxx-prod"
    location            = local.location
    resource_group_name = "rg-xxx-prod"
  }
}
