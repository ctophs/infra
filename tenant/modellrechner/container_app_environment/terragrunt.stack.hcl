# Terragrunt-Stacks unterstuetzen kein include — daher muessen die
# gemeinsamen Locals aus workload.hcl hier explizit ausgepackt werden.
# Nur component_name ist workload-spezifisch, der Rest ist Boilerplate.
locals {
  workload       = read_terragrunt_config(find_in_parent_folders("workload.hcl"))
  name           = local.workload.locals.name
  location       = local.workload.locals.location
  catalog_url    = local.workload.locals.catalog_url
  catalog_ref    = local.workload.locals.catalog_ref
  component_name = "cae"
}

stack "dev" {
  source = "${local.catalog_url}//stacks/container_app_environment?ref=${local.catalog_ref}"
  path   = "dev"
  values = {
    name                     = local.component_name
    location                 = local.location
    resource_group_name      = "rg-${local.name}-dev-${local.component_name}"
    uami_resource_group_name = "rg-${local.name}-dev-${local.component_name}-uami"
    infrastructure_subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-cae-dev/providers/Microsoft.Network/virtualNetworks/vnet-dev/subnets/snet-cae-dev"
  }
}

stack "prod" {
  source = "${local.catalog_url}//stacks/container_app_environment?ref=${local.catalog_ref}"
  path   = "prod"
  values = {
    name                     = local.component_name
    location                 = local.location
    resource_group_name      = "rg-${local.name}-prod-${local.component_name}"
    uami_resource_group_name = "rg-${local.name}-prod-${local.component_name}-uami"
    infrastructure_subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-cae-prod/providers/Microsoft.Network/virtualNetworks/vnet-prod/subnets/snet-cae-prod"
  }
}
