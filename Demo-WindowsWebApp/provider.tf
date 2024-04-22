terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.47.0"
    }
  }
}
/*
 Provide registory.terraform.io
*/
provider "azurerm" {
  subscription_id = "89cb6ba0-77f9-4d5e-a977-850b46673eed"
  tenant_id = "62444cd9-b5ea-44c5-b4fb-34e32df50fbf"
  client_id = "a752838e-1f1f-4290-85e5-44bf1a52bca7"
  client_secret = var.client_secret
  features {}
}

