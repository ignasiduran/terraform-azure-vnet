# ##############
# # vNet
# ##############
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}

# ##############
# # Subnets
# ##############
resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
  address_prefixes     = [var.subnet_prefixes[count.index]]
}

# ##############
# # Route tables
# ##############
resource "azurerm_route_table" "rt" {
  count                         = length(var.subnet_names)
  name                          = var.rt_names[count.index]
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = false
  tags                          = var.tags
}

resource "azurerm_subnet_route_table_association" "rt-association" {
  count          = length(var.subnet_names)
  subnet_id      = azurerm_subnet.subnet[count.index].id
  route_table_id = azurerm_route_table.rt[count.index].id
}

# ##############
# # Subnet NSG
# ##############
resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  count                     = length(var.nsg_ids)
  subnet_id                 = azurerm_subnet.subnet[count.index].id
  network_security_group_id = var.nsg_ids[count.index]
}

# ##############
# # NAT GW
# ##############
resource "azurerm_public_ip" "natgw-publicIP" {
  count               = var.enable_natgw ? 1 : 0
  name                = "${var.natgw_name}-publicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
  tags                = var.tags
}

resource "azurerm_nat_gateway" "natgw" {
  count                   = var.enable_natgw ? 1 : 0
  name                    = var.natgw_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "natgw-publicIP" {
  count                = var.enable_natgw ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.natgw[count.index].id
  public_ip_address_id = azurerm_public_ip.natgw-publicIP[count.index].id
}

resource "azurerm_subnet_nat_gateway_association" "natgw" {
  count          = var.enable_natgw ? length(var.subnet_names) : 0
  subnet_id      = azurerm_subnet.subnet[count.index].id
  nat_gateway_id = azurerm_nat_gateway.natgw[0].id
}

# ##############
# # Bastion
# ##############
resource "azurerm_public_ip" "bastion-publicIP" {
  count               = var.enable_bastion ? 1 : 0
  name                = "${var.bastion_name}-publicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_subnet" "bastion-subnet" {
  count                = var.enable_bastion ? 1 : 0
  name                 = "AzureBastionSubnet"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
  address_prefixes     = var.bastion_subnet_prefixes
}

resource "azurerm_bastion_host" "bastion" {
  count               = var.enable_bastion ? 1 : 0
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion-subnet[count.index].id
    public_ip_address_id = azurerm_public_ip.bastion-publicIP[count.index].id
  }

  tags = var.tags
}