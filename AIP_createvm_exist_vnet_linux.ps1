## This script creates a Red Hat Linux VM in an existing Subnet in an Azure Resource Group

## In order for this script to work properly the VNET and VNETResourceGroupName must already exist.
## Prior to running this script make sure the environment variables have been configured for Subscription ID, TenantID, ResourceGroup and VNETName
## Update the vmcount variable to increment the Deployed VM, i.e. 001 will result in a VM Deployed named RED001.
## To specify the local adminsitrator and Password Update the locadmin and locpassword
## The Public IP Address of the Red Hat VM will be shown when the script completes and can be used to SSH to the server.
## To specify the subnet the VM is deployed to update the "-SubnetId $VNet.Subnets[6].Id" value (line 43).


## Global
$vmcount = "01"
$vmtype = "red"
$VMName = $vmtype + $vmcount
$ResourceGroupName = $VMName + "_rg"
$vNetResourceGroupName = ""
$VNetName = ""
$Location = "WestUs"
$SubscriptionID=''
$TenantID=''
$StorageName = $VMName + "str"
$StorageType = "Standard_GRS"
$InterfaceName = $VMName + "nic"
$ComputerName = $VMName
$VMSize = "Standard_A2"
$locadmin = 'localadmin'
$locpassword = 'PassW0rd'



Login-AzureRmAccount
Set-AzureRmContext -tenantid $TenantID -subscriptionid $SubscriptionID

# Resource Group
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location -force

# Storage
$StorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageName -Type $StorageType -Location $Location

# Network
$PIp = New-AzureRmPublicIpAddress -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod "Dynamic"
$VNet = Get-AzureRMVirtualNetwork -Name $VNetName -ResourceGroupName $vNetResourceGroupName | Set-AzureRmVirtualNetwork
$Interface = New-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -SubnetId $VNet.Subnets[6].Id -PublicIpAddressId $PIp.Id
$osDiskCaching = 'ReadWrite'

## Setup local VM object
$SecureLocPassword=Convertto-SecureString $locpassword –asplaintext -force
$Credential1 = New-Object System.Management.Automation.PSCredential ($locadmin,$SecureLocPassword)
$VirtualMachine = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -linux -ComputerName $ComputerName -Credential $Credential1
$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName "Redhat" -Offer "rhel" -Skus "6.7" -Version "latest"
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $Interface.Id
$OSDiskName = $VMName + "OSDisk"
$OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption "FromImage" -Caching $osDiskCaching

## Create the VM in Azure
New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VirtualMachine -Verbose 

Get-AzureRmPublicIpAddress -Name $InterfaceName -ResourceGroupName $ResourceGroupName | ft "IpAddress"
