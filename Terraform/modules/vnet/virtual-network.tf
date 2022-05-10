# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_prefix
  location            = var.rg_location
  resource_group_name = var.rg_name
  
  tags = {
    environment = "test"
  }
}
# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  count = length(var.subnet_names)
  name  = var.subnet_names[count.index]
  address_prefixes     = [var.subnet_prefixes[count.index]]
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  /*service_endpoints =  {
    subnet2 = ["Microsoft.Storage", "Microsoft.Sql"],
    subnet1 = ["Microsoft.AzureActiveDirectory","Microsoft.ServiceBus"]
  }*/

  service_endpoints = ["Microsoft.Sql"]

  depends_on = [azurerm_virtual_network.myvnet] 
}
