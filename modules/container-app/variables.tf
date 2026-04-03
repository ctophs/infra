variable "name" {
  type        = string
  description = "Name of the Container App."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "container_app_environment_id" {
  type        = string
  description = "Resource ID of the Container App Environment."
}

variable "revision_mode" {
  type        = string
  description = "Revision mode of the Container App. Possible values: Single, Multiple."
  default     = "Single"
}

variable "template" {
  type = object({
    min_replicas = optional(number, 0)
    max_replicas = optional(number, 10)
    containers = list(object({
      name   = string
      image  = string
      cpu    = number
      memory = string
      env = optional(list(object({
        name        = string
        value       = optional(string)
        secret_name = optional(string)
      })), [])
    }))
  })
  description = "Template block defining the container(s) and scaling."
}

variable "ingress" {
  type = object({
    external_enabled = optional(bool, false)
    target_port      = number
    transport        = optional(string, "auto")
  })
  description = "Ingress configuration. Set to null to disable ingress."
  default     = null
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string), [])
  })
  description = "Managed identity configuration."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resource."
  default     = {}
}
