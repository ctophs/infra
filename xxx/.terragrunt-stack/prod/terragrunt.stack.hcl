unit "resource-group" {
  source = "//units/resource-group"
  path   = "resource-group"
  values = {
    name     = values.name
    location = values.location
  }
}

unit "cae" {
  source = "//units/container-app-environment"
  path   = "cae"
  values = {
    name     = values.name
    location = values.location
  }
}

unit "uami" {
  source = "//units/uami"
  path   = "uami"
  values = {
    name     = values.name
    location = values.location
  }
}
