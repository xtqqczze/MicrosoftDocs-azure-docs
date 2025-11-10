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

Managed Instance on Azure App Service combines the simplicity of platform-as-a-service with the flexibility of infrastructure-level control. Managed Instance is designed for applications that require plan-level isolation, customization, and secure network integration.

[!INCLUDE [managed-instance](./includes/managed-instance/preview-note.md)]

In this quickstart, you complete the following steps:
1. Use Azure Developer CLI to deploy Azure resources.
1. Use Azure portal or Cloud Shell to create a Managed Instance on Azure App Service (preview).
1. Deploy a sample app to the plan.
1. Verify the deployment.

## Prerequisites

* **Azure account**: You need an Azure account with an active subscription. If you don't already have one, you can [create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

* **Access to the approved regions**: During preview, allowed regions for Managed Instance include: *East Asia*, *East US*, *North Europe*, and *West Central US*.

* [Managed identity](https://learn.microsoft.com/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal#create-a-user-assigned-managed-identity)

* [Storage account and storage container (blob)](/azure/storage/blobs/storage-quickstart-blobs-portal.md)

* Configuration (install) scripts (PowerShell script named `Install.ps1`) in a compressed .zip file

## Deploy sample resources

You can quickly deploy all the necessary resources in this quickstart using Azure Developer CLI and see it running on Azure. The Azure Developer CLI template used in this quickstart is from [Azure samples](). Just run the following commands in the Azure Cloud Shell, and follow the prompts:

```bash
mkdir managed-instance-quickstart
cd managed-instance-quickstart
azd init --template https://github.com/msangapu-msft/learn-quickstart-managed-instance.git
azd env set AZURE_LOCATION eastus
azd up
```

The `azd up` command completes the following steps from the template:

- Creates a user-assigned managed identity.
- Creates an Azure Storage Blob.
- Assigns the managed identity to the storage container and Managed Instance plan.
- Grants Storage-Blob-Data-Contributor access on the storage container.
- Compresses included fonts and Install.ps1 into scripts.zip.
- Upload scripts.zip to the storage container.
- Display values for `Storage Account`, `Container Name`, and `Managed Identity`.

> [!NOTE]
> The configuration script package (`scripts.zip`) deployed with the sample resources contains `Install.ps1`, which copies Microsoft Aptos font files into C:\Windows\Fonts. The sample app you deploy later renders text into an image using these fonts. This process demonstrates how a Managed Instance configuration (install) script can lay down OS-level or framework dependencies before app code runs.
>

The following PowerShell code is the configuration (install) script used in the template.

```powershell
# Install.ps1 - Copy and register fonts on Managed Instance
Write-Host "Installing custom fonts on Managed Instance..." -ForegroundColor Green

# Copy all TTF and OTF fonts to Windows Fonts folder and register them
Get-ChildItem -Recurse -Include *.ttf, *.otf | ForEach-Object {
    $FontFullName = $_.FullName
    $FontName = $_.BaseName + " (TrueType)"
    $Destination = "$env:windir\Fonts\$($_.Name)"

    Write-Host "Installing font: $($_.Name)"
    Copy-Item $FontFullName -Destination $Destination -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $FontName -PropertyType String -Value $_.Name -Force | Out-Null
}

Write-Host "Font installation completed." -ForegroundColor Green
```

The final output of `azd up` should look similar to the following example.

```text
=== Deployment Complete ===
Storage Account: stgpjqep6fdlfv6
Container Name: scripts
Managed Identity Client name: id-gpjqep6fdlfv6
Resource Group: rg-managed-instance
```

The values for `Storage Account`, `Container Name`, `Managed Identity Client name`, and `Resource Group` are used later.

## Deploy an app on Managed Instance

Follow these steps to create a Managed Instance plan and deploy an app to it:

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
| Pricing plans* | Select a pricing plan. If Pv4 or Pmv4 isn't visible in _pricing plans_, confirm region availability or request more quota.|

On the Advanced tab, provide the following details.

#### Configuration (install) script

| Setting | Value |
|-------|----------|
| Storage Account | Use default plan or create new (for example, 'contoso-mi-plan')|
| Container | **scripts** |
| Zip file | **scripts.zip** |
| Value | Verify the .zip URL is correct|
| Identity | Select the managed identity that was created earlier|

On the Deployment tab, select **continuous deployment** in _Continuous deployment settings_. Then provide the following details.

#### GitHub settings

| Setting | Value |
|-------|----------|
| Organization | **msangapu-msft** |
| Repository | **learn-quickstart-managed-instance** |
| Branch | **sampleapp** |

1. Select **Review + create** and then select **Create**.

# [Cloud Shell](#tab/shell)

1. The following command configures variables for needed resources to create the Managed Instance plan.

```bash
RG=rg-managed-instance
LOCATION=<LOCATION OF PLAN>
PLAN_NAME=rg-mi-plan
IDENTITY_ID=<SET-IDENTITIY-ID>
SCRIPT_URI=<LOCATION OF SCRIPT>
APP_NAME=<APP-NAME>
```

2. The following command creates the Managed Instance plan with a configuration (install) script.

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

Deployment takes several minutes while resources provisioned.

3. The following command creates a web app on the Managed Instance plan.

```bash
az webapp create \
  --name "$APP_NAME" \
  --resource-group "$RG" \
  --plan "$PLAN_NAME" \
  --runtime "DOTNET|9"
```

4. The following command assigns a Managed Identity to the web app.

```bash
# Assign managed identity to web app
az webapp identity assign \
  --name "$APP_NAME" \
  --resource-group "$RG" \
  --identities "$IDENTITY_ID"
```

5. The following command downloads the sample app to Cloud Shell.
```bash
curl -L -o app.zip https://raw.githubusercontent.com/msangapu-msft/aptos-testing/default/app.zip
```

6. The following command deploys the web app to your Managed Instance plan.

```bash
az webapp deploy \
  --resource-group "$RG" \
  --name "$APP_NAME" \
  --src-path app.zip \
  --type zip
```

-----

## Browse to the app

To browse to the created app, select the **default domain** in the **Overview** page.

The .NET app is running on a Managed Instance plan and reading fonts from C:\Windows\Fonts directory.

:::image type="content" source="media/quickstart-managed-instance/hello-world-aptos-font.png" alt-text="Screenshot that shows the sample app using C:\Windows\Fonts\Aptos.TTF.":::

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

## Next steps

- [Configure Managed Instance](configure-managed-instance.md)
- [App Service overview](overview.md)
- [Security in App Service](overview-security.md)
- [App Service Environment comparison](./environment/overview.md)