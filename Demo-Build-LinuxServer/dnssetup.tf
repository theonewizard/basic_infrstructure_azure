data "azurerm_dns_zone" "demobasedomain" {
  name = var.basedomain
  resource_group_name = data.azurerm_resource_group.demorg.name
  depends_on = [
    data.azurerm_resource_group.demorg
  ]
}

resource "azurerm_dns_zone" "demosubdomain" {
  name                = join(".",[var.subdomain,var.basedomain])
  resource_group_name = data.azurerm_resource_group.demorg.name
  depends_on = [
    data.azurerm_resource_group.demorg
  ]
}

resource "azurerm_dns_ns_record" "addgluerecord" {
  name                = var.subdomain
  zone_name           = data.azurerm_dns_zone.demobasedomain.name
  resource_group_name = data.azurerm_resource_group.demorg.name
  ttl                 = 500

  records = azurerm_dns_zone.demosubdomain.name_servers

  depends_on = [
    data.azurerm_resource_group.demorg,
    azurerm_dns_zone.demosubdomain
  ]
}