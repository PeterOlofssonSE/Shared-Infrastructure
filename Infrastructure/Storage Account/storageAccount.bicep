@description('This is the Bicep module for the Storage Account service.')

// *** PARAMETERS ***
param applicationName string
param firstCharEnvironment string
param location string
param tags object
param keyVaultName string

// *** VARIABLES ***
// Create Storage Account name:
// Max 24 chars, only lowercase with a unique string based on resource group id and the value of the environment variable.
// The "uniqueString()" function returns a string of 13 characters.
var storageAccountNameUniquePart = uniqueString(resourceGroup().id, firstCharEnvironment)

/* We create the length value of the randomised unique part of the storage account name by starting with 24 (the maximum length
  of a storage account name and then withdrawing the length of the values of the stgActNamePrefix and environment variables)*/
//var stgActUniquePartLength = 24 - length('stgshared') - length(firstCharEnvironment)

/* We create a new string using the randomised value in stgActUniquePart as input, starting to the right of the first character (index 0)
and using the numeric value in stgActUniquePartLength as the cutoff point.*/
//var storageAccountTruncatedNameUniquePart = substring(storageAccountNameUniquePart, 0, stgActUniquePartLength)

// !!! this should probably be made a parameter so we can enfore rules for minLength and maxLength.
var storageAccountName = toLower('stgshared${storageAccountNameUniquePart}${firstCharEnvironment}')

// Define resource references for accessing storage account keys
var storageAccountPrimaryAccessKey = storageAccount.listKeys().keys[0]
var storageAccountSecondaryAccessKey = storageAccount.listKeys().keys[1]

// Build the connection string using resource references
var storageAccountConnStr = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccountPrimaryAccessKey.value};EndpointSuffix=core.windows.net'

var fileShareName = toLower('${applicationName}-la-${firstCharEnvironment}')

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  tags: tags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  
  resource fileService 'fileServices@2023-01-01' = {
    name: 'default'
  
    resource fileShare 'shares' = {
      name: fileShareName
      properties: {
        accessTier: 'Hot'
      }
    }
  }
}

// Store the primary access key in the Key Vault
resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: '${keyVaultName}/storageAccountPrimaryConnectionString'
  properties: {
    value: storageAccountConnStr
  }
}

output storageAccountName string = storageAccount.name
output storageAccountID string = storageAccount.id
output fileShareName string = fileShareName


