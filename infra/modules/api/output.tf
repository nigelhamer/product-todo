output "API_IDENTITY_PRINCIPAL_ID" {
  value = azurerm_linux_function_app.apiapp.identity
}

output "API_NAME" {
  value = azurerm_linux_function_app.apiapp.name
}

output "API_URI" {
  value = "https://${azurerm_linux_function_app.apiapp.default_hostname}"
}

