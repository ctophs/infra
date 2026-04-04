locals {
  mgmt_group     = read_terragrunt_config(find_in_parent_folders("managementgroup.hcl"))
  location       = local.mgmt_group.locals.location
  name           = local.mgmt_group.locals.name
  component_name = "gatus"
}

stack "dev" {
  source = "../../../stacks/container-app"
  path   = "dev"
  values = {
    name     = local.component_name
    location = local.location
    template = {
      min_replicas = 0
      max_replicas = 1
      containers = [{
        name   = "gatus"
        image  = "ghcr.io/twin/gatus:latest"
        cpu    = 0.25
        memory = "0.5Gi"
        env    = []
      }]
    }
    ingress = {
      external_enabled = false
      target_port      = 8080
    }
  }
}

stack "prod" {
  source = "../../../stacks/container-app"
  path   = "prod"
  values = {
    name     = local.component_name
    location = local.location
    template = {
      min_replicas = 1
      max_replicas = 3
      containers = [{
        name   = "gatus"
        image  = "ghcr.io/twin/gatus:latest"
        cpu    = 0.5
        memory = "1Gi"
        env    = []
      }]
    }
    ingress = {
      external_enabled = false
      target_port      = 8080
    }
  }
}
