resource "azurerm_source_control_token" "githubtoken" {
  type  = "GitHub"
  token = var.github_token
  depends_on = [
    data.azurerm_resource_group.demorg,
    azurerm_app_service_source_control.webappsource
  ]
}

resource "azurerm_service_plan" "demowebwinsp" {
  name                = "demowebwinsp"
  resource_group_name = local.resource_group_name
  location            = local.location
  os_type             = "Windows"
  sku_name            = "S1"
  depends_on = [
    data.azurerm_resource_group.demorg
  ]
}

resource "azurerm_windows_web_app" "demowebsite" {
  name                = "komplexdemowebsite"
  resource_group_name = local.resource_group_name
  location            = local.location
  service_plan_id     = azurerm_service_plan.demowebwinsp.id
  https_only = true
  

  site_config {
    application_stack {
      current_stack="dotnet"
      dotnet_version="v6.0"
    }

  }

  depends_on = [
    azurerm_service_plan.demowebwinsp
  ]
}

resource "azurerm_app_service_source_control" "webappsource" {
  app_id  = azurerm_windows_web_app.demowebsite.id
  repo_url = "https://github.com/Komplex-it/Gulager_KomplexDemoWebApp.git"
  branch   = "master"

  
  depends_on = [
    azurerm_windows_web_app.demowebsite
  ]
}

resource "azurerm_windows_web_app_slot" "demowebsite-lifecycle" {
    for_each = toset(["dev","staging","preprod"])
  name           = each.key
  app_service_id = azurerm_windows_web_app.demowebsite.id

  site_config {}
  depends_on = [
    azurerm_windows_web_app.demowebsite
  ]
}

resource "azurerm_app_service_source_control_slot" "createappstages" {
    for_each = {
                 "dev" = 0
                 "staging" = 1
                 "preprod" = 2 
    }
  slot_id  = azurerm_windows_web_app_slot.demowebsite-lifecycle[each.key].id
  repo_url = "https://github.com/Komplex-it/Gulager_KomplexDemoWebApp.git"
  branch   = each.key
  depends_on = [
    azurerm_windows_web_app_slot.demowebsite-lifecycle
  ]
}