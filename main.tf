#This code is used for creating the VM in Azure cloud
#second testing
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}
provider "azurerm" {
  features {
    
  }
  subscription_id = "00eee853-16f9-4fd6-bf25-8aba491040dd"
}
resource "azurerm_resource_group" "examplerg" {
  name     = "mmmrg"
  location = "West Europe"
}
resource "azurerm_virtual_network" "examplevnet" {
  name                = "mmmvnet"
  location            = azurerm_resource_group.examplerg.location
  resource_group_name = azurerm_resource_group.examplerg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "examplesubnet1" {
  name                 = "mmmsubnet1"
  resource_group_name  = azurerm_resource_group.examplerg.name
  virtual_network_name = azurerm_virtual_network.examplevnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "examplesubnet2" {
  name                 = "mmmsubnet2"
  resource_group_name  = azurerm_resource_group.examplerg.name
  virtual_network_name = azurerm_virtual_network.examplevnet.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_network_interface" "examplenic1" {
  name                = "mmmnic1"
  location            = azurerm_resource_group.examplerg.location
  resource_group_name = azurerm_resource_group.examplerg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.examplesubnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "examplenic2" {
  name                = "mmmnic2"
  location            = azurerm_resource_group.examplerg.location
  resource_group_name = azurerm_resource_group.examplerg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.examplesubnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "examplevm1" {
  name                = "mmmvm1"
  resource_group_name = azurerm_resource_group.examplerg.name
  location            = azurerm_resource_group.examplerg.location
  size                = "Standard_F2"
  admin_username      = "admin_user"
  admin_password      = "admin@123"
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.examplenic1.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "examplevm2" {
  name                = "mmmvm2"
  resource_group_name = azurerm_resource_group.examplerg.name
  location            = azurerm_resource_group.examplerg.location
  size                = "Standard_F2"
  admin_username      = "admin_user"
  admin_password      = "admin@123"
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.examplenic2.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}