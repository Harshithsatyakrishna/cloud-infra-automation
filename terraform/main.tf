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