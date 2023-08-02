 #!/bin/bash
# remember to run chmod +x destroy-all-envs.sh
# to run: ./destroy-all-envs.sh
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

# Assume Resource Group names will follow the patterns - rg-$PRODUCT_PREFIX-$PRODUCT_SERVICE_NAME-$AZURE_ENV_NAME

# Delete the resource group associate with each AZD env found
for dir in ../.azure/*/    # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}               # remove the trailing "/"
    export env="${dir##*/}"     # everything after the final "/"

    resourceGroupName="rg-$PRODUCT_PREFIX-$PRODUCT_SERVICE_NAME-$env"
    
    echo "Deleting resource group: $resourceGroupName"
    az group delete --name $resourceGroupName
done



