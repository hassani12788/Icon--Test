# Create a network interface
resource "azurerm_network_interface" "my_nic" {
  name                = "prod-network-interface"
  location            = var.location
  resource_group_name = var.rgname

    ip_configuration {
    name                          = "my-ip-config"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a virtual machine
resource "azurerm_windows_virtual_machine" "my_vm" {
  name                  = "prod-virtual-machine"
  location              = var.location
  resource_group_name   = var.rgname
  network_interface_ids = [azurerm_network_interface.my_nic.id]
  
  size     = var.vmsize
  admin_username = var.vmuser
  admin_password = var.vmpassword

# Install IIS and open port 80
  provisioner "remote-exec" {
    inline = [
      "Add-WindowsFeature Web-Server",
      "New-NetFirewallRule -DisplayName 'Allow HTTP Traffic' -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow"
    ]
  }
}
# Create a private endpoint
resource "azurerm_private_endpoint" "my_endpoint" {
  name                = "icon-private-endpoint"
  location            = var.location
  resource_group_name = var.rgname
  subnet_id           = azurerm_subnet.vm_subnet.id

  # Define the private link service
  private_service_connection {
    name                           = "icon-private-link-service"
    private_connection_resource_id = azurerm_windows_virtual_machine.my_vm.id
    is_manual_connection           = false
    subresource_names              = ["tcp/80"]
  }
}

# Create a private DNS zone and link it to the virtual network
resource "azurerm_private_dns_zone" "my_dns_zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.rgname
}

resource "azurerm_private_dns_zone_virtual_network_link" "my_dns_link" {
  name                  = "icon-dns-link"
  resource_group_name   = var.rgname
  private_dns_zone_name = azurerm_private_dns_zone.my_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.my_vnet.id
}

