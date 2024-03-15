@description('This is the Bicep module for the Key Vault service.')

// *** PARAMETERS ***
param applicationName string
param firstCharEnvironment string
param location string
param tags object
param userID string

// *** VARIABLES ***
// Create Key Vault name:
// Max 24 chars, only lowercase with a unique string based on resource group id and the value of the environment variable.
// The "uniqueString()" function returns a string of 13 characters.
var keyVaultNameUniquePart = uniqueString(resourceGroup().id, firstCharEnvironment)

/* We trim the length value of the randomised unique part of the storage account name by starting with 24 (the maximum length
  of a Key Vault name property and then withdrawing the length of the values of the 'kv' string, the hyphens used and environment variables)*/
var keyVaultNameUniquePartLength = 24 - length(applicationName) - length('kv---') - length(firstCharEnvironment)

/* We create a new string using the randomised value in stgActUniquePart as input, starting to the right of the first character (index 0)
  and using the numeric value in keyVaultNameUniquePartLength as the cutoff point.*/
var keyVaultTruncatedUniquePart = substring(keyVaultNameUniquePart, 0, keyVaultNameUniquePartLength)
var keyVaultName = toLower('${applicationName}-kv-${keyVaultTruncatedUniquePart}-${firstCharEnvironment}')

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enabledForTemplateDeployment: true
    enableRbacAuthorization: true
    enableSoftDelete: false
  }
  tags: tags
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, userID)
  properties: {
    // Remember to explicitly remove the role assignment, when deleting the resources.
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00482a5a-887f-4fb3-b363-3b7fe8e74483')
    principalId: userID
  }
}

output keyVaultName string = keyVault.name
output keyVaultID string = keyVault.id
