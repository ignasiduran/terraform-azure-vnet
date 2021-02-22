# terraform-azurerm-vnet


## Create a VNet in Azure

This Terraform module deploys a Virtual Network with subnets in Azure.

NAT gateway and Azure Bastion are optionals.


## Usage

### main.tf

```hcl
##############
# Resource group
##############
resource "azurerm_resource_group" "rg" {
  name     = var.general.resource_group_name
  location = var.general.location
  tags     = var.tags
}

##############
# Vnet
##############
module "vnet" {
  source                  = "git@github.com:ignasiduran/terraform-azure-vnet.git"
  resource_group_name     = azurerm_resource_group.rg.name
  vnet_name               = var.networking.vnet_name
  location                = var.general.location
  address_space           = var.networking.address_space
  subnet_prefixes         = var.networking.subnet_prefixes
  subnet_names            = var.networking.subnet_names
  rt_names                = var.networking.rt_names
  nsg_ids                 = [module.nsg1.network_security_group_id, module.nsg2.network_security_group_id]
  enable_natgw            = var.networking.enable_natgw
  natgw_name              = var.networking.natgw_name
  enable_bastion          = var.networking.enable_bastion
  bastion_name            = var.networking.bastion_name
  bastion_subnet_prefixes = var.networking.bastion_subnet_prefixes
  tags                    = var.tags
}

# To override routes 
#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route
# resource "azurerm_route" "local" {
#   name                = "Local"
#   resource_group_name = azurerm_resource_group.rg.name
#   route_table_name    = "rt-internal-test-1"
#   address_prefix      = "x.x.x.x/x"
#   next_hop_type       = "vnetlocal"
# }

##############
# NSG 1
##############
module "nsg1" {
  source              = "git@github.com:ignasiduran/terraform-azure-nsg.git"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.general.location
  security_group_name = "nsg-internal-test-1"
  rules = [
    {
      name                       = "AllowHTTP"
      priority                   = "100"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      description                = "http-rule"
    }
  ]
  tags = var.tags
}

###############
# NSG 2
###############
module "nsg2" {
  source              = "git@github.com:ignasiduran/terraform-azure-nsg.git"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.general.location
  security_group_name = "nsg-internal-test-2"
  rules               = []
  tags                = var.tags
}
```

### variables.tf

```hcl
variable "general" {
  default = {
    location            = "North Europe"
    resource_group_name = "rg-internal-test"
    platform            = "internal"
    env                 = "test"
  }
}

variable "networking" {
  default = {
    vnet_name               = "vnet-internal-test"
    address_space           = ["10.0.0.0/16"]
    subnet_prefixes         = ["10.0.1.0/24", "10.0.2.0/24"]
    subnet_names            = ["snet-internal-test-1", "snet-internal-test-2"]
    rt_names                = ["rt-internal-test-1", "rt-internal-test-2"]
    enable_natgw            = true
    natgw_name              = "natgw-internal-test"
    enable_bastion          = true
    bastion_name            = "bastion-internal-test"
    bastion_subnet_prefixes = ["10.0.255.224/27"]
  }
}

variable "tags" {
  description = "The map of the tags to add to all resources"
  default = {
    platform    = "internal"
    environment = "test"
    manageby    = "terraform"
  }
}
```
### providers.tf

```hcl
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  features {}
}
```

