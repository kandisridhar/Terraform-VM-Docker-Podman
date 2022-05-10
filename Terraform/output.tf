output "resource_group_name" {
  value = azurerm_resource_group.myrg.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.myterraformvm.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

output "public_ip_address1" {
  value = azurerm_linux_virtual_machine.myterraformvm1.public_ip_address
}

output "tls_private_key1" {
  value     = tls_private_key.example_ssh1.private_key_pem
  sensitive = true
}

output username {
value = "${data.vault_generic_secret.username.data["username"]}"
sensitive = true
}