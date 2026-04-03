locals {
  tenant_config           = read_terragrunt_config(find_in_parent_folders("tenant.hcl"))
  management_group_config = read_terragrunt_config(find_in_parent_folders("managementgroup.hcl"))
  subscription_config     = read_terragrunt_config(find_in_parent_folders("subscription.hcl"))

  subscription_id       = local.subscription_config.locals.id
  workload_stage        = local.subscription_config.locals.stage
  management_group_name = local.management_group_config.locals.name
  tenant_id             = local.tenant_config.locals.id
  tenant_name           = local.tenant_config.locals.name
}

inputs = {
  tenant_id             = local.tenant_id
  subscription_id       = local.subscription_id
  management_group_name = local.management_group_name
  workload_stage        = local.workload_stage
}
