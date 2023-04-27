# Create a network interface
resource "azurerm_network_interface" "my_nic" {
  name                = var.vmnicname
  location            = var.location
  resource_group_name = var.rgname

    ip_configuration {
    name                          = "icon-ip-config"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a virtual machine
resource "azurerm_windows_virtual_machine" "my_vm" {
  name                  = var.vmname
  location              = var.location
  resource_group_name   = var.rgname
  network_interface_ids = [azurerm_network_interface.my_nic.id]
  
  size                  = var.vmsize

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = var.osdiskname
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.computername
    admin_username = var.vmuser
    admin_password = var.vmpassword
  }

  os_profile_windows_config {
    enable_automatic_updates = true
  }


# Install IIS and open port 443
  provisioner "remote-exec" {
    inline = [
      "Add-WindowsFeature Web-Server",
      "New-NetFirewallRule -DisplayName 'Allow HTTP Traffic' -Direction Inbound -LocalPort 443 -Protocol TCP -Action Allow"
    ]
  }
}
# Create Private DNS Zone
resource "azurerm_private_dns_zone" "vm-dns-zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.rgname
}

# Create Private DNS Zone Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "vm_network_link" {
  name                  = "icon-vm-vnet-link"
  resource_group_name   = var.rgname
  private_dns_zone_name = azurerm_private_dns_zone.vm-dns-zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

# Create a private endpoint
resource "azurerm_private_endpoint" "my_endpoint" {
  name                = "icon-vm-private-endpoint"
  location            = var.location
  resource_group_name = var.rgname
  subnet_id           = azurerm_subnet.vm_subnet.id

  private_service_connection {
    name                           = "icon-vm-account-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_windows_virtual_machine.my_vm.id
  }


  # Define the private link service
  private_service_connection {
    name                           = "icon-vm-link-service"
    private_connection_resource_id = azurerm_windows_virtual_machine.my_vm.id
    is_manual_connection           = false
    subresource_names              = ["tcp/443"]
  }
}

# create DNS Record
resource "azurerm_private_dns_a_record" "vm-dns-zone" {
name = "icon-vm-dns-a"
zone_name = azurerm_private_dns_zone.vm-dns-zone.name
resource_group_name = var.rgname
ttl = 300
records = [azurerm_network_interface.my_nic.private_ip_address]
}

