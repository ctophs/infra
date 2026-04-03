locals {
  name                = "cae"
  resource_group_name = "rg-modellrechner-dev-cae"
  location            = "westeurope"
}

unit "uami" {
  source = "../../../../units/uami"

  path = "uami"

  values = {
    name                = "uami"
    resource_group_name = local.resource_group_name
    location            = local.location
  }
}

unit "container_app_environment" {
  source = "../../../../units/container-app-environment"

  path = "container_app_environment"

  values = {
    name                = local.name
    resource_group_name = local.resource_group_name
    location            = local.location

  }
}
