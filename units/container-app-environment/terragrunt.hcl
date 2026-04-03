include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../modules/container-app-environment"
}


dependency "resource_group" {
  config_path = "../resource-group"

  mock_outputs = {
    name = "mockname"
  }
}

inputs = {
  name                = values.name
  location            = values.location
  resource_group_name = dependency.resource_group.outputs.name
}
