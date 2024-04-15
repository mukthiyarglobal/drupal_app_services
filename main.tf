provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks-rg" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_service_plan" "my-service-plan" {
  name                = var.service_plan_name
  resource_group_name = azurerm_resource_group.aks-rg.name
  location            = azurerm_resource_group.aks-rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.my-web-app.identity.0.principal_id
}
resource "azurerm_container_registry" "acr" {
  name                = var.docker_registry_name
  resource_group_name = azurerm_resource_group.aks-rg.name
  location            = azurerm_resource_group.aks-rg.location
  sku                 = "Basic"
  admin_enabled       = true
}
resource "azurerm_linux_web_app" "my-web-app" {
  name                = var.web-app-name
  resource_group_name = azurerm_resource_group.aks-rg.name
  location            = azurerm_resource_group.aks-rg.location
  service_plan_id     = azurerm_service_plan.my-service-plan.id

  site_config {
    always_on = true
    application_stack {
      docker_image     = "${azurerm_container_registry.acr.login_server}/react-app"
      docker_image_tag = "latest"
    }
  }
  identity {
    type = "SystemAssigned"
  }
  app_settings = {
    DOCKER_REGISTRY_SERVER_URL      = azurerm_container_registry.acr.login_server
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password
    WEBSITES_PORT                   = var.websites_port
  }
}

resource "azurerm_mysql_flexible_server" "example" {
  name                   = "drupalserver"
  resource_group_name    = azurerm_resource_group.aks-rg.name
  location               = azurerm_resource_group.aks-rg.location
  administrator_login    = "mysqladmin"
  administrator_password = "Bics#123"
  sku_name               = "B_Standard_B1s"
  version                = "8.0.21"
}

resource "azurerm_mysql_flexible_database" "example" {
  name                = "drupaldb"
  resource_group_name = azurerm_resource_group.aks-rg.name
  server_name         = azurerm_mysql_flexible_server.example.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
resource "azurerm_mysql_flexible_server_firewall_rule" "example" {
  name                = "ClientIPAddress"
  resource_group_name = azurerm_resource_group.aks-rg.name
  server_name         = azurerm_mysql_flexible_server.example.name
  start_ip_address    = "14.143.71.246"
  end_ip_address      = "14.143.71.246"
}
