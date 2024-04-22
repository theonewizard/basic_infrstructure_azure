locals {
  resource_group_name="gulager_demo_rg"
  location="North Europe"
  basedomain = "fgds.cloud"
  remote_access_prefix = "82.183.40.10"
  virtual_network = {
    name="demo-network"
    address_space="10.0.0.0/16"
  }
  network_security_rules = [
    {
      rule_number = 100
      rule_name = "RDP"
      rule_description = "Allow RDP traffic"
      access = "Allow"
      port_range = 3389
      source_address_prefix = local.remote_access_prefix
      direction = "Inbound"
      protocol = "Tcp"
    },
    {
      rule_number = 101
      rule_name = "SSH"
      rule_description = "Allow SSH traffic"
      access = "Allow"
      port_range = 22
      direction = "Inbound"
      source_address_prefix = local.remote_access_prefix
      protocol = "Tcp"
    },
  ]
}