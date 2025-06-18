# SQL Server
resource "azurerm_mssql_server" "main" {
  name                         = "sqlserverhemanth"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password

  identity {
    type = "SystemAssigned"
  }
}

# SQL Database
resource "azurerm_mssql_database" "main" {
  name      = "sqldb-hemanth"
  server_id = azurerm_mssql_server.main.id
  sku_name  = "Basic"
}

# Private Endpoint for SQL Server
resource "azurerm_private_endpoint" "sql_private_endpoint" {
  name                = "sql-pe-hemanth"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.subnet_database.id

  private_service_connection {
    name                           = "sql-pe-connection"
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}
