# Deploy Database
resource "azurecaf_name" "sqlserver_name" {
  name          = local.name_format
  suffixes      = [var.environment_name]
  resource_type = "azurerm_sql_server"
  random_length = 0
  clean_input   = true
}

module "db" {
  source = "./modules/db"

  name                = azurecaf_name.sqlserver_name.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  database_name       = "todo"

  tags = local.tags
}