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
# Create App Registration for this Service
# 
##################################################################################################

# Global Variables
export REPO="$PRODUCT_NAME-$SERVICE_NAME"
export APP_NAME="$REPO-service-app"

# Create the App Registration and service principle
az ad app create --display-name $APP_NAME
app_obj_id=$(az ad app list --display-name $APP_NAME --query [].id --output tsv)
az ad sp create --id $app_obj_id
spn_app_id=$( az ad sp list --display-name $APP_NAME --query [0].appId  --output tsv)

# Give the App Registration Contributor access to the suscription
az role assignment create --role contributor --subscription  $AZURE_SUBSCRIPTION_ID --assignee-object-id  $spn_app_id --assignee-principal-type ServicePrincipal --scope /subscriptions/$AZURE_SUBSCRIPTION_ID

# Setup Federated Credential for each environment
for dir in ../.azure/*/    # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}               # remove the trailing "/"
    export env="${dir##*/}"     # everything after the final "/"
    echo $env

     az rest --method POST --uri "https://graph.microsoft.com/beta/applications/$app_obj_id/federatedIdentityCredentials" \
    --body "{\"name\":\"$APP_NAME-deploy-$env\",
        \"issuer\":\"https://token.actions.githubusercontent.com\",
        \"subject\":\"repo:$PRODUCT_ORG/$REPO:environment:$env\"
        ,\"description\":\"Allows Deploymnent to $env environment\",
        \"audiences\":[\"api://AzureADTokenExchange\"]}"

done

echo "##################################################################################################"
echo
echo "Update AZURE_CLIENT_ID variable in the git action to: $app_obj_id"
echo
echo "##################################################################################################"

