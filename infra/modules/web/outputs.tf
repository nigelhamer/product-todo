output "SERVICE_WEB_NAME" {
  value = azurerm_static_site.web.name
}

output "SERVICE_WEB_URI" {
  value = "https://${azurerm_static_site.web.default_host_name}"
}


