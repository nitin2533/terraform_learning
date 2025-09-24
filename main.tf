#This code is used for creating the VM in Azure cloud
#minikubevm
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
  subscription_id = "b7341b17-2d83-4170-ba3e-275f8b52b7d2"
}
resource "azurerm_resource_group" "examplerg" {
  name     = "rg-minikube"
  location = "central india"
}
resource "azurerm_virtual_network" "examplevnet" {
  name                = "vnet-minikube"
  location            = azurerm_resource_group.examplerg.location
  resource_group_name = azurerm_resource_group.examplerg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "examplesubnet1" {
  name                 = "subnet-minikube"
  resource_group_name  = azurerm_resource_group.examplerg.name
  virtual_network_name = azurerm_virtual_network.examplevnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

#resource "azurerm_subnet" "examplesubnet2" {
#  name                 = "subnet2-minikube"
#  resource_group_name  = azurerm_resource_group.examplerg.name
#virtual_network_name = azurerm_virtual_network.examplevnet.name
# address_prefixes     = ["10.0.2.0/24"]
#}

resource "azurerm_public_ip" "examplepubip1" {
  name                = "pubip_minikube1"
  location            = azurerm_resource_group.examplerg.location
  resource_group_name = azurerm_resource_group.examplerg.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

#resource "azurerm_public_ip" "examplepubip2" {
#  name                = "pubip_minikube2"
#  location            = azurerm_resource_group.examplerg.location
#  resource_group_name = azurerm_resource_group.examplerg.name
#  allocation_method   = "Static"
# sku                 = "Basic"
#}

resource "azurerm_network_interface" "examplenic1" {
  name                = "nic-minikube"
  location            = azurerm_resource_group.examplerg.location
  resource_group_name = azurerm_resource_group.examplerg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.examplesubnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.examplepubip1.id
  }
}

/*resource "azurerm_network_interface" "examplenic2" {
  name                = "nic2-minikube"
  location            = azurerm_resource_group.examplerg.location
  resource_group_name = azurerm_resource_group.examplerg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.examplesubnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.examplepubip2.id
  }
}*/



resource "azurerm_linux_virtual_machine" "examplevm1" {
  name                = "minikubevm"
  resource_group_name = azurerm_resource_group.examplerg.name
  location            = azurerm_resource_group.examplerg.location
  size                = "Standard_F2"
  admin_username      = "minikube"
  admin_password      = "minikube@123"
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

/*resource "azurerm_linux_virtual_machine" "examplevm2" {
  name                = "minikubevm2"
  resource_group_name = azurerm_resource_group.examplerg.name
  location            = azurerm_resource_group.examplerg.location
  size                = "Standard_F2"
  admin_username      = "minikube"
  admin_password      = "minikube@123"
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
}*/