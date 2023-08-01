resource "azurecaf_name" "appinsights_name" {
  name          = local.name_format
  resource_type = "azurerm_application_insights"
  suffixes      = [var.environment_name]
  random_length = 0
  clean_input   = true
}
resource "azurecaf_name" "loganalytics_name" {
  name          = local.name_format
  resource_type = "azurerm_log_analytics_workspace"
  suffixes      = [var.environment_name]
  random_length = 0
  clean_input   = true
}

# Deploy application insights and log analytics workspace
resource "azurerm_application_insights" "appinsights" {
  name                = azurecaf_name.appinsights_name.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.loganalytics.id
}

resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = azurecaf_name.loganalytics_name.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
  sku                 = "PerGB2018"
  retention_in_days   = 30
}