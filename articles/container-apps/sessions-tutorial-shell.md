---
title: "Tutorial: Execute shell commands in a session pool using Azure Container Apps (preview)"
description: Learn to use dynamic sessions to run shell commands in Azure Container Apps.
services: container-apps
author: jefmarti
ms.service: azure-container-apps
ms.topic: tutorial
ms.date: 10/30/2025
ms.author: jefmarti
---


# Tutorial: Execute shell commands in a session pool using Azure Container Apps (preview)

This tutorial demonstrates how to deploy a shell session pool in Azure Container Apps and execute shell commands using the Dynamic Sessions API and ARM templates.

In this tutorial you:

- Deploy a shell session pool using ARM templates
- Create a user-assigned managed identity with appropriate permissions
- Execute shell commands via the Dynamic Sessions API

## Prerequisites

You need the following resources before you begin this tutorial.

| | |
|-|-|
| Azure account | You need an Azure account with an active subscription. If you don't have one, you can [create one for free](https://azure.microsoft.com/free/). |
| Azure CLI | [Install the Azure CLI](/cli/azure/install-azure-cli). |
| PowerShell | This tutorial uses PowerShell commands. You can use PowerShell Core on any platform. |

## Setup

Begin by preparing the Azure CLI with the latest updates and signing into Azure.

1. Update the Azure CLI to the latest version.

    ```azurecli
    az upgrade
    ```

2. Register the `Microsoft.App` resource provider.

    ```azurecli
    az provider register --namespace Microsoft.App
    ```

3. Install the latest version of the Azure Container Apps CLI extension.

    ```azurecli
    az extension add \
      --name containerapp \
      --allow-preview true --upgrade
    ```

4. Sign in to Azure.

    ```azurecli
    az login
    ```

5. Set the variables used in this procedure.

    Before you run the following command, make sure to replace the placeholders surrounded by `<>` with your own values.

    ```powershell
    $SUBSCRIPTION = "<subscription-id>"  # e.g., "7e574780-0f87-42e8-af8c-5e8cb7d3540a"
    $RG = "<resource-group-name>"        # e.g., "my-shell-session-rg"
    $POOL = "<session-pool-name>"        # e.g., "myshellpool"
    $API_VERSION = "2025-02-02-preview"
    $LOCATION = "northcentralus"         # Must match location in deploy.json
    ```

    You use these variables to create the resources in the following steps.

6. Set the subscription you want to use for creating the resource group.

    ```azurecli
    az account set --subscription $SUBSCRIPTION
    ```

7. Create a resource group.

    ```azurecli
    az group create --name $RG --location $LOCATION
    ```

## Create the ARM template

Create an ARM template file named `deploy.json` to define your shell session pool.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
            "apiVersion": "2025-02-02-preview",
            "name": "myshellpool",
            "type": "Microsoft.App/sessionpools",
            "location": "North Central US",
            "properties": {
                "poolManagementType": "Dynamic",
                "containerType": "Shell",
                "scaleConfiguration": {
                    "maxConcurrentSessions": 5
                },
                "dynamicPoolConfiguration": {
                    "lifecycleConfiguration": {
                        "lifecycleType": "Timed",
                        "cooldownPeriodInSeconds": 300
                    }
                },
                "sessionNetworkConfiguration": {
                    "status": "EgressEnabled"
                }
            }
        }
    ]
}
```

## Deploy the shell session pool

Use the ARM template to deploy your shell session pool.

```azurecli
az deployment group create --resource-group $RG --template-file deploy.json
```

## Create user-assigned managed identity

Create a user-assigned managed identity that will be used for authenticating API calls to the session pool.

1. Set the identity name and pool resource ID.

    ```powershell
    $UAMI_NAME = "$POOL-uami"  # e.g., "myshellpool-uami"
    $POOL_ID = "/subscriptions/$SUBSCRIPTION/resourceGroups/$RG/providers/Microsoft.App/sessionpools/$POOL"
    ```

2. Create the user-assigned managed identity.

    ```azurecli
    az identity create --resource-group $RG --name $UAMI_NAME --location $LOCATION
    ```

3. Get the principal ID of the managed identity.

    ```powershell
    $UAMI_PRINCIPAL = az identity show --resource-group $RG --name $UAMI_NAME --query principalId -o tsv
    ```

## Set role assignments for session execution APIs

To interact with the session pool's API, you must assign the `Azure ContainerApps Session Executor` role to your managed identity.

1. Wait for identity propagation, then assign the role.

    ```powershell
    Start-Sleep -Seconds 30
    az role assignment create --assignee $UAMI_PRINCIPAL --role "0fb8eba5-a2bb-4abe-b1c1-49dfad359bb0" --scope $POOL_ID
    ```

    > [!NOTE]
    > The role GUID `0fb8eba5-a2bb-4abe-b1c1-49dfad359bb0` represents the "Azure ContainerApps Session Executor" role.

## Get a bearer token

For direct access to the session pool's API, generate an access token to include in the `Authorization` header of your requests.

```powershell
$TOKEN = az account get-access-token --query accessToken -o tsv
```

## Execute shell commands in your session

Now that you have a bearer token to establish the security context, you can send a request to the session pool to execute shell commands.

1. Create the request body for the API call.

    ```powershell
    $EXEC_ID = (New-Guid)
    $BodyObj = @{
      codeInputType = "inline"
      executionType = "synchronous" 
      command = @("/bin/bash","-c","echo 'hello world'; echo 'hi'")
      timeoutInSeconds = 600
    }
    $Body = $BodyObj | ConvertTo-Json -Depth 3
    ```

2. Construct the API endpoint URL.

    ```powershell
    $URL = "https://$LOCATION.dynamicsessions.io/subscriptions/$SUBSCRIPTION/resourceGroups/$RG/sessionPools/$POOL/executions?api-version=$API_VERSION&identifier=$EXEC_ID"
    ```

3. Execute the shell commands.

    ```powershell
    curl.exe --request POST --url $URL --header "authorization: Bearer $TOKEN" --header "content-type: application/json" --data $Body
    ```

## Verify your deployment

You can verify that your resources were created successfully using these commands:

1. Verify session pool deployment.

    ```azurecli
    az resource show --ids "/subscriptions/$SUBSCRIPTION/resourceGroups/$RG/providers/Microsoft.App/sessionpools/$POOL" --query '{name:name, location:location, provisioningState:properties.provisioningState}'
    ```

2. Verify role assignment.

    ```azurecli
    az role assignment list --scope "/subscriptions/$SUBSCRIPTION/resourceGroups/$RG/providers/Microsoft.App/sessionpools/$POOL" --output table
    ```

## Clean up resources

The resources created in this tutorial have an effect on your Azure bill. If you aren't going to use these services long-term, run the following command to remove everything created in this tutorial.

```azurecli
az group delete --resource-group $RG
```

## Next steps

- [Learn more about Azure Container Apps sessions](../container-apps/sessions.md)
- [Explore Dynamic Sessions API samples](https://github.com/Azure-Samples/container-apps-dynamic-sessions-samples)
- [Understanding session pool management](../container-apps/sessions-usage.md)