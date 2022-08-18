provider "azurerm" {
  version = "=1.41.0"
}
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "DEV-Appserviceplan"
  location            = "eastus" 
  resource_group_name = "DEV-TF-RG" 

  kind = "Linux"
  
  sku {
    tier = "Standard"
    size = "S1"
  }

  properties {
    reserved = true # Mandatory for Linux plans
  }
}
resource "azurerm_app_service" "appservice_dataservice"{
  name                = "data-appservice"
  location            =  "eastus"
  resource_group_name =  "DEV-TF-RG"
  app_service_plan_id =  azurerm_app_service_plan.appserviceplan.id
  
  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

    /*
    # Settings for private Container Registires  
    DOCKER_REGISTRY_SERVER_URL      = ""
    DOCKER_REGISTRY_SERVER_USERNAME = ""
    DOCKER_REGISTRY_SERVER_PASSWORD = ""
    */
  }
site_config {
    linux_fx_version = "DOCKER|appsvcsample/static-site:latest"
    always_on        = "true"
  }

  identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_app_service_source_control" "appservice" {
  app_id   = azurerm_app_service.appservice_dataservice.id
  repo_url = "https://github.com/kumarkasula/appservicd.tf.git"
  branch   = "main"
  use_manual_integration = true
  use_mercurial      = false
}
