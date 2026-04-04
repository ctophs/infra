unit "cae-resource-group" {
  source = "${get_repo_root()}//units/resource-group"
  path   = "cae-resource-group"
  values = {
    name     = values.resource_group_name
    location = values.location
  }
}

unit "cae" {
  source = "${get_repo_root()}//units/container-app-environment"
  path   = "cae"
  values = {
    name                     = values.name
    location                 = values.location
    infrastructure_subnet_id = try(values.infrastructure_subnet_id, null)
  }
}

unit "uami-resource-group" {
  source = "${get_repo_root()}//units/resource-group"
  path   = "uami-resource-group"
  values = {
    name     = values.uami_resource_group_name
    location = values.location
  }
}

unit "uami" {
  source = "${get_repo_root()}//units/uami"
  path   = "uami"
  values = {
    name                = values.name
    location            = values.location
    resource_group_name = values.uami_resource_group_name
  }
}
