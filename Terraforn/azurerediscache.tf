# Create Azire Cache for Redis
resource "redis_cache" "cache" {
  name                = "icon-redis-cache"
  resource_group_name = var.rgname
  location            = var.location
  sku                 = var.redissku
  capacity            = var.rediscapacity

  tags = var.default_tags
  
}

# Create a Private DNS Zone
resource "azurerm_private_dns_zone" "redis_dns_zone" {
  name                = "redis.local"
  resource_group_name = var.rgname
  zone_type           = "Private"
}

# Link the Private DNS Zone with the VNET
resource "azurerm_private_dns_zone_virtual_network_link" "redis-private-dns-link" {
  name = "redis-vnet-link"
  resource_group_name = var.rgname
  private_dns_zone_name = azurerm_private_dns_zone.redis-dns.name
  virtual_network_id = azurerm_virtual_network.vnet.id
}


# Create Private Endpoint
resource "azurerm_private_endpoint" "redis_endpoint" {
  depends_on          = [redis_cache.cache]  
  name                = "icon-redis-endpoint"
  location            = var.location
  resource_group_name = var.rgname
  subnet_id           = azurerm_subnet.redis_subnet.id

  private_service_connection {
    name                           = "icon-redis-connection"
    private_connection_resource_id = redis_cache.cache.id
  }

  dns_zone_group {
    name            = "icon-redis-dns-zone-group"
    private_dns_zone_id = azurerm_private_dns_zone.redis_dns_zone.id
  }
}

# Create Private Endpoint Connection

resource "azurerm_private_endpoint_connection" "redis_connection" {
  depends_on          = [azurerm_private_endpoint.redis_endpoint]  
  name                = "icon-redis-connection"
  resource_group_name = var.rgname
  private_endpoint_id = azurerm_private_endpoint.redis_endpoint.id
  remote_resource_id  = azurerm_app_service.app_service.id
  is_manual_connection = true
  subresource_names   = ["redis"]
}

# Create DNS Record
resource "azurerm_private_dns_a_record" "redis_a_record" {
  depends_on          = [redis_cache.cache]  
  name                = "icon-redis-a"
  zone_name           = azurerm_private_dns_zone.redis_dns_zone.name
  resource_group_name = var.rgname
  ttl                 = 300
  records             = [aazurerm_private_endpoint.redis_endpoint.static_ip_address]
}
