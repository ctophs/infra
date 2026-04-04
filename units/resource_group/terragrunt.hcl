include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/resource_group"
}

inputs = {
  name     = values.name
  location = values.location
}
