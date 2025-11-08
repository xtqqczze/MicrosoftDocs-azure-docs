---
title: 'Quickstart: Deploy Managed Instance on Azure App Service (preview)'
description: Learn how to configure Managed Instance on Azure App Service
keywords: app service, azure app service, scale, scalable, scalability, app service plan, app service cost
ms.topic: quickstart
ms.date: 11/05/2025
ms.author: msangapu
author: msangapu-msft
ms.service: azure-app-service
---

# Deploy Managed Instance on Azure App Service (preview)

> [!IMPORTANT]
> Managed Instance is in public preview, limited to select regions and the **Pv4** / **Pmv4** SKUs. Linux and containers are not supported. Validate functionality before production use.

Managed Instance on Azure App Service combines the simplicity of platform-as-a-service with the flexibility of infrastructure-level control. It is designed for applications that require  isolation, advanced customization, and secure network integration.

In this quickstart you complete the following:
1. Use Azure Developer CLI to deploy Azure resources.
1. Use Azure portal to create a Managed Instance on Azure App Service (preview).
1. Deploy a sample app to the plan.
1. Verify the deployment.

## Prerequisites

* **Azure account**: You need an Azure account with an active subscription. If you don't already have one, you can [create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
* **Access to the approved regions**: During the preview, the only allowed regions for Managed Instance are the *East Asia*, *East US*, *North Europe*, and *West Central US* regions.
* **Azure CLI 2.79.0 or later**. See [Install Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli).

* Managed identity

* Storage account and storage container (blob)

* Configuration scripts (PowerShell script named `Install.ps1`) in a compressed .zip file


## Skip to the end

You can quickly deploy all the necessary resrouces in this quickstart using Azure Developer CLI and see it running on Azure. Just run the following commands in the Azure Cloud Shell, and follow the prompts:

```bash
mkdir managed-instance-quickstart
cd managed-instance-quickstart
azd init --template https://github.com/msangapu-msft/learn-quickstart-managed-instance.git
azd env set AZURE_LOCATION eastus
azd up
```

The `azd up` command completes the following steps:
- Create a user-assigned managed identity.
- Create Azure Storage Blob.
- Assign the managed identity to the storage container.
- Grant Storage-Blob-Data-Contributor access.
- Compress fonts directory into scripts.zip.
- Upload scripts.zip to the storage container.
- Display values for `Storage Account`, `Container Name`, and `Managed Identity`.

## Deploy an app on Managed Instance

Follow these steps to create an appyour Managed Instance plan:

# [Azure portal](#tab/portal)

    1. Sign in to the [Azure portal](https://portal.azure.com).
    1. Select **+ Create a resource**.
    1. Search for **managed instance**
    1. Select **Web App (for Managed Instance) (preview)** in the results.
    1. Select **Create** to start the create process.
    
    On the Basic tab, provide the following details.

#### Project details

    | Setting | Value |
    |-------|----------|
    | Subscription | Your Azure subscription |
    | Resource Group | **rg-managed-instance** |

#### App details

    | Setting | Value |
    |-------|----------|
    | Name | **contoso-mi-app** |
    | Runtime stack | **.NET 9 (STS)** |
    | Region | A region near you |

#### Pricing plans
    | Setting | Value |
    |-------|----------|
    | Windows Plan | Use default plan or create new (for example, 'contoso-mi-plan')|
    | Pricing plans* | Select a pricing plan. If the Pv4 / Pmv4 SKU isn't visible in _pricing plans_, confirm region availability or request more quota.|

On the Advanced tab, provide the following details.

#### Configuration script

    | Setting | Value |
    |-------|----------|
    | Storage Account | Use default plan or create new (for example, 'contoso-mi-plan')|
    | Container | **scripts** |
    | Zip file | **scripts.zip** |
    | Value | Verify this is correct |
    | Identity | Select the managed identity that was created earlier|
    
    On the Deployment tab, select **continuous deployment** in _Continuous deployment settings_. The provide the following details.

#### GitHub settings

    | Setting | Value |
    |-------|----------|
    | Organization | **msangapu-msft** |
    | Repository | **learn-quickstart-managed-instance** |
    | Branch | **sampleapp** |

1. Select **Review + create** and then select **Create**.

# [Cloud Shell](#tab/shell)

The following command creates the Managed Instance plan with a configuration script.

```bash
az deployment group create \
  --resource-group "$RG" \
  --template-file infra/app-service-plan-managed-instance.json \
  --parameters \
    location="$LOCATION" \
    appServicePlanName="$PLAN_NAME" \
    userAssignedIdentityResourceId="$IDENTITY_ID" \
    installScriptSourceUri="$SCRIPT_URI" \
    skuName=P1V4 \
    skuCapacity=1
```


```bash
az webapp create \
  --name "$APP_NAME" \
  --resource-group "$RG" \
  --plan "$PLAN_NAME" \
  --runtime "DOTNET|9"
```

```bash
# Assign managed identity to web app
echo "Assigning managed identity to web app..."
az webapp identity assign \
  --name "$APP_NAME" \
  --resource-group "$RG" \
  --identities "$IDENTITY_ID"
```

```bash
echo "== Deploying application code =="
az webapp deployment source config-zip \
  --resource-group "$RG" \
  --name "$APP_NAME" \
  --src app.zip
```

-----

## Browse to the app

To browse to the created app, select the **default domain** in the **Overview** page. If you see the message *Your web app is running and waiting for your content*, GitHub deployment is still running. Wait a couple of minutes and refresh the page.

## Manage the Managed Instance plan

To manage your web app, go to the [Azure portal](https://portal.azure.com), and search for and select **App Services**.

On the **App Services** page, select the name of your web app.

On the **Overview** page, select the name of your App Service plan. Under __Current App Service plan__, select the plan name.

In the left menu under __Settings__, select **Configuration** to view the configuration details.

## Clean up resources

# [Azure portal](#tab/portal)

In the preceding steps, you created Azure resources in a resource group. If you don't expect to need these resources in the future, you can delete them by deleting the resource group.
 
1. From your web app's **Overview** page in the Azure portal, select the **myResourceGroup** link under **Resource group**.
1. On the resource group page, make sure that the listed resources are the ones you want to delete.
1. Select **Delete resource group**, type **myResourceGroup** in the text box, and then select **Delete**.
1. Confirm again by selecting **Delete**.

# [Cloud Shell](#tab/shell)

```bash
az group delete
```

---


Deployment takes several minutes while resources provisioned.


## Next steps

- [App Service overview](overview.md)
- [Managed Instance Quickstart](quickstart-managed-instance.md)
- [Security in App Service](overview-security.md)
- [App Service Environment comparison](./environment/overview.md)