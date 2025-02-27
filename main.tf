provider "azurerm" {
  client_id       = "33c3ef55-4dc3-44c7-8131-bebc98031f41"
  client_secret   = "hG.8Q~OOSrtG5e_4J1DMMcdo~2lza2BfIiEknbGX"
  tenant_id       = "b4329df8-87bd-421e-941c-60801f6c2a51"
  subscription_id = "a5fdfee4-50cb-4ebc-9681-a8e2a2349fe5"
  features {}
}

resource "azurerm_resource_group" "rg1" {
  name     = "myTFResourceGroup16"
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


# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "myTFResourceGroup16"  # Resource group ka naam
  location = "East US"
}

# Create a Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "my-vnet"
  address_space        = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create a Subnet
resource "azurerm_subnet" "example" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefix       = "10.0.1.0/24"
}

# Create a Public IP address
resource "azurerm_public_ip" "example" {
  name                = "my-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

# Create a Network Interface
resource "azurerm_network_interface" "example" {
  name                      = "my-nic"
  location                  = azurerm_resource_group.example.location
  resource_group_name       = azurerm_resource_group.example.name
  subnet_id                = azurerm_subnet.example.id

  # ip_configuration block
  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"  # Correct placement inside ip_configuration
    public_ip_address_id          = azurerm_public_ip.example.id  # Associate public IP
  }
}

# Create a Linux Virtual Machine (Free Tier - B1S)
resource "azurerm_linux_virtual_machine" "example" {
  name                = "my-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"  # Free tier size
  admin_username      = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")  # Your public SSH key path
  }
  
  # Correct reference of network interface IDs
  network_interface_ids = [azurerm_network_interface.example.id]
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
}

# Output the public IP address of the VM
output "public_ip" {
  value = azurerm_public_ip.example.ip_address
}