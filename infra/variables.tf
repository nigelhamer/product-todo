# Input variables for the module

variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "environment_name" {
  description = "The name of the azd environment to be deployed"
  type        = string
}

variable "principal_id" {
  description = "principal Id"
  type        = string
}

variable "service_name" {
  description = "The name of service to be deployed. Used to contruct Azure resource names"
  type        = string
}
