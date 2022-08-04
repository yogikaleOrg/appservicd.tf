provider "azurerm" {
  features {}
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "DEV-Appserviceplan"
  location            = "eastus" 
  resource_group_name = "DEV-TF-RG" 

  sku {
    tier = "Standard"
    size = "S1"
  }
}
resource "azurerm_app_service" "appservice_dataservice"{
  name                = "data-appservice"
  location            =  "eastus"
  resource_group_name =  "DEV-TF-RG"
  app_service_plan_id =  azurerm_app_service_plan.appserviceplan.id
  site_config {}
}
resource "azurerm_app_service_source_control" "appservice" {
  app_id   = azurerm_app_service.appservice_dataservice.id
  repo_url = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch   = "master"
  use_manual_integration = true
  use_mercurial      = false
}

