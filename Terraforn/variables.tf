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

variable "osdiskname" {
  type        = string
  description = "Name of the OS Disk"
}
variable "vmname" {
  type        = string
  description = "Virtual Machine Name"
}

variable "vmnicname" {
  type        = string
  description = "Network Interface Card Name"
}

variable "computername" {
  type        = string
  description = "Computer Name"
}

variable "vmsize" {
  type        = string
  description = "Virtual Machine Size"
}

variable "vmuser" {
  type        = string
  description = "Virtual Machine username"
}

variable "vmpassword" {
  type        = string
  description = "Virtual Machine password"
}

##App service ENV
variable "appsku" {
  type        = string
  description = "Azure Web App Sku"
}

variable "appsize" {
  type        = string
  description = "Azue Web App size"
}

# Azure Caches For Redis ENV

variable "redissku" {
  type        = string
  description = "Redis Cache SKU"
}

variable "rediscapacity" {
  type        = string
  description = "Capacity of Redis Cache"
}
# Azure SQL ENV

variable "dbname" {
  type        = string
  description = "database name"
}
variable "dbedition" {
  type        = string
  description = "database Edition "
}

variable "dbcollation" {
  type        = string
  description = "Database SKU"
}

variable "dbsize" {
  type        = string
  description = "Database Size in Gb"
}

# Storage Account Variables


variable "storageaccountname" {
  type        = string
  description = "Storage account name"
}

variable "blobcontainer" {
  type        = string
  description = "Blob Container Name"
}
# TAGS
variable "default_tags" {
  type        = map(any)
  description = "Resource Tags Map value"
}
# Auto Scale Group
variable "autoscalename" {
  type        = string
  description = "Blob Container Name"
}