/* 

https://developer.hashicorp.com/terraform/language/expressions/types

*/

variable "client_secret" {
  type = string
  sensitive = true
  description = "Please enter the client secret? "
}

variable "subdomain" {
  type = string
  description = "Subdomain for servers"
  default = "demo"
  
}

variable "basedomain" {
  type = string
  description = "Subdomain for servers"
  default = "fgds.cloud"
  
}

variable "vm_name" {
  type = string
  description = "Please provide Server name? "
  validation {
    condition = var.vm_name == lower(var.vm_name) && length(var.vm_name) > 4 && length(var.vm_name) <= 10
    error_message = "Please provide a name with only lowercase letters and with a langth of 5 to 10 chars in total"
  }
}

variable "azure_keyvault_name" {
  type = string
  default = "demokeyvaultcebcdd08"
  description = "Please provide name of Azure Key Vault? "
  validation {
    condition = var.azure_keyvault_name == lower(var.azure_keyvault_name) 
    error_message = "Please provide a name with only lowercase letters, try again"
  }  
}

variable "admin_user" {
    type = string
    default = "komplex"
    validation {
        condition = length(var.admin_user) >= 4 && length(var.admin_user) <= 8
        error_message = "Username for the admin account should be longer then 4 but less the 9"
    }
  
}
