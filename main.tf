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