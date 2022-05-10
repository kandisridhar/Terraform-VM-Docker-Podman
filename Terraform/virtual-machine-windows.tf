# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  name                = var.pip_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "vm-app-test1"
  tags = {
    environment = "test"
  }
}

# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  name                = var.nic_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    # subnet_id                     = azurerm_subnet.mysubnet[0].id
    subnet_id = module.vnet-module.subnet_name0
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
  tags = {
    environment = "test"
  }

  depends_on = [module.vnet-module.vnet_name] 
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "app_SecurityGroup"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.myvmnic.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

resource "azurerm_network_interface_security_group_association" "example1" {
  network_interface_id      = azurerm_network_interface.myvmnic1.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm" {
  name                = var.appvm
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  network_interface_ids = [azurerm_network_interface.myvmnic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  /*boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }*/
}
resource "azurerm_virtual_machine_extension" "vm_extension_install_docker" {
  name                 = "vm_extension_install_docker"
  virtual_machine_id = azurerm_linux_virtual_machine.myterraformvm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "${base64encode(templatefile("custom_script.sh", {
          vmname="${azurerm_linux_virtual_machine.myterraformvm.name}"
        }))}"
    }
SETTINGS
}


# Create Public IP Address
resource "azurerm_public_ip" "mypublicip1" {
  name                = "podman_pip"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "vm-app-test2"
  tags = {
    environment = "test"
  }
}

# Create Network Interface
resource "azurerm_network_interface" "myvmnic1" {
  name                = "podman_nic"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    # subnet_id                     = azurerm_subnet.mysubnet[0].id
    subnet_id = module.vnet-module.subnet_name0
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip1.id 
  }
  tags = {
    environment = "test"
  }

  depends_on = [module.vnet-module.vnet_name] 
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm1" {
  name                = "podman-vm"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  network_interface_ids = [azurerm_network_interface.myvmnic1.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk1"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm1"
  admin_username                  = "${data.vault_generic_secret.username.data["username"]}"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "${data.vault_generic_secret.username.data["username"]}"
    public_key = tls_private_key.example_ssh1.public_key_openssh
  }

  /*boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }*/
}
resource "azurerm_virtual_machine_extension" "vm_extension_install_podman" {
  name                 = "vm_extension_install_podman"
  virtual_machine_id   = azurerm_linux_virtual_machine.myterraformvm1.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "${base64encode(templatefile("custom_script1.sh", {
          vmname="${azurerm_linux_virtual_machine.myterraformvm1.name}"
        }))}"
    }
SETTINGS
}
