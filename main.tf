provider "azurerm" {
  client_id       = "33c3ef55-4dc3-44c7-8131-bebc98031f41"
  client_secret   = "hG.8Q~OOSrtG5e_4J1DMMcdo~2lza2BfIiEknbGX"
  tenant_id       = "b4329df8-87bd-421e-941c-60801f6c2a51"
  subscription_id = "a5fdfee4-50cb-4ebc-9681-a8e2a2349fe5"
  features {}
}

terraform {
  backend "remote" {
    organization = "area51coder"
    workspaces {
      name = "azureterra"
    }
  }
}




resource "azurerm_resource_group" "rg" {
  name     = "myTFResourceGroup2"
  location = "westus2"
    tags = {
    Environment = "Terraform Getting Started"
    Team = "DevOps"
}
}



# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "myTFVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "westus2"
  resource_group_name = azurerm_resource_group.rg.name
}

