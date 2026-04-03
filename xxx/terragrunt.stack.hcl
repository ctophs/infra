stack "dev" {
  source = "../stacks/environment"
  path   = "dev"
  values = {
    name                = "xxx-dev"
    location            = "westeurope"
    resource_group_name = "rg-xxx-dev"
  }
}

stack "prod" {
  source = "../stacks/environment"
  path   = "prod"
  values = {
    name                = "xxx-prod"
    location            = "westeurope"
    resource_group_name = "rg-xxx-prod"
  }
}
