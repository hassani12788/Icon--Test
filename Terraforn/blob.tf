resource "azurerm_storage_account" "storage_account" {
  name                     = "iconstorageaccount"
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}
resource "azurerm_private_dns_zone" "storage_account_dns_zone" {
  depends_on          = [azurerm_storage_account.storage_account]  
  name                = "iconstorageaccount.local"
  resource_group_name = var.rgname
}

resource "azurerm_private_endpoint" "storage_account_endpoint" {
  depends_on          = [azurerm_storage_account.storage_account]  
  name                = "storage-endpoint"
  location            = var.location
  resource_group_name = var.rgname
  subnet_id           = azurerm_subnet.asa_subnet.id

  private_service_connection {
    name                           = "storage-account-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }

  dns_zone_id = azurerm_private_dns_zone.storage_account_dns_zone.id
  custom_dns_configs {
    name = "privatelink.blob.core.windows.net"
    ip_addresses = [
      azurerm_storage_account.storage_account.primary_blob_endpoint,
    ]
  }
}
