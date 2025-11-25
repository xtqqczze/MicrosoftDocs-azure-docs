---
title: Manage Azure Functions on Container Apps using Azure CLI
description: Learn how to deploy, configure, and manage Azure Functions on Azure Container Apps using the Azure CLI.
services: container-apps
author: craigshoemaker
ms.service: azure-container-apps
ms.topic: how-to
ms.date: 11/20/2025
ms.author: cshoe
---

# Manage Azure Functions on Container Apps using Azure CLI

This article shows you how to deploy and manage Azure Functions on Azure Container Apps by using the Azure CLI. You learn how to set up your environment, create the necessary Azure resources and deploy function apps for managing function operations.

## Prerequisites

Before you begin, ensure you have:

- An Azure subscription. If you don't have one, [create a free account](https://azure.microsoft.com/free/).
- [Azure CLI](/cli/azure/install-azure-cli) version 2.0.70 or later.
- A function app ready for containerized deployment.

## Set up your environment

Update your Azure CLI and install the required extensions:

1. Install the required extensions:

    ```azurecli
    # Upgrade the Azure CLI to the latest version
    az upgrade
    
    # Register the Microsoft.App resource provider
    az provider register --namespace Microsoft.App
    
    # Install the latest version of the Azure Container Apps CLI extension
    az extension add --name containerapp --allow-preview true --upgrade
    
    # Sign in to Azure
    az login
    ```

1. Set environment variables for the resources you create.

    You can use the given values for these variables, or provide your own.

    ```bash
    RESOURCE_GROUP="myResourceGroup"
    LOCATION="eastus"
    CONTAINERAPPS_ENVIRONMENT="myContainerAppsEnv"
    STORAGE_ACCOUNT_NAME="mystorageaccount$(date +%s)"
    STORAGE_ACCOUNT_SKU="Standard_LRS"
    APPLICATION_INSIGHTS_NAME="myAppInsights"
    CONTAINERAPP_NAME="myFunctionApp"
    ```

## Create Azure resources

Set up the basic Azure resources needed to run your function app in a container. You create a resource group, set up a Container Apps environment, and add services for storage and monitoring.

1. Create a resource group to contain all your resources.

    ```azurecli
    az group create \
      --name $RESOURCE_GROUP \
      --location $LOCATION
    ```

1. Create Container Apps environment. Create a Container Apps environment with workload profiles enabled.

    ```azurecli
    az containerapp env create \
      --name $CONTAINERAPPS_ENVIRONMENT \
      --resource-group $RESOURCE_GROUP \
      --location $LOCATION \
      --enable-workload-profiles
    ```

1. Add workload profiles (optional). For dedicated compute resources, add a workload profile.

    ```azurecli
    # List available workload profiles
    az containerapp env workload-profile list-supported -l $LOCATION --output table
    
    # Set workload profile variables
    WORKLOAD_PROFILE_NAME="myWorkloadProfile"
    WORKLOAD_PROFILE_TYPE="D4"
    
    # Add workload profile
    az containerapp env workload-profile add \
      --resource-group $RESOURCE_GROUP \
      --name $CONTAINERAPPS_ENVIRONMENT \
      --workload-profile-type $WORKLOAD_PROFILE_TYPE \
      --workload-profile-name $WORKLOAD_PROFILE_NAME \
      --min-nodes 1 \
      --max-nodes 3
    ```

1. Create a storage account for your function app.

    ```azurecli
    az storage account create \
      --name $STORAGE_ACCOUNT_NAME \
      --resource-group $RESOURCE_GROUP \
      --location $LOCATION \
      --sku $STORAGE_ACCOUNT_SKU
    ```

1. Get the storage account connection string.

    ```azurecli
    STORAGE_ACCOUNT_CONNECTION_STRING=$(az storage account show-connection-string \
      --name $STORAGE_ACCOUNT_NAME \
      --resource-group $RESOURCE_GROUP \
      --query connectionString \
      --output tsv)
    ```

1. Create an Application Insights resource for monitoring.

    ```azurecli
    az monitor app-insights component create \
      --app $APPLICATION_INSIGHTS_NAME \
      --location $LOCATION \
      --resource-group $RESOURCE_GROUP \
      --application-type web
    ```

1. Get the Application Insights connection string.

    ```azurecli
    APPLICATION_INSIGHTS_CONNECTION_STRING=$(az monitor app-insights component show \
      --app $APPLICATION_INSIGHTS_NAME \
      --resource-group $RESOURCE_GROUP \
      --query connectionString \
      --output tsv)
    ```

## Deploy your function app

Create the container app with configuration for your Functions app.

```azurecli
az containerapp create \
  --name $CONTAINERAPP_NAME \
  --resource-group $RESOURCE_GROUP \
  --environment $CONTAINERAPPS_ENVIRONMENT \
  --image mcr.microsoft.com/azure-functions/dotnet8-quickstart-demo:1.0 \
  --target-port 80 \
  --ingress external \
  --kind functionapp \
  --workload-profile-name $WORKLOAD_PROFILE_NAME \
  --env-vars AzureWebJobsStorage="$STORAGE_ACCOUNT_CONNECTION_STRING" APPLICATIONINSIGHTS_CONNECTION_STRING="$APPLICATION_INSIGHTS_CONNECTION_STRING"
```

## Manage multiple revisions (optional)

For scenarios that require multiple revisions with traffic splitting, update your container app to create a new revision.

Use the following command to split traffic between revisions.

```azurecli
az containerapp ingress traffic set \
  --name $CONTAINERAPP_NAME \
  --resource-group $RESOURCE_GROUP \
  --revision-weight revision1=50 \
  --revision-weight revision2=50
```

## Manage functions

You can manage your deployed functions within Azure Container Apps using the Azure CLI. The following commands help you list, inspect, and interact with the functions running in your containerized environment.

### List functions

View all functions deployed in your container app:

```azurecli
# List all functions
az containerapp function list \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINERAPP_NAME

# For multi-revision scenarios, specify revision
az containerapp function list \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINERAPP_NAME \
  --revision myRevisionName
```

### Show function details

Get detailed information about a specific function:

```azurecli
az containerapp function show \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINERAPP_NAME \
  --function-name HttpExample
```

## Monitor function invocations

Monitoring your function app is essential for understanding its performance and diagnosing issues. The following commands show you how to retrieve function URLs, trigger invocations, and view detailed telemetry and invocation summaries using the Azure CLI.

1. Get your container app's fully qualified domain name (FQDN).

    ```azurecli
    FQDN=$(az containerapp show \
      --resource-group $RESOURCE_GROUP \
      --name $CONTAINERAPP_NAME \
      --query properties.configuration.ingress.fqdn \
      --output tsv)
    
    echo "Function URL: https://$FQDN/api/HttpExample"
    ```

1. To produce telemetry data, trigger your function.

    ```bash
    curl -X POST "https://$FQDN/api/HttpExample"
    ```

1. To view invocation traces, get detailed traces of function invocations.

    ```azurecli
    az containerapp function invocations traces \
      --name $CONTAINERAPP_NAME \
      --resource-group $RESOURCE_GROUP \
      --function-name HttpExample \
      --timespan 5h \
      --limit 3
    ```

1. View an invocation summary to review successful and failed invocations.

    ```azurecli
    az containerapp function invocations summary \
      --name $CONTAINERAPP_NAME \
      --resource-group $RESOURCE_GROUP \
      --function-name HttpExample \
      --timespan 5h
    ```

## Manage function keys

Azure Functions uses keys for authentication and authorization. You can manage different types of keys:

- **Host keys**: Access any function in the app
- **Master keys**: Provide administrative access
- **System keys**: Used by Azure services
- **Function keys**: Access specific functions

### List keys

Use the following commands to list host-level and function-specific keys for your Azure Functions running in Container Apps.

```azurecli
# List host keys
az containerapp function keys list \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINERAPP_NAME \
  --key-type hostKey

# List function keys (requires function name)
az containerapp function keys list \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINERAPP_NAME \
  --key-type functionKey \
  --function-name HttpExample
```

### Show a specific key

Show the value of a specific host-level key for your function app with the following command:

```azurecli
KEY_NAME="default"

az containerapp function keys show \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINERAPP_NAME \
  --key-type hostKey \
  --key-name $KEY_NAME
```

### Set a key

Set a specific host-level key for your function app with the following command:

```azurecli
KEY_VALUE="your-secure-key-value"

az containerapp function keys set \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINERAPP_NAME \
  --key-type hostKey \
  --key-name $KEY_NAME \
  --key-value $KEY_VALUE
```

## Next steps

- [Learn about Azure Functions triggers and bindings](../azure-functions/functions-triggers-bindings.md)
- [Monitor Azure Functions](../azure-functions/functions-monitoring.md)
- [Scale apps in Azure Container Apps](scale-app.md)
- [Manage revisions in Azure Container Apps](revisions.md)
