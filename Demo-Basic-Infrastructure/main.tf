resource "random_uuid" "acctrandomnum" {
}

output "randomout" {
  value = lower(join("",["The azure storage Account name is: ","${var.storage_account_prefix}",substr(random_uuid.acctrandomnum.result,0,8)]))

}

resource "azurerm_resource_group" "demorg" {
  name     = local.resource_group_name
  location = local.location  
}


