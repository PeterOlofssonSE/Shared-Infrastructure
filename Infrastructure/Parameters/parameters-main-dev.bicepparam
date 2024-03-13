using '../main.bicep'

// *** PARAMETERS: Global ***
@description('The selected environment.')
param environment = 'Dev'

@description('The name of the application or workflow.')
// This value will be used to construct the name of each resource.
param applicationName = 'ClaimCheck'

// Normally you'd use the "location" property of the resource group you're deploying to but since no resource groups
// exist prior to this deployment we need to provide a value. You could also use "deployment().location", but it's more clear this way.
@description('The location where resources will be created.')
param location = 'West Europe'

@description('Resource tags.')
// Some values are hard coded for simplicity.
param tags = {
  environment: environment
  location: location
  owner: 'Finance'
  project: 'Claim-Check'
  costcentre: '123-456'
}

// *** PARAMETERS: App Service Plan ***
@description('The App Service Plan SKU.')
@allowed([
  'WS1'
])
param aspSKUName = 'WS1'
