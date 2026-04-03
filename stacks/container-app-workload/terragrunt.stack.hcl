unit "container-app" {
  source = "${get_repo_root()}//units/container-app"
  path   = "container-app"
  values = {
    name          = values.name
    revision_mode = try(values.revision_mode, "Single")
    template      = values.template
    ingress       = try(values.ingress, null)
    identity      = try(values.identity, null)
    tags          = try(values.tags, {})
  }
}
