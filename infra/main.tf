locals {
  // Tag the resource group with the azd environment name
  // This should also be applied to all resources created in this module
  tags           = { azd-env-name : var.environment_name }
  sha            = base64encode(sha256("${var.environment_name}${var.location}${data.azurerm_client_config.current.subscription_id}"))
  resource_token = substr(replace(lower(local.sha), "[^A-Za-z0-9_]", ""), 0, 13)
  name_format    = "${var.product_prefix}-${var.product_service_name}"
}
# Implements a set of methodologies to apply consistent resource naming using the default Microsoft Cloud Adoption Framework for Azure recommendations
# https://github.com/aztfmod/terraform-provider-azurecaf/blob/main/docs/resources/azurecaf_name.md
resource "azurecaf_name" "rg_name" {
  name          = local.name_format
  resource_type = "azurerm_resource_group"
  suffixes      = [var.environment_name]
  random_length = 0
  clean_input   = true
}

# Deploy resource group
resource "azurerm_resource_group" "rg" {
  name     = azurecaf_name.rg_name.result
  location = var.location
  tags     = local.tags
}


