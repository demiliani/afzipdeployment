#Use this command to login to your Azure subscription
#az login

# You can select a specific subscription if you do not want to use the default
# az account set -s SUBSCRIPTION_ID

$location = "westeurope"
$resourceGroupName = "demozipdeployrg"
$storageAccountName = "demozipdeploysa"
$functionName = "DemoZipDeploy"
$sourceZipPath = "PATH_OF_YOUR_ZIP_FILE"


if (-not ($(az group exists -g  $resourceGroupName))) 
{
    Write-Host "Creating resource group "$resourceGroupName
    az group create --name $resourceGroupName --location $location
}
else
{
    Write-Host "---> Resourcegroup:" $resourceGroupName "already exists."
}


Write-Host "Creating storage account "$storageAccountName
az storage account create --name $storageAccountName --location $location --resource-group $resourceGroupName --sku Standard_LRS

Write-Host "Creating function app "$functionName
az functionapp create --name $functionName --storage-account $storageAccountName --consumption-plan-location westeurope --resource-group $resourceGroupName --functions-version 2

Write-Host "Function app created."

Write-Host "Publishing function to Azure"
az webapp deployment source config-zip -g $resourceGroupName -n $functionName --src $sourceZipPath

Write-Host "Function published."
