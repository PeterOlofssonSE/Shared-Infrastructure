targetScope = 'subscription'

// *** PARAMETERS ***
@description('These parameters are passed from the parameter file.')
param environment string
param applicationName string
param location string
param tags object
param aspSKUName string

// *** VARIABLES ***
// ** Global **
@description('The first character of the selected environment.')
// This value will be used in the name of each resource.
var firstCharEnvironment = toLower(substring(environment, 0, 1))

// ** Resource Group **
var resourceGroupName = toLower('${applicationName}-rg-${firstCharEnvironment}')

// *** RESOURCES ***
// ** Resource Group **
resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// ** Storage Account **
module storageAccount 'Storage Account/storageaccount.bicep' = {
  name: 'storageAccountDeploy'
  scope: az.resourceGroup(resourceGroup.name)
  params: {
    applicationName: applicationName
    firstCharEnvironment: firstCharEnvironment
    location: location
    tags: tags
    
  }
}

// ** App Service Plan **
module appServicePlan 'App Service Plan/appserviceplan.bicep' = {
  name: 'appServicePlanDeployment'
  scope: az.resourceGroup(resourceGroup.name)
  params: {
    firstCharEnvironment: firstCharEnvironment
    location: location
    tags: tags
    aspSKUName: aspSKUName
  }
}
  
