
data "azurerm_client_config" "current" {}


resource "tls_private_key" "linuxkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "linuxpemkey"{
  filename = "linuxkey.pem"
  content=tls_private_key.linuxkey.private_key_pem
  depends_on = [
    tls_private_key.linuxkey
  ]
}

resource "azurerm_key_vault" "azurekeywault" {
  name                        = lower(join("",["DemoKeyVault",substr(random_uuid.acctrandomnum.result,0,8)]))
  location                    = local.location
  resource_group_name         = local.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Backup",
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "Recover",
      "Restore",
      "SetIssuers",
      "Update"
    ]

    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover", 
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey",
      "Release",
      "Rotate",
      "GetRotationPolicy",
      "SetRotationPolicy"
    ]

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set"
    ]
  }

  depends_on = [
    azurerm_resource_group.demorg
  ]
}

output "azure_keyvault_name" {
  value = join(" ",["Azure Keyvault name:",lower(join("",["DemoKeyVault",substr(random_uuid.acctrandomnum.result,0,8)]))])
}
resource "random_password" "admin_password" {
  length           = 16
  upper            = true
  lower            = true
  special          = true
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 3
  min_special      = 2
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "vmpassword" {
  name         = var.admin_user
  value        = random_password.admin_password.result
  key_vault_id = azurerm_key_vault.azurekeywault.id
  depends_on = [
    azurerm_key_vault.azurekeywault,
    random_password.admin_password,
  ]
}

resource "azurerm_key_vault_secret" "vmprivsshkey" {
  name         = "demoprivatekey"
  value        = base64encode(trimspace(tls_private_key.linuxkey.private_key_pem))
  key_vault_id = azurerm_key_vault.azurekeywault.id

  depends_on = [
    local_file.linuxpemkey
  ]

}

resource "azurerm_ssh_public_key" "public_key" {
  name                = "demosshpublickey"
  resource_group_name = local.resource_group_name
  location            = local.location
  public_key          = tls_private_key.linuxkey.public_key_openssh
  depends_on = [
    azurerm_resource_group.demorg,
    tls_private_key.linuxkey
  ]
}
