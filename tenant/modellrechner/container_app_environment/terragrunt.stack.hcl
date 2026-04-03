locals {
  mgmt_group = read_terragrunt_config(find_in_parent_folders("managementgroup.hcl"))
  location   = local.mgmt_group.locals.location
}

stack "dev" {
  source = "../../../stacks/container-app-environment"
  path   = "dev"
  values = {
    name                = "cae-dev"
    location            = local.location
    resource_group_name = "rg-cae-dev"
  }
}

stack "prod" {
  source = "../../../stacks/container-app-environment"
  path   = "prod"
  values = {
    name                = "cae-prod"
    location            = local.location
    resource_group_name = "rg-cae-prod"
  }
}
