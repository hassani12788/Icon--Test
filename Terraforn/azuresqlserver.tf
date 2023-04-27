# Create Azure SQL server
resource "azurerm_sql_server" "sql_server" {
  name                = "icon-sql-server"
  resource_group_name = var.rgname
  location            = var.location
  version             = "12.0"

  administrator_login          = var.sqlusername
  administrator_login_password = var.sqlpassword
}

# Create SQL DB
resource "azurerm_sql_database" "sql_db" {
  name                = var.dbname
  resource_group_name = var.rgname
  location            = var.location
  server_name         = azurerm_sql_server.sql_server.name
  edition             = var.dbedition
  collation           = var.dbcollation
  max_size_gb         = var.size
}
# Create a Private DNS Zone
resource "azurerm_private_dns_zone" "sql_dns_zone" {
  name                = "sqldb.local"
  resource_group_name = var.rgname
  zone_type           = "Private"
}

# Link the Private DNS Zone with the VNET
resource "azurerm_private_dns_zone_virtual_network_link" "sql-private-dns-link" {
  name = "icon-redis-vnet-link"
  resource_group_name = var.rgname
  private_dns_zone_name = azurerm_private_dns_zone.sql-dns.name
  virtual_network_id = azurerm_virtual_network.vnet.id
}

# Create a DB Private DNS Zone
resource "azurerm_private_dns_zone" "sql-endpoint-dns-private-zone" {
  name = "privatelink.database.windows.net"
  resource_group_name = var.rgname
}

#Create Private Endpoint
resource "azurerm_private_endpoint" "sql_endpoint" {
  depends_on          = [azurerm_sql_server.sql_server]  
  name                = "icon-sql-endpoint"
  location            = var.location
  resource_group_name = var.rgname
  subnet_id           = azurerm_subnet.sql_subnet.id

  private_service_connection {
    name                           = "icon-sql-connection"
    private_connection_resource_id = azurerm_sql_server.sql_server.id
    subresource_names              = ["database", azurerm_sql_database.sql_db.name]
  }

  dns_zone_group {
    name            = "icon-sql-dns-zone-group"
    private_dns_zone_id = azurerm_private_dns_zone.sql_dns_zone.id
  }
}
# DB Private Endpoint Connecton
resource "azurerm_private_endpoint_connection" "sql_connection" {
  depends_on          = [azurerm_private_endpoint.sql_endpoint]  
  name                = "icon-sql-connection"
  resource_group_name = var.rgname
}

# Create DNS Record
resource "azurerm_private_dns_a_record" "sql_a_record" {
  depends_on          = [azurerm_sql_server.sql_server]  
  name                = "icon-sqldb-a"
  zone_name           = azurerm_private_dns_zone.sql_dns_zone.name
  resource_group_name = var.rgname
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql_endpoint.ip_address]
}
