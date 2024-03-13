@description('This is the Bicep module for the Logic App Standard service.')

// *** PARAMETERS ***
param location string
param tags object
param firstCharEnvironment string
param applicationName string
param aspID string

// *** VARIABLES ***
var logicAppName = toLower('${applicationName}-la-${firstCharEnvironment}')

resource logicAppStandard 'Microsoft.Web/sites@2023-01-01' = {
  name: logicAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'workflowapp,functionapp'
  properties: {
    serverFarmId: aspID
    httpsOnly: true
  }
  tags: tags
}
