output "acr_id" {
  value = azurerm_container_registry.acr.id
}
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}
output "webapp_name" {
  value = azurerm_linux_web_app.my-web-app.name
}
