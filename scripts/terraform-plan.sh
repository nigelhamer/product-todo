#!/bin/bash
# remember to run chmod +x ./terraform-plan.sh
# to run: ./terraform-plan.sh
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
    
terraform fmt
terraform validate

# Pass the values for the variables terraform needs
# Needs to align with /infra/main.tfvars.json
terraform plan \
    -var="environment_name=$AZURE_ENV_NAME" \
    -var="location=$AZURE_LOCATION" \
    -var="principal_id=$AZURE_PRINCIPAL_ID" \
    -var="service_name=$SERVICE_NAME" 