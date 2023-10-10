output "app_url" {
  value = azurerm_container_app.container.latest_revision_fqdn
}