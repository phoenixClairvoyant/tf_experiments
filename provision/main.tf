
resource "docker_image" "rct_static_web" {
  name         = "static_webapp_image"
  keep_locally = true
  build {
    context    = "../webapp"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "nginx" {
  image = docker_image.rct_static_web.image_id
  name  = "tutorial"
  ports {
    internal = 80
    external = 8080
  }
}


resource "azurerm_resource_group" "rg" {
  name     = "appservice-rg"
  location = "francecentral"
}



resource "azurerm_service_plan" "appserviceplan" {
  name                = "appserviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "P1v2"
}

resource "azurerm_windows_web_app" "frontwebapp" {
  name                = "<unique-frontend-app-name>"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id = azurerm_service_plan.appserviceplan.id

  site_config {}
  app_settings = {
    "WEBSITE_DNS_SERVER": "168.63.129.16",
    "WEBSITE_VNET_ROUTE_ALL": "1"
  }
}



resource "azurerm_windows_web_app" "backwebapp" {
  name                = "<unique-backend-app-name>"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id = azurerm_service_plan.appserviceplan.id

  site_config {}
}

# resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-assoc" {
#   network_interface_id    = azurerm_network_interface.nic.id
#   ip_configuration_name   = var.vm_ip_configuration_name
#   backend_address_pool_id = module.application_gateway_waf.application_gateway_backend_address_pool_ids[0]
# }

# resource "azurerm_storage_account" "partition_poc_apgw" {
#   name                     = "shephardtfdataaccount"
#   resource_group_name      = module.partition_resource_group.resource_group_name
#   location                 = module.partition_resource_group.resource_group_location
#   account_tier             = "Standard"
#   account_kind             = "StorageV2"
#   account_replication_type = "LRS"

#   static_website {
#     index_document = "index.html"
#   }
# }
# resource "azurerm_storage_blob" "partition_poc_apgw" {
#   for_each = fileset(path.module, "webapp/*")

#   name                   = trim(each.key, "webapp/")
#   storage_account_name   = azurerm_storage_account.partition_poc_apgw.name
#   storage_container_name = "$web"
#   type                   = "Block"
#   content_type           = "text/html"
#   source                 = each.key
# }
# resource "azurerm_network_interface" "nic" {
#   name                = "nic-core-application_gateway-poc"
#   location            = module.partition_resource_group.resource_group_location
#   resource_group_name = module.partition_resource_group.resource_group_name

#   ip_configuration {
#     name                          = "nic-ipconfig-core-application_gateway-poc"
#     subnet_id                     = "/subscriptions/abc4c8b4-2e98-48b3-ac23-17498266f10f/resourceGroups/euw-eai-ag-test-poc-rg/providers/Microsoft.Network/virtualNetworks/euw-eai-ag-test-poc-vnet/subnets/euw-eai-ag-test-main-poc-snet"
#     private_ip_address_allocation = "Dynamic"
#   }
# }


#app service
# Create the Linux App Service Plan
# resource "azurerm_service_plan" "appserviceplan" {
#   name                = "webapp-asp-${random_integer.ri.result}"
#   location            = module.partition_resource_group.resource_group_location
#   resource_group_name = module.partition_resource_group.resource_group_name
#   os_type             = "Linux"
#   sku_name            = "B1"
# }

# # Create the web app, pass in the App Service Plan ID
# resource "azurerm_linux_web_app" "webapp" {
#   name                      = "webapp-${random_integer.ri.result}"
#   location                  = module.partition_resource_group.resource_group_location
#   resource_group_name       = module.partition_resource_group.resource_group_name
#   service_plan_id           = azurerm_service_plan.appserviceplan.id
#   https_only                = true
#   virtual_network_subnet_id = var.application_subnet_id

#   site_config {
#     minimum_tls_version = "1.2"
#     ip_restriction {
#       action   = "Allow"
#       name     = "Allow App Gateway Connection"
#       priority = 200
#       service_tag               = "Microsoft.Web"
#       # ip_address                = module.application_gateway_waf.application_gateway_private_ip_address
#       #virtual_network_subnet_id = module.application_gateway_waf.application_gateway_subnet_id
#     }
#   }
# }
