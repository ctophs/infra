include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../modules/resource-group"
}

inputs = {
  name     = values.name
  location = values.location
}
