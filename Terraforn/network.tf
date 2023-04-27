# Create Resource Group
resource "azurerm_resource_group" "resourcegroup" {
  name     = var.rgname
  location = var.location
}
# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.rgname

}

# Create Subnets
resource "azurerm_subnet" "app_subnet" {
  name                 = "app-subnet"
  resource_group_name  = var.rgname
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = [var.address_prefixe_app]
}
resource "azurerm_subnet" "redis_subnet" {
  name                 = "redis-subnet"
  resource_group_name  = var.rgname
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = [var.address_prefix_redis]
}

resource "azurerm_subnet" "sql_subnet" {
  name                 = "sql-subnet"
  resource_group_name  = var.rgname
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = [var.address_prefix_sql]
}

resource "azurerm_subnet" "asa_subnet" {
  name                 = "asa-subnet"
  resource_group_name  = var.rgname
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = [var.address_prefix_asa]
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "vm-subnet"
  resource_group_name  = var.rgname
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = [var.address_prefix_vm]
}

