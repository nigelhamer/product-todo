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
# Create the storage account for terraform backend
# 
##################################################################################################

# Create Resource group
az group create --location $AZURE_LOCATION --resource-group $RS_RESOURCE_GROUP

# Create Storage Account
az storage account create --name $RS_STORAGE_ACCOUNT --resource-group $RS_RESOURCE_GROUP --location $AZURE_LOCATION \
    --sku Standard_ZRS \
    --encryption-services blob


