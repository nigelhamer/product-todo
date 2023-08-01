
# Deploy resource group
resource "azurecaf_name" "staticapp_name" {
  name          = local.name_format
  resource_type = "azurerm_app_service"
  suffixes      = ["static", var.environment_name]
  random_length = 0
  clean_input   = true
}
resource "azurerm_static_site" "staticapp" {
  name                = azurecaf_name.staticapp_name.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_size            = "Free"
  
  # Mark as web. Required for AZD to know where to deploy
  tags               = merge(local.tags, { azd-service-name : "web" })
}