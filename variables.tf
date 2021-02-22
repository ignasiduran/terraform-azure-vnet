variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  type        = string
  default     = "rg-test"
}

variable "location" {
  description = "The location/region where the virtual network is created."
  type        = string
  default     = "North Europe"
}

# ##############
# # vNet
# ##############
variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default     = "vnet-test"
}

variable "address_space" {
  description = "The address space that is used the virtual network. You can supply more than one address space."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "dns_servers" {
  description = "List of IP addresses of DNS servers. If no values specified, this defaults to Azure DNS."
  type        = list(string)
  default     = []
}

# ##############
# # Subnets
# ##############
variable "subnet_names" {
  description = "List of subnets inside the vNet."
  type        = list(string)
  default     = ["subnet-test"]
}

variable "subnet_prefixes" {
  description = "The address prefixes to use for each subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

# ##############
# # Route tables
# ##############
variable "rt_names" {
  description = "The route tables to use for each subnet."
  type        = list(string)
  default     = ["rt-test"]
}

# ##############
# # Subnet NSG
# ##############
variable "nsg_ids" {
  description = "The route tables to use for each subnet."
  type        = list(string)
  default     = []
}

# ##############
# # NAT GW
# ##############
variable "enable_natgw" {
  description = "Enable NAT GW."
  type        = bool
  default     = false
}

variable "natgw_name" {
  description = "The NAT GW name."
  type        = string
  default     = "natgw-test"
}

# ##############
# # Bastion
# ##############
variable "enable_bastion" {
  description = "Enable Azure bastion."
  type        = bool
  default     = false
}

variable "bastion_name" {
  description = "The Azure bastion name."
  type        = string
  default     = "bastion-test"
}

variable "bastion_subnet_prefixes" {
  description = "The address prefixes to use for Azure bastion subnet."
  type        = list(string)
  default     = ["10.0.255.224/27"]
}

# ##############
# # Tags
# ##############
variable "tags" {
  description = "A mapping of tags to assign to your vNet and subnets."
  type        = map(string)
  default     = {}
}
