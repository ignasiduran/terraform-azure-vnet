output "vnet_id" {
  description = "vNet id"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "vNet name"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_location" {
  description = "The location of the vNet"
  value       = azurerm_virtual_network.vnet.location
}

output "vnet_address_space" {
  description = "The address space of the vNet"
  value       = azurerm_virtual_network.vnet.address_space
}

output "subnets_id" {
  description = "The id of the subnets created in the vNet"
  value       = azurerm_subnet.subnet.*.id
}

output "subnets_name" {
  description = "The name of the subnets created in the vNet"
  value       = azurerm_subnet.subnet.*.name
}