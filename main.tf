# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 1.1.0"
}

resource "azurerm_resource_group" "AK" {
  name     = "AK-RG"
  location = "eastus2"
}

resource "azurerm_network_security_group" "example" {
  name                = "AK-example-security-group"
  location            = azurerm_resource_group.AK.location
  resource_group_name = azurerm_resource_group.AK.name
}

resource "azurerm_virtual_network" "example" {
  name                = "AK-example-network"
  location            = azurerm_resource_group.AK.location
  resource_group_name = azurerm_resource_group.AK.name
  address_space       = ["10.121.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.121.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.121.2.0/24"
    security_group = azurerm_network_security_group.example.id
  }

  tags = {
    environment = "Production"
  }
}