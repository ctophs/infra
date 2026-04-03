mock_provider "azurerm" {}

run "plan" {
  command = plan

  variables {
    name                = "cae-test"
    location            = "westeurope"
    resource_group_name = "rg-test"
  }
}
