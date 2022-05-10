output "vnet_name" {
  description = "vnet name"
  value       = azurerm_virtual_network.myvnet.name
}

output "subnet_name0" {
  # type        = list(string)
  description = "subnet name"
  value       = azurerm_subnet.mysubnet[0].id
}

output "subnet_name1" {
  # type        = list(string)
  description = "subnet name"
  value       = azurerm_subnet.mysubnet[1].id
}