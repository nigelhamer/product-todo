resource "azurecaf_name" "keyvault_name" {
  name          = local.name_format
  resource_type = "azurerm_key_vault_key"
  suffixes      = [var.environment_name]
  random_length = 0
  clean_input   = true
}

resource "azurerm_key_vault" "vault" {
  name                = azurecaf_name.keyvault_name.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.principal_id
    key_permissions = [
      "Get",
      "List",
    ]
  }
}