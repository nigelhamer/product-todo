resource "azurerm_static_site" "web" {
  name                = var.name
  location            = "westeurope"
  resource_group_name = var.resource_group_name
  tags                = var.tags
  sku_size            = "Free"
}