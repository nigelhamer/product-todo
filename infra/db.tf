# Deploy Database
resource "azurecaf_name" "sqlserver_name" {
  name          = local.name_format
  suffixes      = [var.environment_name]
  resource_type = "azurerm_sql_server"
  random_length = 0
  clean_input   = true
}
resource "azurerm_mssql_server" "sqlserver" {
  name                         = azurecaf_name.sqlserver_name.result
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  tags                         = local.tags
  version                      = "12.0"
  administrator_login          = "mradministrator"
  administrator_login_password = "thisIsDog11"
}

resource "azurerm_mssql_database" "db" {
  name      = "todo"
  tags      = local.tags
  server_id = azurerm_mssql_server.sqlserver.id
  sku_name  = "GP_S_Gen5_2"
}