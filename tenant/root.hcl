generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features        {}
  subscription_id = "${local.subscription_id}"
}
EOF
}

locals {
  catalog_config = read_terragrunt_config(find_in_parent_folders("catalog.hcl"))
  catalog_url    = local.catalog_config.locals.url
  catalog_ref    = local.catalog_config.locals.ref

  tenant_config           = read_terragrunt_config(find_in_parent_folders("tenant.hcl"))
  management_group_config = read_terragrunt_config(find_in_parent_folders("managementgroup.hcl"))

  # Stage (dev/test/prod) aus dem generierten Unit-Pfad ableiten.
  #
  # Generierte Unit-Pfade haben folgende Struktur:
  #   <workload>/.terragrunt-stack/<stage>/terragrunt.stack.hcl
  #   <workload>/.terragrunt-stack/<stage>/.terragrunt-stack/<unit>/terragrunt.hcl
  #
  # Beispiel für die Unit "cae-resource-group" im dev-Stack:
  #   tenant/modellrechner/container_app_environment/
  #     .terragrunt-stack/dev/.terragrunt-stack/cae-resource-group/
  #
  # get_terragrunt_dir() → .../cae-resource-group
  # dirname()            → .../dev/.terragrunt-stack
  # dirname()            → .../dev
  # basename()           → "dev"
  #
  # dirname() wird 2x benötigt weil zwischen Stage und Unit noch
  # .terragrunt-stack liegt.
  stage                 = basename(dirname(dirname(get_terragrunt_dir())))
  subscription          = local.management_group_config.locals.subscriptions[local.stage]
  subscription_id       = local.subscription.id
  management_group_name = local.management_group_config.locals.name
  tenant_id             = local.tenant_config.locals.id
  tenant_name           = local.tenant_config.locals.name
}

