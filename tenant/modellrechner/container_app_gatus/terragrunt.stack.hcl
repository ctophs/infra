locals {
  mgmt_group     = read_terragrunt_config(find_in_parent_folders("managementgroup.hcl"))
  location       = local.mgmt_group.locals.location
  name           = local.mgmt_group.locals.name
  component_name = "gatus"
}

stack "dev" {
  source = "../../../stacks/container_app"
  path   = "dev"
  values = {
    name                = local.component_name
    location            = local.location
    resource_group_name = "rg-${local.name}-dev-cae"
    template = {
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
    secrets = [{
      name  = "example"
      value = "example"
    }]
  }
}

stack "prod" {
  source = "../../../stacks/container_app"
  path   = "prod"
  values = {
    name                = local.component_name
    location            = local.location
    resource_group_name = "rg-${local.name}-prod-cae"
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
