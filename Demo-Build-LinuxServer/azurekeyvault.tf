data "azurerm_key_vault" "azurekeyvault" {
  name                = lower(var.azure_keyvault_name)
  resource_group_name = data.azurerm_resource_group.demorg.name
  depends_on = [
    data.azurerm_resource_group.demorg
  ]
}