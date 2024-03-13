@description('This is the Bicep module for the App Service plan service, that will host the Logic App.')

// *** PARAMETERS ***
param firstCharEnvironment string
param location string
param tags object
param aspSKUName string

// *** VARIABLES ***
var aspName = toLower('shared-asp-${firstCharEnvironment}')

// *** RESOURCES ***
resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: aspName
  location: location
  sku: {
    name: aspSKUName
    tier: 'WorkflowStandard'
  }
  kind: 'windows'
  tags: tags
}

output aspID string = appServicePlan.id
