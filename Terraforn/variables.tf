# Azure Provider Variables

variable "azure-subscription-id" {
  type = string
  description = "Azure Subscription ID"
}
variable "azure-client-id" {
  type = string
  description = "Azure Client ID"
}
variable "azure-client-secret" {
  type = string
  description = "Azure Client Secret"
}
variable "azure-tenant-id" {
  type = string
  description = "Azure Tenant ID"
}



##Resource_Group Variables
variable "rgname" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure Resource Locations"
}

variable "vnet_name" {
  type        = string
  description = "Name of the VNET"
}
variable "address_space" {
  type        = string
  description = "Vnet Address Space"
}


variable "address_prefixe_app" {
  type        = string
  description = "Network Subnet Address Prefix"
}

variable "address_prefixe_redis" {
  type        = string
  description = "Network Subnet Address Prefix"
}

variable "address_prefixe_sql" {
  type        = string
  description = "Network Subnet Address Prefix"
}

variable "address_prefixe_asa" {
  type        = string
  description = "Network Subnet Address Prefix"
}

variable "address_prefixe_vm" {
  type        = string
  description = "Network Subnet Address Prefix"
}

##Virtual Machine ENV
variable "vmsize" {
  type        = string
  description = "Network Subnet Address Prefix"
}

variable "vmuser" {
  type        = string
  description = "Network Subnet Address Prefix"
}

variable "vmpassword" {
  type        = string
  description = "Network Subnet Address Prefix"
}

##App service ENV
variable "appsku" {
  type        = string
  description = "Network Subnet Address Prefix"
}

variable "appsize" {
  type        = string
  description = "Network Subnet Address Prefix"
}

# Azure Caches For Redis ENV

variable "redissku" {
  type        = string
  description = "Network Subnet Address Prefix"
}

variable "rediscapacity" {
  type        = string
  description = "Network Subnet Address Prefix"
}
# Azure SQL ENV

variable "dbname" {
  type        = string
  description = "Network Subnet Address Prefix"
}
variable "dbedition" {
  type        = string
  description = "Network Subnet Address Prefix"
}

variable "dbcollation" {
  type        = string
  description = "Network Subnet Address Prefix"
}

variable "dbsize" {
  type        = string
  description = "Network Subnet Address Prefix"
}



