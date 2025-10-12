---
title: Use premium ingress in Azure Container Apps
description: Learn how to use premium ingress in Azure Container Apps.
services: container-apps
author: craigshoemaker
ms.service: azure-container-apps
ms.custom: devx-track-azurecli, devx-track-bicep
ms.topic: tutorial
ms.date: 10/11/2025
ms.author: jefmarti
zone_pivot_groups: azure-cli-bicep
---

# Use premium ingress with Azure Container Apps

In this article, you learn how to use premium ingress with Azure Container Apps. With premium ingress, you can define how ingress is scaled and configured to better handle higher demand workloads. 

## Prerequisites

- Azure account with an active subscription.
  - If you don't have one, you [can create one for free](https://azure.microsoft.com/free/).

- Install the [Azure CLI](/cli/azure/install-azure-cli).

::: zone pivot="bicep"

- [Bicep](/azure/azure-resource-manager/bicep/install)

::: zone-end

## Setup

::: zone pivot="azure-cli"

1. Run the following command so sign in to Azure from the CLI.

    ```azurecli
    az login
    ```

1. To ensure you're running the latest version of the CLI, run the upgrade command.

    ```azurecli
    az upgrade
    ```

    Ignore any warnings about modules currently in use.

    Install or update the Azure Container Apps extension for the CLI.

    If you receive errors about missing parameters when you run `az containerapp` commands in Azure CLI or cmdlets from the `Az.App` module in PowerShell, be sure you have the latest version of the Azure Container Apps extension installed.

    ```azurecli
    az extension add --name containerapp --upgrade
    ```

    > [!NOTE]
    > Starting in May 2024, Azure CLI extensions no longer enable preview features by default. To access Container Apps [preview features](whats-new.md), install the Container Apps extension with `--allow-preview true`.
    >
    > ```azurecli
    > az extension add --name containerapp --upgrade --allow-preview true
    > ```

1. Now that the current extension or module is installed, register the `Microsoft.App` and `Microsoft.OperationalInsights` namespaces.

    ```azurecli
    az provider register --namespace Microsoft.App
    ```

    ```azurecli
    az provider register --namespace Microsoft.OperationalInsights
    ```

1. Create a resource group with the following command:
    ```azurecli
    az group create --name my-container-apps --location eastus
    ```
1. Create the container apps environment.

    ```azurecli
    az containerapp env create \
      --name my-container-apps-env \
      --resource-group my-resource-group \
      --location eastus
    ```
1. Configure a workload profile for the environment if none exist.
    ```azurecli
    az containerapp env workload-profile add \
      --resource-group my-resource-group \
      --name my-container-apps-env \
      --workload-profile-name my-workload-profile \
      --workload-profile-type D4 \
      --min-nodes 2 \
      --max-nodes 4
    ```

Your workload profile must have at least two nodes to use premium ingress.

1. Configure the premium ingress settings for the environment.

    ```azurecli
        az containerapp env premium-ingress add
        --resource-group my-resource-group 
        --name my-container-apps-env 
        --workload-profile-name my-workload-profile 
        --min-replicas 2 
        --max-replicas 10
        --termination-grace-period 500
        --request-idle-timeout 4
        --header-count-limit 100
    ```
    Below is a description of the parameters you can set when configuring premium ingress settings for your Container Apps environment.

| Parameter                     | Description                                                                                 |
|-----------------------------|---------------------------------------------------------------------------------------------|
| min-replicas             | The minimum number of replicas for the workload profile.                                    |
| max-replicas               | The maximum number of replicas for the workload profile.                                    |
| termination-grace-period | The time (in seconds) to allow active connections to close before terminating the ingress.   |
| request-idle-limit           | The time (in seconds) a request can remain idle before being disconnected.                                      |
| header-count-limit         | The maximum number of HTTP headers allowed per request.                   |


Once configured you will see an output of the settings you just applied.
```json
{
  "headerCountLimit": 100,
  "requestIdleTimeout": 4,
  "terminationGracePeriodSeconds": 500,
  "workloadProfileName": "my-workload-profile"
}
```

1. Update the premium ingress settings for the environment.
     ```azurecli
        az containerapp env premium-ingress update
        --resource-group my-resource-group 
        --name my-container-apps-env 
        --workload-profile-name my-workload-profile 
        --min-replicas 2 
        --max-replicas 10
        --termination-grace-period 500
        --request-idle-timeout 4
        --header-count-limit 100
    ```
1. Show the premium ingress settings for the environment.
    ```azurecli
    az containerapp env premium-ingress show `
        --resource-group my-resource-group `   
        --name my-container-apps-env 
      
    ```
1. Remove the premium ingress settings for the environment.
    ```azurecli
    az containerapp env premium-ingress remove `
        --resource-group my-resource-group `   
        --name my-container-apps-env 
    ```
::: zone-end

::: zone pivot="bicep"

1. Create the following Bicep file and save as `ingress.bicep`.

    ```bicep
    resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2025-02-02-preview' = {
      name: 'my-container-app-env'
      location: 'eastus'
      tags: tags
      properties: {
	    workloadProfiles: [
		    {
			    name: 'ingresswp'
			    workloadProfileType: 'D4'
			    minimumCount: 2
			    maximumCount: 4
		    }
	    ]
	    ingressConfiguration: {
		    workloadProfileName: 'ingresswp'
		    terminationGracePeriodSeconds: 600
		    headerCountLimit: 101
		    requestIdleTimeout: 5
	    }
      }
    }              
    ```

This will deploy a Container Apps environment with a premium ingress configuration including the following settings:


| Name                        | Description                                                                                 |
|-----------------------------|---------------------------------------------------------------------------------------------|
| name                       | The name of the workload profile used for premium ingress.                                   |
| workloadProfileType         | The type/size of the workload profile (e.g., D4) for scaling and resource allocation.        |
| minimumCount               | The minimum number of instances for the workload profile.                                    |
| maximumCount               | The maximum number of instances for the workload profile.                                    |
| workloadProfileName        | The workload profile name associated with the ingress configuration.                         |
| terminationGracePeriodSeconds | The time (in seconds) to allow active connections to close before terminating the ingress.   |
| headerCountLimit           | The maximum number of HTTP headers allowed per request.                                      |
| requestIdleTimeout         | The time (in seconds) a request can remain idle before being disconnected.                   |


1. Deploy to Azure

Navigate to the directory where you saved the `ingress.bicep` file, then run the following command to deploy the Bicep file:

```bash
# Login to Azure (if not already logged in)
azd auth login

# Provision and deploy the infrastructure
azd up
```

1. Manage the deployment

```bash
# Check deployment status
azd show

# Clean up all resources
azd down

# View deployment logs
azd logs
```


::: zone-end


## Clean up resources

If you're not going to continue to use this application, run the following command to delete the resource group along with all the resources created in this quickstart.

> [!CAUTION]
> The following command deletes the specified resource group and all resources contained within it. If resources outside the scope of this quickstart exist in the specified resource group, they'll also be deleted.

```azurecli
az group delete --name my-container-apps
```

## Related content

- [Azure CLI reference](/cli/azure/containerapp/env/http-route-config)
- [Bicep reference](/azure/templates/microsoft.app/2024-10-02-preview/managedenvironments/httprouteconfigs?pivots=deployment-language-bicep)
- [ARM template reference](/azure/templates/microsoft.app/2024-10-02-preview/managedenvironments/httprouteconfigs?pivots=deployment-language-arm-template)
