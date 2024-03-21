variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}
variable "location" {
  type        = string
  description = "Resources location in Azure"
}
variable "service_plan_name" {
  type        = string
  description = "service_plan name"
}
variable "docker_registry_name" {
  type        = string
  description = "acr_name"
}
variable "web-app-name" {
  type        = string
  description = "app-service name"
}
variable "websites_port" {
  type        = string
  description = "port_number"
}
# variable "mysql_server_name" {
#   type        = string
#   description = "Name of the MySQL Server"
# }

# variable "mysql_username" {
#   type        = string
#   description = "MySQL administrator username"
# }

# variable "mysql_password" {
#     type      = string
#   description = "MySQL administrator password"
# }

# variable "mysql_database_name" {
#   type        = string
#   description = "Name of the MySQL Database"

# }

