provider "azurerm" {
  client_id       = "33c3ef55-4dc3-44c7-8131-bebc98031f41"
  client_secret   = "hG.8Q~OOSrtG5e_4J1DMMcdo~2lza2BfIiEknbGX"
  tenant_id       = "b4329df8-87bd-421e-941c-60801f6c2a51"
  subscription_id = "a5fdfee4-50cb-4ebc-9681-a8e2a2349fe5"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "myTFResourceGroup13"
  location = "westus2"
}


terraform {
  backend "remote" {
    organization = "area51coder"
    workspaces {
      name = "azureterra"
    }
  }
}