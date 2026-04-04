locals {
  name     = upper(basename(get_terragrunt_dir()))
  location = "westeurope"

  subscriptions = {
    dev  = { name = "S_${local.name}_DEV", id = "00000000-0000-0000-0000-000000000000" }
    test = { name = "S_${local.name}_TEST", id = "00000000-0000-0000-0000-000000000000" }
    prod = { name = "S_${local.name}_PROD", id = "00000000-0000-0000-0000-000000000000" }
  }
}
