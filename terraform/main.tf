terraform{
  backend "azurerm"{
  resource_group_name = "rg-terraform-backend"
  storage_account_name = "tfstate2002"
  container_name = "tfstate"
  key = "dev.terraform.tfstate"

  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

}

module "resource_group" {
  source   = "./modules/resource-group"
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name = "vnet-demo"
  address_space = ["10.0.0.0/16"]
  location = var.location
  resource_group_name = var.resource_group_name
}
resource "azurerm_subnet" "subnet" {
  name = "subnet-demo"
  resource_group_name =var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.1.0/24"]
  
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-demo"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_public_ip" "vm_ip" {
  name                = "vm-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_network_interface" "nic" {
  name                = "vm-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "linux-vm-demo"
  resource_group_name =  var.resource_group_name
  location            = var.location
size                = "Standard_D2as_v5"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

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