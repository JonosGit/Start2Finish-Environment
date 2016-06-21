## This script creates new subnets in an existing VNET in an Azure Resource Group


## In order for this script to work properly the VNET and Resource group must already exist.
## Prior to running this script make sure the environment variables have been configured for Subscription ID, TenantID, ResourceGroup and VNETName

Add-AzureRMAccount 
$SubscriptionID=''
$TenantID=''

Set-AzureRmContext -tenantid $TenantID -subscriptionid $SubscriptionID
$VerbosePreference = "continue"


Write-verbose "Setting Environment Variables"
$ResourceGroup = ""
$VNETName = ""

$SubnetName1 = "enablement"
$SubnetName2 = "public"
$SubnetName3 = "ingest"
$SubnetName4 = "data"
$SubnetName5 = "monitor"
$SubnetName6 = "analytics"

$SubnetPrefix1 = "10.1.0.0/24"
$SubnetPrefix2 = "10.1.1.0/24"
$SubnetPrefix3 = "10.1.2.0/24"
$SubnetPrefix4 = "10.1.3.0/24"
$SubnetPrefix5 = "10.1.4.0/24"
$SubnetPrefix6 = "10.1.5.0/24"
$SubnetPrefix7 = "10.1.6.0/24"


Write-verbose "Adding a New Subnet to an Existing ARM based Virtual Network"
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $ResourceGroup -Name $VNETName
$vnet | Add-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName1 -AddressPrefix $SubnetPrefix1 | Set-AzureRmVirtualNetwork
$vnet | Add-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName2 -AddressPrefix $SubnetPrefix2 | Set-AzureRmVirtualNetwork
$vnet | Add-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName3 -AddressPrefix $SubnetPrefix3 | Set-AzureRmVirtualNetwork
$vnet | Add-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName4 -AddressPrefix $SubnetPrefix4 | Set-AzureRmVirtualNetwork
$vnet | Add-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName5 -AddressPrefix $SubnetPrefix5 | Set-AzureRmVirtualNetwork
$vnet | Add-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName6 -AddressPrefix $SubnetPrefix6 | Set-AzureRmVirtualNetwork
$vnet | Add-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName7 -AddressPrefix $SubnetPrefix7 | Set-AzureRmVirtualNetwork

Write-verbose "Output of the Subnet's Associated with the ARM based Virtual Network $VNETName"

$VNET1 = Get-AzureRmVirtualNetwork -ResourceGroupName $ResourceGroup -Name $VNETName

$VNET1

Write-Verbose "Successfully Executed the Script"