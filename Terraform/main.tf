resource "azurerm_resource_group" "myrg" {
  name = var.resoure_group_name
  location = var.resoure_group_location

  tags = {
    environment = "test"
  }
}

module "vnet-module" {
  source = "./modules/vnet"

  # Resource Group
  rg_name = azurerm_resource_group.myrg.name
  rg_location = azurerm_resource_group.myrg.location

  # Vnet and subnet Resource 
  vnet_name = "myvnet-test"
  vnet_address_prefix = ["10.0.0.0/16"]
  subnet_names = ["subnet1-test", "subnet2-test"]
  subnet_prefixes = ["10.0.1.0/24","10.0.2.0/24"]
}

