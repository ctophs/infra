locals {
  mgmt_group     = read_terragrunt_config(find_in_parent_folders("managementgroup.hcl"))
  location       = local.mgmt_group.locals.location
  name           = local.mgmt_group.locals.name
  component_name = "cae"
}

stack "dev" {
  source = "../../../stacks/container-app-environment"
  path   = "dev"
  values = {
    name                     = local.component_name
    location                 = local.location
    resource_group_name      = "rg-${local.name}-dev-${local.component_name}"
    infrastructure_subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-cae-dev/providers/Microsoft.Network/virtualNetworks/vnet-dev/subnets/snet-cae-dev"
  }
}

stack "prod" {
  source = "../../../stacks/container-app-environment"
  path   = "prod"
  values = {
    name                     = local.component_name
    location                 = local.location
    resource_group_name      = "rg-${local.name}-prod-${local.component_name}"
    infrastructure_subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-cae-prod/providers/Microsoft.Network/virtualNetworks/vnet-prod/subnets/snet-cae-prod"
  }
}
