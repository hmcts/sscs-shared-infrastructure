terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.108.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

