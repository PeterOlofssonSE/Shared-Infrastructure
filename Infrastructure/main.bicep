// *** PARAMETERS ***
@description('These parameters are passed from the parameter file.')
param environment string
param applicationName string
param location string = resourceGroup().location
param tags object
param aspSKUName string

// *** VARIABLES ***
// ** Global **
@description('The first character of the selected environment.')
// This value will be used in the name of each resource.
var firstCharEnvironment = toLower(substring(environment, 0, 1))

// *** RESOURCES ***
// ** Storage Account **
module storageAccount 'Storage Account/storageaccount.bicep' = {
  name: 'storageAccountDeploy'
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
  params: {
    firstCharEnvironment: firstCharEnvironment
    location: location
    tags: tags
    aspSKUName: aspSKUName
  }
}
  
