@description('This is the Bicep module for the Service Bus service.')

// *** PARAMETERS ***
param applicationName string
param firstCharEnvironment string
param location string
param sBusDisableLocalAuthentication bool
param sBusSKUName string
param tags object

// *** VARIABLES ***
var sBusNamespaceName = toLower('${applicationName}-sbus-${firstCharEnvironment}')

// *** RESOURCES ***
resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: sBusNamespaceName
  location: location
  properties: {
    disableLocalAuth: sBusDisableLocalAuthentication
  }
  tags: tags
  sku: {
    name: sBusSKUName
  }
}
