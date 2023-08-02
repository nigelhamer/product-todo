# Declare output values for the main terraform module.
#
# This allows the main terraform module outputs to be referenced by other modules,
# or by the local machine as a way to reference created resources in Azure for local development.
# Secrets should not be added here.
#
# Outputs are automatically saved in the local azd environment .env file.
# To see these outputs, run `azd env get-values`. `azd env get-values --output json` for json output.

output "AZURE_LOCATION" {
  value = var.location
}

output "AZURE_TENANT_ID" {
  value = data.azurerm_client_config.current.tenant_id
}

output "APPLICATIONINSIGHTS_CONNECTION_STRING" {
  value = nonsensitive(azurerm_application_insights.appinsights.connection_string)
}

output "AZURE_KEY_VAULT_ENDPOINT" {
  value = azurerm_key_vault.vault.vault_uri
}

output "AZURE_KEY_VAULT_NAME" {
  value = azurerm_key_vault.vault.name
}

output "REACT_APP_API_BASE_URL" {
  value = "https://${azurerm_linux_function_app.functionapp.name}.azurewebsites.net"
}

output "REACT_APP_APPLICATIONINSIGHTS_CONNECTION_STRING" {
  value = nonsensitive(azurerm_application_insights.appinsights.connection_string)
}

output "REACT_APP_WEB_BASE_URL" {
  value = "https://${azurerm_static_site.staticapp.default_host_name}"
}



