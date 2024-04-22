resource "azurerm_dns_zone" "demobasedomain" {
  name                = local.basedomain
  resource_group_name = azurerm_resource_group.demorg.name
  depends_on = [
    azurerm_resource_group.demorg
  ]
}
