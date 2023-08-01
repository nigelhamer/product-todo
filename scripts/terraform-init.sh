#!/bin/bash
# remember to run chmod +x ./terraform-init.sh
# to run: ./terraform-init.sh
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
# Run Terraform Plan
# 
##################################################################################################

echo "AZURE_ENV_NAME:$AZURE_ENV_NAME"
echo "RS_CONTAINER_NAME:$RS_CONTAINER_NAME"

cd ../infra
rm -rf .terraform

# Dynamically configure the backend
# Needs to align with /infra/provider.conf.json
terraform init \
    -backend-config="storage_account_name=$RS_STORAGE_ACCOUNT" \
    -backend-config="container_name=$RS_CONTAINER_NAME" \
    -backend-config="key=${SERVICE_NAME}/${AZURE_ENV_NAME}.tfstate" \
    -backend-config="resource_group_name=$RS_RESOURCE_GROUP" \
    -backend-config="subscription_id=$AZURE_SUBSCRIPTION_ID" \
    -backend-config="tenant_id=$AZURE_TENANT_ID" \
    -backend-config="use_oidc=true" 
    
