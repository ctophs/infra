include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/container-app-environment"
}


dependency "resource_group" {
  config_path = "../resource-group"

  mock_outputs = {
    id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mockname"
    name     = "mockname"
    location = "westeurope"
  }
}

inputs = {
  name                = values.name
  location            = values.location
  resource_group_name = dependency.resource_group.outputs.name
}
