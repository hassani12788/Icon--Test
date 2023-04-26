resource "azurerm_private_dns_zone" "app_dns_zone" {
  name                = "iconapp.local"
  resource_group_name = var.rgname
  zone_type           = "Private"
}

resource "azurerm_private_dns_zone" "redis_dns_zone" {
  name                = "iconredis.local"
  resource_group_name = var.rgname
  zone_type           = "Private"
}

resource "azurerm_private_dns_zone" "sql_dns_zone" {
  name                = "iconsqldb.local"
  resource_group_name = var.rgname
  zone_type           = "Private"
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "icon-vnet-link"
  resource_group_name   = var.rgname
  private_dns_zone_id   = azurerm_private_dns_zone.app_dns_zone.id
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled = true
}
