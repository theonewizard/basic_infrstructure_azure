
data "template_file" "cloudinitdata" {
    template = file("script.sh")
}

data "azurerm_key_vault_secret" "linuxpemkey" {
  name         = "demoprivatekey"
  key_vault_id = data.azurerm_key_vault.azurekeyvault.id
}

resource "local_file" "linuxpemkey"{
  filename = "linuxkey.pem"
  content = base64decode(data.azurerm_key_vault_secret.linuxpemkey.value)
  depends_on = [
    data.azurerm_key_vault_secret.linuxpemkey
  ]
}

data "azurerm_ssh_public_key" "linuxvm_public_key" {
  name                = "demosshpublickey"
  resource_group_name = data.azurerm_resource_group.demorg.name
  depends_on = [
    data.azurerm_resource_group.demorg
  ]
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                = var.vm_name
  resource_group_name = data.azurerm_resource_group.demorg.name
  location            = data.azurerm_resource_group.demorg.location
  size                = "Standard_D2s_v3"
  admin_username      = "komplex"
  custom_data = base64encode(data.template_file.cloudinitdata.rendered)
  network_interface_ids = [
    azurerm_network_interface.appinterface.id
  ]

   admin_ssh_key {
     username = var.admin_user
     public_key = data.azurerm_ssh_public_key.linuxvm_public_key.public_key
   }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = 100
    
  }

 # Enable Serial Console on Azure  

  boot_diagnostics {
    storage_account_uri = null
  }
  
  source_image_reference {
    publisher = "redhat"
    offer     = "rhel-raw"
    sku       = "86-gen2"
    version   = "latest"
  }
 
  depends_on = [
    azurerm_network_interface.appinterface,
    data.azurerm_resource_group.demorg,
    data.azurerm_key_vault_secret.linuxpemkey
    
  ]
}

resource "azurerm_dns_a_record" "linuxsrvArecord" {
  name                = azurerm_linux_virtual_machine.linuxvm.name
  zone_name           = azurerm_dns_zone.demosubdomain.name
  resource_group_name = data.azurerm_resource_group.demorg.name
  ttl                 = 300
  records             = [azurerm_public_ip.appip.ip_address]
  depends_on = [
    azurerm_dns_zone.demosubdomain,
    azurerm_linux_virtual_machine.linuxvm
  ]
}

output "vm_name_and_ip" {
  value = join(" ",["VM name:","${azurerm_linux_virtual_machine.linuxvm.name}", "Has been given the ip of","${azurerm_public_ip.appip.ip_address}"])
  }
