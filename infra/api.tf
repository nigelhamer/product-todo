# Function App
resource "azurecaf_name" "functionapp_name" {
  name          = local.name_format
  resource_type = "azurerm_app_service"
  suffixes      = ["api", var.environment_name]
  random_length = 0
  clean_input   = true
}
resource "azurecaf_name" "appserviceplan_name" {
  name          = local.name_format
  resource_type = "azurerm_app_service"
  suffixes      = [var.environment_name]
  random_length = 0
  clean_input   = true
}
resource "azurecaf_name" "storageacc_name" {
  name          = local.name_format
  resource_type = "azurerm_storage_account"
  suffixes      = [var.environment_name]
  random_length = 0
  clean_input   = true
}
resource "azurecaf_name" "managedId_name" {
  name          = local.name_format
  resource_type = "general"
  suffixes      = [var.environment_name]
  random_length = 0
  clean_input   = true
}

resource "azurerm_storage_account" "functionapp_storage" {
  name                     = azurecaf_name.storageacc_name.result
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  tags                     = local.tags
  account_tier             = "Standard"
  account_replication_type = "LRS"

}
resource "azurerm_service_plan" "appserviceplan" {
  name                = azurecaf_name.appserviceplan_name.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
  os_type             = "Linux"
  sku_name            = "Y1"

}
resource "azurerm_linux_function_app" "functionapp" {
  name                       = azurecaf_name.functionapp_name.result
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.appserviceplan.id
  storage_account_name       = azurerm_storage_account.functionapp_storage.name
  storage_account_access_key = azurerm_storage_account.functionapp_storage.primary_access_key


  # Mark as api. Required for AZD to know where to deploy
  tags = merge(local.tags, { azd-service-name : "api" })

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"       = "dotnet"
    "FUNCTIONS_EXTENSION_VERSION"    = "~4"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appinsights.instrumentation_key,
    "AzureAd__ClientId"              = azurerm_user_assigned_identity.applicationIdentity.client_id,
    "StorageContainerName"           = "application",
  }
  site_config {}
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.applicationIdentity.id]
  }
}
resource "azurerm_user_assigned_identity" "applicationIdentity" {
  name                = azurecaf_name.managedId_name.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}