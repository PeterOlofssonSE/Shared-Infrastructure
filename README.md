# Shared-Infrastructure
The BICEP code in this project is for deploying the necessary resources to support
the integration pattern projects.

# Prerequisites
1. Create a resource group in Azure.
2. Provide the ID of your user account as the value for the "userID" parameter in the parameter file.

# Deployment
## CLI
`code` az deployment group create --template-file .\main.bicep --parameters ..\Parameters\parameters-main-dev.bicepparam --resource-group "ResourceGroupName"
## YAML-pipelines