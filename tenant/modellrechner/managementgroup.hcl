locals {
  name     = basename(get_terragrunt_dir())
  location = "westeurope"

  # Listet alle verfuegbaren Subscriptions je Stage. Stacks waehlen selbst,
  # welche Stages sie deployen — es ist nicht erforderlich, dass jeder Stack
  # alle drei Stages instanziiert.
  subscriptions = {
    dev  = { name = "S_${upper(local.name)}_DEV", id = "00000000-0000-0000-0000-000000000000" }
    test = { name = "S_${upper(local.name)}_TEST", id = "00000000-0000-0000-0000-000000000000" }
    prod = { name = "S_${upper(local.name)}_PROD", id = "00000000-0000-0000-0000-000000000000" }
  }
}
