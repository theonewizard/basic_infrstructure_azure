



resource "azurerm_storage_account" "azurestgaccount" {
  name                     = lower(join("",["${var.storage_account_prefix}",substr(random_uuid.acctrandomnum.result,0,8)]))
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"  

  network_rules {
    default_action             = "Deny"
    ip_rules                   = [local.remote_access_prefix]
    virtual_network_subnet_ids = tolist(azurerm_subnet.demosubnet.*.id)
  }

    depends_on = [
    azurerm_resource_group.demorg,
    azurerm_subnet.demosubnet,
   ]
}

resource "azurerm_storage_container" "demodatablob" {
  name                  = "demodatablob"
  storage_account_name  = azurerm_storage_account.azurestgaccount.name
  container_access_type = "blob"
  depends_on=[
    azurerm_storage_account.azurestgaccount
    ]
}
/*
resource "azurerm_storage_blob" "redhat-iso" {
  name                   = "rhel-baseos-9.1-aarch64-boot.iso"
  storage_account_name   = azurerm_storage_account.azurestgaccount.name
  storage_container_name = azurerm_storage_container.demodatablob.name
  type                   = "Page"
  source                 = "D:\\iso\\rhel-baseos-9.1-aarch64-boot.iso"
   depends_on=[
    azurerm_storage_container.demodatablob
   ]
}
*/

