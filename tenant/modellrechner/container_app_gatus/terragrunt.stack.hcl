# Terragrunt-Stacks unterstuetzen kein include — daher muessen die
# gemeinsamen Locals aus workload.hcl hier explizit ausgepackt werden.
# Nur component_name ist workload-spezifisch, der Rest ist Boilerplate.
locals {
  workload       = read_terragrunt_config(find_in_parent_folders("workload.hcl"))
  name           = local.workload.locals.name
  location       = local.workload.locals.location
  catalog_url    = local.workload.locals.catalog_url
  catalog_ref    = local.workload.locals.catalog_ref
  component_name = "gatus"
}

stack "dev" {
  source = "${local.catalog_url}//stacks/container_app?ref=${local.catalog_ref}"
  path   = "dev"
  values = {
    name                = local.component_name
    location            = local.location
    resource_group_name = "rg-${local.name}-dev-${local.component_name}"
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
  }
}

stack "prod" {
  source = "${local.catalog_url}//stacks/container_app?ref=${local.catalog_ref}"
  path   = "prod"
  values = {
    name                = local.component_name
    location            = local.location
    resource_group_name = "rg-${local.name}-prod-${local.component_name}"
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
