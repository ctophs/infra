stack "dev" {
  source = "../stacks/environment"
  path   = "dev"
  values = {
    environment = "development"
    name        = "xxx-dev"
    location    = "westeurope"
    cidr        = "10.0.0.0/16"
  }
}

stack "prod" {
  source = "../stacks/environment"
  path   = "prod"
  values = {
    environment = "production"
    name        = "xxx-prod"
    location    = "westeurope"
    cidr        = "10.1.0.0/16"
  }
}
