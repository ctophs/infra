locals {
  name     = basename(get_terragrunt_dir())
  location = "westeurope"

  subscriptions = {
    dev  = { name = "s_${local.name}_dev",  id = "00000000-0000-0000-0000-000000000000" }
    test = { name = "s_${local.name}_test", id = "00000000-0000-0000-0000-000000000000" }
    prod = { name = "s_${local.name}_prod", id = "00000000-0000-0000-0000-000000000000" }
  }
}
