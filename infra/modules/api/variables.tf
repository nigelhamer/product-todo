variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "service_plan_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "managed_id_name" {
  type = string
}

variable "allowed_origins" {
  type    = list(string)
  default = []
}

variable "applicationInsightsKey" {
  type = string
}

variable "keyVaultUri" {
  type = string
}

variable "azureSqlConnectionStringKey" {
  type = string
}
