/* Jumphost for clients

resource "azurerm_public_ip" "bastianip" {
  name                = "bastianpubip"
  location            = local.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  depends_on = [
    azurerm_resource_group.demorg
  ]
}

resource "azurerm_subnet" "azurebastiansubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.demonetwork.name
  address_prefixes     = ["10.0.251.0/24"]

  depends_on = [
    azurerm_resource_group.demorg,
    azurerm_virtual_network.demonetwork,
  ]
}

resource "azurerm_bastion_host" "bastianhost" {
  name                = "demobastian"
  location            = local.location
  resource_group_name = local.resource_group_name
  sku                 = "Standard"
  file_copy_enabled   = true
  tunneling_enabled   = true

  ip_configuration {
    name                 = "bastianip"
    subnet_id            = azurerm_subnet.azurebastiansubnet.id
    public_ip_address_id = azurerm_public_ip.bastianip.id
  }
  depends_on = [
    azurerm_resource_group.demorg,
    azurerm_subnet.demosubnet,
    azurerm_public_ip.bastianip,
  ]
}

*/