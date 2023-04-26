resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "production-app-service-plan"
  resource_group_name = var.rgname
  location            = var.location
  sku_tier            = var.appsku
  sku_size            = var.appsize
}

resource "azurerm_app_service" "app_service" {
  name                = "icon-app-service"
  resource_group_name = var.rgname
  location            = var.location
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    always_on = true
  }
  
  identity {
    type = "SystemAssigned"
  }

  resource "azurerm_app_service_application_settings" "app_settings" {
  name                = azurerm_app_service.app_service.name
  resource_group_name = var.rgname
  app_settings = {
    "RedisConnectionString": "myredis.redis.cache.local:6380,(connection string)"
    "SqlConnectionString": "Server=mysqldb.database.local,1433;(connection String)"
    "WEBSITE_PRIVATE_ENDPOINT_ARM_ID" = azurerm_private_endpoint.my_endpoint.id
    "WEBSITE_PRIVATE_DNS_ZONE_NAME" = azurerm_private_dns_zone.my_dns_zone.name
    "STORAGE_ACCOUNT_NAME"        = azurerm_storage_account.storage_account.name
    "STORAGE_ACCOUNT_CONNECTION" = "BlobEndpoint=https://${azurerm_private_endpoint.storage_account_private_endpoint.private_service_connection[0].private_ip}:443/;AccountName=${azurerm_storage_account.storage_account.name};AccountKey=${azurerm_storage_account.storage_account.primary_access_key}"    
      }
 } 
}

resource "azurerm_private_endpoint" "app_service_endpoint" {
  depends_on          = [azurerm_app_service.app_service]  
  name                = "icon-app-service-endpoint"
  location            = var.location
  resource_group_name = var.rgname
  subnet_id           = azurerm_subnet.app_subnet.id

  private_service_connection {
    name                           = "app-service-connection"
    private_connection_resource_id = azurerm_app_service.app_service.id
    is_manual_connection           = true
    subresource_names              = ["scm"]
  }

  dns_zone_group {
    name            = "app-service-dns-zone-group"
    private_dns_zone_id = azurerm_private_dns_zone.app_dns_zone.id
  }
}
