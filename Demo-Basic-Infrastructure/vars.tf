/* 

https://developer.hashicorp.com/terraform/language/expressions/types

*/

variable "client_secret" {
  type = string
  sensitive = true
  description = "Please enter the client secret"
}

variable "number_of_subnets" {
  type = number
  default = 1
  description = "How many subnets is needed (valid numbers are 1 to 250)?"
  validation {
    condition = var.number_of_subnets < 250 && var.number_of_subnets > 0
    error_message = "Only allowed number of subnets is 1 to 250 "
  }
}

variable "storage_account_prefix" {
  type = string
  description = "prefix for storage account name"
  validation {
    condition = length(var.storage_account_prefix) > 4 
    error_message = "Account prefix needs to extend to more then 4 chars"
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
