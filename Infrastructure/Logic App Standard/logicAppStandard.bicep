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
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~18'
        }
        {
          name: 'AzureWebJobsStorage'
          value: storageAccountPrimaryAccessKey
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: storageAccountPrimaryAccessKey
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: fileShareName
        }
        {
          name: 'AzureFunctionsJobHost__extensionBundle__id'
          value: 'Microsoft.Azure.Functions.ExtensionBundle.Workflows'
        }
        {
          name: 'AzureFunctionsJobHost__extensionBundle__version'
          value: '[1.*, 2.0.0)'
        }
        {
          name: 'APP_KIND'
          value: 'workflowApp'
        }
      ]
    }
  }
  tags: tags
}
