/* 

https://developer.hashicorp.com/terraform/language/expressions/types

*/

variable "client_secret" {
  type = string
  sensitive = true
  default = ""
  description = "Please enter the client secret"
}

variable "github_token" {
  type = string
  sensitive = true
}
