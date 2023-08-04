# Function App
resource "azurecaf_name" "apiapp_name" {
  name          = local.name_format
  resource_type = "azurerm_app_service"
  suffixes      = ["api", var.environment_name]
  random_length = 0
  clean_input   = true
}
resource "azurecaf_name" "apiapp_serviceplan_name" {
  name          = local.name_format
  resource_type = "azurerm_app_service_plan"
  suffixes      = [var.environment_name]
  random_length = 0
  clean_input   = true
}
resource "azurecaf_name" "apiapp_storageacc_name" {
  name          = local.name_format
  resource_type = "azurerm_storage_account"
  suffixes      = [var.environment_name]
  random_length = 0
  clean_input   = true
}
resource "azurecaf_name" "apiapp_managedId_name" {
  name          = local.name_format
  resource_type = "general"
  suffixes      = [var.environment_name]
  random_length = 0
  clean_input   = true
}

module "api" {
  source = "./modules/api"

  name                = azurecaf_name.apiapp_name.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  service_plan_name    = azurecaf_name.apiapp_serviceplan_name.result
  storage_account_name = azurecaf_name.apiapp_storageacc_name.result
  managed_id_name      = azurecaf_name.apiapp_managedId_name.result

  allowed_origins             = [module.web.SERVICE_WEB_URI]
  applicationInsightsKey      = azurerm_application_insights.appinsights.instrumentation_key
  keyVaultUri                 = azurerm_key_vault.vault.vault_uri
  azureSqlConnectionStringKey = ""

  # Mark as api. Required for AZD to know where to deploy
  tags         = local.tags
  locator-tags = { azd-service-name : "api" }
}

