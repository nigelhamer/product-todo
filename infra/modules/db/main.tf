resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  tags                         = merge(var.tags, var.locator-tags)
  version                      = "12.0"
  administrator_login          = "mradministrator"
  administrator_login_password = "thisIsDog11"
}

resource "azurerm_mssql_database" "db" {
  name                        = var.database_name
  tags                        = var.tags
  server_id                   = azurerm_mssql_server.sqlserver.id
  sku_name                    = "GP_S_Gen5_1"
  zone_redundant              = false
  auto_pause_delay_in_minutes = 60
  min_capacity                = 0.5
}