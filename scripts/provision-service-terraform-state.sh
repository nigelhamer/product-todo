#!/bin/bash
# remember to run chmod +x provision-service-terraform-state.sh
# to run: ./provision-service-terraform-state.sh
# Set to infra by default. Switch to dev if required.
export AZURE_ENV_NAME=infra

azd env select $AZURE_ENV_NAME
source ../.azure/$AZURE_ENV_NAME/.env
# The following commented out code would be better as we'd be able to deal with AZD env changes more gracefully
# but the source command does not seem to work even though the command is returned the same as what is in the .env file

# Load the configuration as environment variables
# source <(azd env get-values --no-prompt)

# az login --tenant $AZURE_TENANT_ID
az account set --subscription $AZURE_SUBSCRIPTION_ID

##################################################################################################
# 
# Create the storage container that will store this services terraform state
# 
##################################################################################################

# Add container 
az ad signed-in-user show --query id -o tsv | az role assignment create \
    --role "Storage Blob Data Contributor" \
    --assignee @- \
    --scope "/subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$RS_RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$RS_STORAGE_ACCOUNT"

az storage container create --account-name $RS_STORAGE_ACCOUNT --name $RS_CONTAINER_NAME --auth-mode login

