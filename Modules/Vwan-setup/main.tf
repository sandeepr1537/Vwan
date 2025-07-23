resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.env}-${random_string.suffix.result}"
  location = var.location
}

module "vnet1" {
  source  = "Azure/vnet/azurerm"
  version = "5.0.1"

  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet1_cidr]
  location            = var.location
  name                = "vnet1-${var.env}-${random_string.suffix.result}"
}

module "vnet2" {
  source  = "Azure/vnet/azurerm"
  version = "5.0.1"

  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet2_cidr]
  location            = "australiasouth"
  name                = "vnet2-${var.env}-${random_string.suffix.result}"
}

module "vwan" {
  source  = "Azure-Terraformer/vwan/azurerm"
  version = "1.0.1"

  name                = "vwan-${var.env}-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tags = {
    environment = var.env
  }

  hubs = [
    {
      name            = "vhub1-${random_string.suffix.result}"
      location        = var.location
      address_prefix  = "10.0.0.0/23"
      virtual_network_connections = [
        {
          name                       = "vnet1-connection"
          remote_virtual_network_id = module.vnet1.vnet_id
        }
      ]
    },
    {
      name            = "vhub2-${random_string.suffix.result}"
      location        = "australiasouth"
      address_prefix  = "10.1.0.0/23"
      virtual_network_connections = [
        {
          name                       = "vnet2-connection"
          remote_virtual_network_id = module.vnet2.vnet_id
        }
      ]
    }
  ]

  hub_to_hub_peerings = [
    {
      name      = "hub1-to-hub2"
      hub1_name = "vhub1-${random_string.suffix.result}"
      hub2_name = "vhub2-${random_string.suffix.result}"
      enable    = true
    }
  ]
}

resource "azurerm_public_ip" "fw1_pip" {
  name                = "fw1-pip-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fw1" {
  name                = "firewall1-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  ip_configuration {
    name                 = "fw1-ipcfg"
    subnet_id            = module.vnet1.subnets["AzureFirewallSubnet"]
    public_ip_address_id = azurerm_public_ip.fw1_pip.id
  }
}

resource "azurerm_public_ip" "fw2_pip" {
  name                = "fw2-pip-${random_string.suffix.result}"
  location            = "australiasouth"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fw2" {
  name                = "firewall2-${random_string.suffix.result}"
  location            = "australiasouth"
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  ip_configuration {
    name                 = "fw2-ipcfg"
    subnet_id            = module.vnet2.subnets["AzureFirewallSubnet"]
    public_ip_address_id = azurerm_public_ip.fw2_pip.id
  }
}