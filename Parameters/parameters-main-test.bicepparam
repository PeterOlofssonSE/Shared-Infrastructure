using '../Infrastructure/main.bicep'

// *** PARAMETERS: Global ***
@description('The selected environment.')
param environment = 'Test'

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
  'WS2'
  'WS3'
])
param aspSKUName = 'WS2'

// *** PARAMETERS: Service Bus ***
@description('The Service Bus SKU Name.')
@allowed([
  'Basic'
  'Standard'
])
param sBusSKUName = 'Standard'

@description('Select whether to use SAS keys for authen/author or not.')
@allowed([
  true
  false
])
param sBusDisableLocalAuthentication = true
