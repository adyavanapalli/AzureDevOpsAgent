terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  common_resource_suffix = "azdevopsagent-eastus"
}

data "azurerm_resource_group" "resource_group" {
  name = "rg-${local.common_resource_suffix}"
}

data "azurerm_subscription" "subscription" {}

resource "azurerm_virtual_network" "virtual_network" {
  address_space       = ["10.0.0.0/29"]
  location            = data.azurerm_resource_group.resource_group.location
  name                = "vnet-${local.common_resource_suffix}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "subnet" {
  address_prefixes     = ["10.0.0.0/29"]
  name                 = "snet-${local.common_resource_suffix}"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
}

resource "azurerm_public_ip" "public_ip" {
  allocation_method   = "Dynamic"
  location            = data.azurerm_resource_group.resource_group.location
  name                = "pip-${local.common_resource_suffix}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_network_interface" "network_interface" {
  ip_configuration {
    name                          = "nicip-${local.common_resource_suffix}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
    subnet_id                     = azurerm_subnet.subnet.id
  }
  location            = data.azurerm_resource_group.resource_group.location
  name                = "nic-${local.common_resource_suffix}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  admin_ssh_key {
    public_key = var.public_key
    username   = var.username
  }
  admin_username = var.username
  identity {
    type = "SystemAssigned"
  }
  location              = data.azurerm_resource_group.resource_group.location
  name                  = "vm-${local.common_resource_suffix}"
  network_interface_ids = [azurerm_network_interface.network_interface.id]
  os_disk {
    caching              = "None"
    name                 = "osdisk-${local.common_resource_suffix}"
    storage_account_type = "Standard_LRS"
  }
  resource_group_name = data.azurerm_resource_group.resource_group.name
  size                = "Standard_B1ls"
  source_image_reference {
    offer     = "UbuntuServer"
    publisher = "Canonical"
    sku       = "21.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each = toset(["Owner"])

  principal_id         = azurerm_linux_virtual_machine.virtual_machine.identity[0].principal_id
  role_definition_name = each.key
  scope                = data.azurerm_subscription.subscription.id
}
