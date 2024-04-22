
data "azurerm_virtual_network" "demonetwork" {
  name = "demo-network"
  resource_group_name  = data.azurerm_resource_group.demorg.name
}

data "azurerm_subnet" "demosubnet" {    
    name = "subnet-0"
    virtual_network_name = data.azurerm_virtual_network.demonetwork.name
    resource_group_name  = data.azurerm_resource_group.demorg.name
}

resource "azurerm_network_interface" "appinterface" {
  name                = "appinterface"
  location            = data.azurerm_resource_group.demorg.location
  resource_group_name = data.azurerm_resource_group.demorg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.demosubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.appip.id
  }
  depends_on = [
    data.azurerm_subnet.demosubnet
  ]
}

resource "azurerm_public_ip" "appip" {
  name                = "app-ip"
  resource_group_name = data.azurerm_resource_group.demorg.name
  location            = data.azurerm_resource_group.demorg.location
  allocation_method   = "Static"
  domain_name_label = join("-",[var.vm_name,var.subdomain,join("-",split(".",var.basedomain))])
  reverse_fqdn = join(".",[var.vm_name,var.subdomain,var.basedomain]) 

 depends_on = [
   data.azurerm_resource_group.demorg
 ]
}
