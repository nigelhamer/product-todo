resource "azurerm_storage_account" "apiapp_storage" {
  name                     = var.storage_account_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  tags                     = var.tags
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "apiapp_serviceplan" {
  name                = var.service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "apiapp" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(var.tags, var.locator-tags)

  service_plan_id            = azurerm_service_plan.apiapp_serviceplan.id
  storage_account_name       = azurerm_storage_account.apiapp_storage.name
  storage_account_access_key = azurerm_storage_account.apiapp_storage.primary_access_key

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"    = "dotnet"
    "FUNCTIONS_EXTENSION_VERSION" = "~4"
    "AzureAd__ClientId"           = azurerm_user_assigned_identity.applicationIdentity.client_id,
    "StorageContainerName"        = "application",
    "AZURE_KEY_VAULT_ENDPOINT"    = var.keyVaultUri
  }
  site_config {
    application_insights_key = var.applicationInsightsKey
    cors {
      allowed_origins = concat(["https://portal.azure.com", "https://ms.portal.azure.com"], var.allowed_origins)
    }
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.applicationIdentity.id]
  }
}

resource "azurerm_user_assigned_identity" "applicationIdentity" {
  name                = var.managed_id_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}