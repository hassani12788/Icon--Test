resource "azurerm_sql_server" "sql_server" {
  name                = "icon-sql-server"
  resource_group_name = var.rgname
  location            = var.location
  version             = "12.0"

  administrator_login          = var.sqlusername
  administrator_login_password = var.sqlpassword
}

resource "azurerm_sql_database" "sql_db" {
  name                = var.dbname
  resource_group_name = var.rgname
  location            = var.location
  server_name         = azurerm_sql_server.sql_server.name
  edition             = var.dbedition
  collation           = var.dbcollation
  max_size_gb         = var.size
}

resource "azurerm_private_endpoint" "sql_endpoint" {
  depends_on          = [azurerm_sql_server.sql_server]  
  name                = "icon-sql-endpoint"
  location            = var.location
  resource_group_name = var.rgname
  subnet_id           = azurerm_subnet.sql_subnet.id

  private_service_connection {
    name                           = "sql-connection"
    private_connection_resource_id = azurerm_sql_server.sql_server.id
    subresource_names              = ["database", azurerm_sql_database.sql_db.name]
  }

  dns_zone_group {
    name            = "sql-dns-zone-group"
    private_dns_zone_id = azurerm_private_dns_zone.sql_dns_zone.id
  }
}
resource "azurerm_private_endpoint_connection" "sql_connection" {
  depends_on          = [azurerm_private_endpoint.sql_endpoint]  
  name                = "icon-sql-connection"
  resource_group_name = var.rgname
  private_endpoint_id = azurerm_private_endpoint.sql_endpoint.id
  remote_resource_id  = azurerm_app_service.app_service.id
  is_manual_connection = true
  subresource_names   = ["sql"]
}
resource "azurerm_private_dns_a_record" "sql_a_record" {
  depends_on          = [azurerm_sql_server.sql_server]  
  name                = "iconsqldb"
  zone_name           = azurerm_private_dns_zone.sql_dns_zone.name
  resource_group_name = var.rgname
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql_endpoint.ip_address]
}