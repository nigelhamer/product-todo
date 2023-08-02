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

variable "product_name" {
  description = "The name of the product"
  type        = string
}

variable "product_prefix" {
  description = "The prefix appended to all resources used to identify the product"
  type        = string
}

variable "product_service_name" {
  description = "The name of product service to be deployed. Used to construct Azure resource names"
  type        = string
}
