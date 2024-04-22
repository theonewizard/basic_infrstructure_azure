resource "azurerm_virtual_network" "demonetwork" {
  name                = local.virtual_network.name
  location            = local.location  
  resource_group_name = local.resource_group_name
  address_space       = [local.virtual_network.address_space]
  depends_on = [
    azurerm_resource_group.demorg
  ]  
} 


resource "azurerm_subnet" "demosubnet" {    
  count = var.number_of_subnets
    name                 = "subnet-${count.index}"
    resource_group_name  = local.resource_group_name
    virtual_network_name = local.virtual_network.name
    address_prefixes     = ["10.0.${count.index}.0/24"]
    service_endpoints = ["Microsoft.Storage"]
    depends_on = [
      azurerm_virtual_network.demonetwork
    ]
}

resource "azurerm_network_security_group" "demonsg" {
  name                = "demonsg"
  location            = local.location 
  resource_group_name = local.resource_group_name

dynamic security_rule {
  for_each = local.network_security_rules
  content {
    name                       = "${security_rule.value.access}-${security_rule.value.rule_name}"
    priority                   = security_rule.value.rule_number
    description                = security_rule.value.rule_description
    access                     = security_rule.value.access
    direction                  = security_rule.value.direction
    source_address_prefix      = security_rule.value.source_address_prefix
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = security_rule.value.port_range
    protocol                   = security_rule.value.protocol
  }
  
}

depends_on = [
    azurerm_virtual_network.demonetwork
  ]
}

resource "azurerm_subnet_network_security_group_association" "appnsg-link" {  
  count = var.number_of_subnets
  subnet_id                 = azurerm_subnet.demosubnet[count.index].id
  network_security_group_id = azurerm_network_security_group.demonsg.id

  depends_on = [
    azurerm_virtual_network.demonetwork,
    azurerm_network_security_group.demonsg
  ]
}

