# Create Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = var.storageaccountname
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.default_tags  
}

# Create Blob container
resource "azurerm_storage_container" "iconblob" {
  name                  = var.blobcontainer
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

# Create Private DNS Zone
resource "azurerm_private_dns_zone" "blob-dns-zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.rgname
}

# Create Private DNS Zone Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "blob_network_link" {
  name                  = "icon-blob_vnet-link"
  resource_group_name   = var.rgname
  private_dns_zone_name = azurerm_private_dns_zone.blob-dns-zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
# Create Private Endpoint
resource "azurerm_private_endpoint" "blob_endpoint" {
  depends_on          = [azurerm_storage_account.storage_account]  
  name                = "icon-blob-endpoint"
  location            = var.location
  resource_group_name = var.rgname
  subnet_id           = azurerm_subnet.asa_subnet.id

  private_service_connection {
    name                           = "icon-storage-account-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }
#  Private Endpoint Connecton
resource "azurerm_private_endpoint_connection" "blob_connection" {
  depends_on          = [azurerm_private_endpoint.blob_endpoint]  
  name                = "icon-blob-connection"
  resource_group_name = var.rgname
}
  # Create DNS A Record
resource "azurerm_private_dns_a_record" "blob_dns_a" {
  name                = "icon-blob-a"
  zone_name           = azurerm_private_dns_zone.blob-dns-zone.name
  resource_group_name = var.rgname
  ttl                 = 300
  records             = [azurerm_private_endpoint.blob_endpoint.private_service_connection.0.private_ip_address]
 }

}
