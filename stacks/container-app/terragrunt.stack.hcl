unit "uami" {
  source = "${get_repo_root()}//units/uami"
  path   = "uami"
  values = {
    name                = "${values.name}-uami"
    location            = values.location
    resource_group_name = values.resource_group_name
  }
}

unit "container-app" {
  source = "${get_repo_root()}//units/container-app"
  path   = "container-app"
  values = {
    name          = values.name
    revision_mode = try(values.revision_mode, "Single")
    template      = values.template
    ingress       = try(values.ingress, null)
    tags          = try(values.tags, {})
    secrets       = try(values.secrets, [])
  }
}
