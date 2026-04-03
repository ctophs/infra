locals {
  tenant_config           = read_terragrunt_config(find_in_parent_folders("tenant.hcl"))
  management_group_config = read_terragrunt_config(find_in_parent_folders("managementgroup.hcl"))

  subscription          = local.management_group_config.locals.subscriptions[basename(dirname(dirname(get_terragrunt_dir())))]
  subscription_id       = local.subscription.id
  management_group_name = local.management_group_config.locals.name
  tenant_id             = local.tenant_config.locals.id
  tenant_name           = local.tenant_config.locals.name
}

inputs = {
  tenant_id             = local.tenant_id
  subscription_id       = local.subscription_id
  management_group_name = local.management_group_name
}
