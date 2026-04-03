variable "name" {
  type        = string
  description = "Name of the Container App Environment."
}

variable "location" {
  type        = string
  description = "Azure region where the resource will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of a Log Analytics workspace. Required for workload profile environments."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resource."
  default     = {}
}
