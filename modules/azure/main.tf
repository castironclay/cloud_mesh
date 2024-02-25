resource "azurerm_resource_group" "resource_group" {
  location = var.location
  name     = var.name
}

resource "azurerm_virtual_network" "virtual_network" {
  address_space       = [var.network]
  location            = var.location
  name                = var.name
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "virtual_network_subnet" {
  address_prefixes     = [var.subnet]
  name                 = var.name
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
}

resource "azurerm_public_ip" "public_ip" {
  location            = var.location
  name                = var.name
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "security_group" {
  location            = var.location
  name                = var.name
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "Inbound"
    priority                   = 1001
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_interface" "network_interface" {
  location            = var.location
  name                = var.name
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = var.name
    subnet_id                     = azurerm_subnet.virtual_network_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_virtual_machine" "host1" {
  location              = var.location
  name                  = var.name
  network_interface_ids = [azurerm_network_interface.network_interface.id]
  resource_group_name   = azurerm_resource_group.resource_group.name
  vm_size               = var.size

  storage_os_disk {
    create_option     = "FromImage"
    name              = var.name
    caching           = "ReadWrite"
    managed_disk_type = "Premium_LRS"
  }
  provisioner "remote-exec" {
    inline = ["echo 'Im alive!'"]

    connection {
      type        = "ssh"
      user        = var.username
      private_key = file("./id_rsa")
      host        = azurerm_public_ip.public_ip.ip_address
    }
  }

  storage_image_reference {
    publisher = "Debian"
    offer     = "debian-11"
    version   = "latest"
    sku       = "11"
  }

  os_profile {
    admin_username = var.username
    computer_name  = var.name
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.username}/.ssh/authorized_keys"
      key_data = chomp(file("./id_rsa.pub"))
    }
  }
}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = azurerm_network_security_group.security_group.id
}
