#Provider Variables
azure-subscription-id   = ""
azure-client-id         = ""
azure-client-secret     = ""
azure-tenant-id         = ""

location = "eastus"
rgname   = "icon-prod-rg"

#VNET VARIABLES
vnet_name     = "icon-PROD-Vnet"
address_space = "10.0.0.0/16"

#Subnet Variables
address_prefixe_app   = "10.0.1.0/24"
address_prefixe_redis = "10.0.2.0/24"
address_prefixe_sql   = "10.0.3.0/24"
address_prefixe_asa   = "10.0.4.0/24"
address_prefixe_vm    = "10.0.5.0/24"

#Virtual Machine Variables

vmsize       =  "Standard_D3_v2"
vmuser       =  ""
vmpassword   =  ""
vmnicname    =  "Icon-Prod-VM-Nic"
vmname       =  "Icon-Prod-VM"
osdiskname   =  "icon-prod-osDisk"
computername =  "Icon-Prod-Comp"

#App Service Variables

appsku     = "PremiumV2"
appsize    = "P2v2"

# Azure Cache For Redis Variables

redissku      = "Premium"
rediscapacity = 2

# Azure SQL Variables

dbname         =  "production_db"
dbedition      =  "Standard"
dbcollation    =  "SQL_Latin1_General_CP1_CI_AS"
dbsize         =  1

# Storage Account Variables

storageaccountname     =  "iconprodstorageaccount"
blobcontainer          =  "prodblob"