---
title: Self-Host the API Management Developer Portal
title: Self-Host the API Management Developer Portal
titleSuffix: Azure API Management
description: Learn how to self-host the developer portal for Azure API Management.
author: dlepow
ms.author: danlep
ms.date: 03/29/2024
ms.service: azure-api-management
ms.topic: how-to
---

# Self-host the API Management developer portal

[!INCLUDE [api-management-availability-premium-dev-standard-basic-premiumv2-standardv2-basicv2](../../includes/api-management-availability-premium-dev-standard-basic-premiumv2-standardv2-basicv2.md)]

This tutorial describes how to self-host the [API Management developer portal](api-management-howto-developer-portal.md). Self-hosting is one of several options to [extend the functionality](developer-portal-extend-custom-functionality.md) of the developer portal. For example, you can self-host multiple portals for your API Management instance, with different features. When you self-host a portal, you become its maintainer and you're responsible for its upgrades. 

> [!IMPORTANT]
> Consider self-hosting the developer portal only when you need to modify the core of the developer portal's codebase. This option requires advanced configuration, including:
> - Deployment to a hosting platform, optionally fronted by a solution such as a Content delivery network (CDN) for increased availability and performance.
> - Maintaining and managing hosting infrastructure.
> - Manual updates, including for security patches, which might require you to resolve code conflicts when upgrading the codebase.

> [!NOTE]
> The self-hosted portal doesn't support visibility and access controls that are available in the managed developer portal.

If you already uploaded or modified media files in the managed portal, see [Move from managed to self-hosted](#move-from-managed-to-self-hosted-developer-portal), later in this article.

## Prerequisites

To set up a local development environment, you need to have:

<!-- In v2 tiers, necessary to Enable dev portal? -->

- An API Management service instance. If you don't have one, see [Quickstart - Create an Azure API Management instance](get-started-create-service-instance.md).
- An Azure blob storage account, which you use to enable the [static websites feature](../storage/blobs/storage-blob-static-website.md). See [Create a storage account](../storage/common/storage-account-create.md).
- Git on your machine. Install it by following [this Git tutorial](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
- Node.js (Long Term Support (LTS) version, `v10.15.0` or later) and npm on your machine. See [Downloading and installing Node.js and npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm).
- Azure CLI. Follow [the Azure CLI installation steps](/cli/azure/install-azure-cli).
- (Optional) A Microsoft Entra app registration to configure user sign-in to the developer portal. To configure the Microsoft Entra app, see steps in [Manually enable Microsoft Entra application and identity provider](api-management-howto-aad.md#manually-enable-microsoft-entra-application-and-identity-provider).

## Step 1: Set up local environment

To set up your local environment, you'll have to clone the repository, switch to the latest release of the developer portal, and install npm packages.

1. Clone the [api-management-developer-portal](https://github.com/Azure/api-management-developer-portal.git) repo from GitHub:

    ```console
    git clone https://github.com/Azure/api-management-developer-portal.git
    ```
1. Go to your local copy of the repo:

    ```console
    cd api-management-developer-portal
    ```

1. Check out the latest release of the portal.

    Before you run the following code, check the current release tag in the [Releases section of the repository](https://github.com/Azure/api-management-developer-portal/releases) and replace `<current-release-tag>` value with the latest release tag.
    
    ```console
    git checkout <current-release-tag>
    ```

1. Install any available npm packages:

    ```console
    npm install
    ```

> [!TIP]
> Always use the [latest portal release](https://github.com/Azure/api-management-developer-portal/releases) and keep your forked portal up-to-date. The API Management development team uses the `master` branch of this repository for daily development purposes. It has unstable versions of the software.

## Step 2: Run editor locally

The developer portal requires the API Management REST API to manage the content. 
First open the `config.design.json` file in the `src` folder:

```json
{
    "environment": "development",
    "isArmAuthEnabled": true,
    "subscriptionId": "< subscription ID >",
    "resourceGroupName": "< resource group name >",
    "serviceName": "< service name >"
}
```

To configure the file:

1. In `subscriptionId`, `resourceGroupName`, and `serviceName`, enter values for the subscription, resource group, and service name of your API Management instance. If you configured a [custom domain](configure-custom-domain.md) for the portal, use it instead for the value of `serviceName` (for example, `https://portal.contoso.com`). For example:

    ```json
    {
    ...
    "serviceName": "https://contoso-api.azure-api.net"
    ...
    ```

1. Run `npm start`. You are prompted to authenticate via your browser. Select your Microsoft credentials to continue.

1. After some time, the default browser automatically opens with your local developer portal instance. The default address is `http://localhost:8080`, but the port can change if `8080` is already occupied.


## Configure the static website

Configure the **Static website** feature in your storage account by providing routes to the index and error pages:

1. In the Azure portal, bo to your storage account in the Azure portal.

1. In the sidebar menu, select **Data management** > **Static website**.

1. On the **Static website** page, select **Enabled**.

1. In the **Index document name** field, enter *index.html*.

1. In the **Error document path** field, enter *404/index.html*.

1. Select **Save**.

Take note of the **Primary endpoint** URL. You will configure it later to access your self-hosted portal.

## Create an Entra ID application in your tenant

1. [Register an application](/entra/identity-platform/quickstart-register-app) in your Microsoft Entra tenant. Take note of the Application (client) ID and the Directory (tenant) ID. You will configure them in a later step.

1. Configure a Web **Redirect URI** (reply URL) in this application to point to the endpoint of the web app where the designer is hosted. For example, this can be simply the locaiton of the Blob storage-based website. Example: `https://<your-storage-account-name>z13.web.core.windows.net/`.


## Host the website editor

When making changes into website code, you may need to update the website editor code as well to be able to properly support editing of your modified widgets. In this case, besides hosting the portal, you may also want to host the editor application. For this you'll need to build it and configure to access your API Management service.

1. Add `clientId` and `tenantId` fields to `config.design.json` file. These are parameters needed to authenticate against Azure Resource Manager APIs. You can get those values by registering your own Entra ID application in your tenant (here goes link to respective docs). The redirect URL (reply URL) in this application should point to root of the web app where the designer is hosted (this can be simply Blob storage-based website).

1. Run `npm run build-designer` command to build designer.
1. Go to generated `/dist/designer` folder.
1. Create a file `config.json` with the following content: <!-- I found this file was created and configured as below. -->

    ```json
    {
        "subscriptionId": "< subscription ID >",
        "resourceGroupName": "< resource group name >",
        "serviceName": "< APIM service name >",
        "clientId": "< Entra ID app ID >",
        "tenantId": "< Entra ID tenant ID >"
    }
    ```
    Here, subscriptionId, resourceGroupName and serviceName - needed to connect to your APIM service using Azure Resource Manager (ARM) APIs.


## Publish website locally

First open the `config.publish.json` file in the `src` folder:

```json
{
    "environment": "publishing",
    "subscriptionId": "< subscription ID >",
    "resourceGroupName": "< resource group name >",
    "serviceName": "< service name >"
}
```

To configure the file:

1. In `subscriptionId`, `resourceGroupName`, and `serviceName`, enter values for the subscription, resource group, and service name of your API Management instance. If you configured a [custom domain](configure-custom-domain.md) for the portal, use it instead for the value of `serviceName` (for example, `https://portal.contoso.com`). For example:

    ```json
    {
    ...
    "serviceName": "https://contoso-api.azure-api.net"
    ...
    ```

1. Run `npm run publish`. You are prompted to authenticate via your browser. Select your Microsoft credentials to continue.

1. After some time, the content is published to the `dist/website` folder.

## Upload static files to a blob

Use the Azure CLI to upload the locally generated static files to a blob, and make sure your visitors can get to them:

1. Open Windows Command Prompt, PowerShell, or other command shell.

1. Run the following `az storage blog upload-batch` command. Replace `<connection-string>` with a connection string for your storage account. You can get it from the **Security + networking** > **Access keys** section of your storage account.

    ```azurecli    
    az storage blob upload-batch --source dist/website \
        --account-name <your-storage-account-name> \
        --destination '$web' \
        --connection-string "<connection-string>"
    ```
 
## Go to your website

Your website is now live under the hostname specified in your Azure Storage properties. Go to **Primary endpoint** in **Data management** > **Static website**.

## Publish portal in pipelines (GitHub Actions)

The pipeline will also needs Entra ID application credentials to execute publishing (this can be the same Entra ID application as mentioned above). The `tenantId`, `clientId`, and especially `clientSecret` must be kept in respective key storage. See [Using secrets in GitHub Actions](https://docs.github.com/en/actions/security-guides/encrypted-secrets) for more details.

Example of GitHub Actions pipeline YAML:

```yml

name: Portal-Publishing-Pipeline

on:
  pull_request:
    branches:
      - master

jobs:
  publish:
    runs-on: ubuntu-latest
    env:
      AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
      AZURE_CLIENT_SECRET: ${{ secrets.AZURE_CLIENT_SECRET }}
    steps:
      - name: Checkout code
        uses: actions/checkout@v5

      - name: Set up Node.js
        uses: actions/setup-node@v5
        with:
          node-version: '20.x'

      - name: Install dependencies
        run: npm install

      - name: Run publish command
        run: npm run publish
```

------------------------------

<!--
### config.publish.json file

Go to the `src` folder and open the `config.publish.json` file.
    
```json
{
    "environment": "publishing",
    "armEndpoint": "management.azure.com",
    "subscriptionId":"<service subscription>",
    "resourceGroupName":"<service resource group>",
    "serviceName":"<service name>",
    "clientId": "<Optional. The Client ID of the Microsoft Entra application that users will sign into>",
    "tenantId": "<Optional. The Microsoft Entra tenant (directory) ID>",
    "useHipCaptcha": false
}
```

Configure the file:

1. Copy and paste the `subscriptionId`, `resourceGroupName`, and `serviceName`values from the previous configuration file. 

1. Optionally, set `clientId` and `tenantId` to the client ID and tenant ID of the Microsoft Entra app that you configured for users to sign into. 

### config.runtime.json file

Go to the `src` folder and open the `config.runtime.json` file.

```json
{
    "environment": "runtime",
    "backendUrl": "https://<service-name>.developer.azure-api.net",
    "featureFlags": {
        "clientTelemetry": true
    },

    "directDataApi": false,
    "dataApiUrl": "https://<service name>.data.azure-api.net"
}
```

Configuration of this file differs depending on whether your API Management instance is created in one of the v2 tiers or in one of the classic tiers.

#### [v2 tiers](#tab/v2-tiers)

1. Configure settings for the direct data API: 
    * Set `directDataApi` to true. 
    * In the `dataApiUrl` value, replace `<service name>` with the name of your API Management instance. If you configured a [custom domain](configure-custom-domain.md), use it instead (for example, `https://portal.contoso.com`).
    
        ```json
        {
        ...
        "directDataApi": true,
        "dataApiUrl": "https://contoso-api.data.azure-api.net"
        ...
        }
        ```

1. Optionally, in `featureFlags`, if you want to collect user session data from the developer portal, set `"clientTelemetry": true`.

#### [Classic tiers](#tab/classic)

1. You can configure either `backendUrl` or settings for the direct data API.  

    > [!IMPORTANT]
    > Remove the `backendUrl` setting if you set `directDataApi` to true. And conversely, remove direct data API settings if you configure the `backendUrl`.

    * To set the `backendUrl` value, replace `<service-name>` with the name of your API Management instance. If you configured a [custom domain](configure-custom-domain.md) for your developer portal, use it instead (for example. `https://portal.contoso.com`).

        ```json
        {
        ...
        "backendUrl": "https://contoso-api.developer.azure-api.net"
        ...
        }
        ```

    * To use the direct data API, set `directDataApi` to true. In the `dataApiUrl` value, replace `<service name>` with the name of your API Management instance. If you configured a [custom domain](configure-custom-domain.md), use it instead (for example, `https://portal.contoso.com`).
    
        ```json
        {
        ...
        "directDataApi": true,
        "dataApiUrl": "https://contoso-api.data.azure-api.net"
        ...
        }
        ```

1. Optionally, in `featureFlags`, if you want to collect user session data from the developer portal, set `"clientTelemetry": true`.

---

### Configure the static website

Configure the **Static website** feature in your storage account by providing routes to the index and error pages:

1. Go to your storage account in the Azure portal and select **Data management** > **Static website** from the menu on the left.

1. On the **Static website** page, select **Enabled**.

1. In the **Index document name** field, enter *index.html*.

1. In the **Error document path** field, enter *404/index.html*.

1. Select **Save**.

### Configure CORS settings for storage account

Configure the cross-origin resource sharing (CORS) settings for the storage account:

1. Go to your storage account in the Azure portal.

1. From the menu on the left, under **Settings**, select **Resource sharing (CORS)**.

1. In the **Blob service** tab, configure the following rules:

    | Rule | Value |
    | ---- | ----- |
    | Allowed origins | * |
    | Allowed methods | Select all the HTTP verbs. |
    | Allowed headers | * |
    | Exposed headers | * |
    | Max age | 0 |

1. Select **Save**.

### Configure CORS settings for developer portal backend

<!-- Necessary for both backendUrl and directDataApi settings? -->

Configure CORS settings for the developer portal backend to allow requests originating through your self-hosted developer portal. The self-hosted developer portal relies on the developer portal's backend endpoint (set in `backendUrl` in the portal configuration files) to enable several features, including: 

* CAPTCHA verification
* [OAuth 2.0 authorization](api-management-howto-oauth2.md) in the test console
* [Delegation](api-management-howto-setup-delegation.md) of user authentication and product subscription 

To add CORS settings:

1. Go to your API Management instance in the Azure portal, and select **Developer portal** > **Portal settings** from the menu on the left.
1. On the **Self-hosted portal configuration** tab, add one or more **Origin** domain values. For example:
    * The domain where the self-hosted portal is hosted, such as `https://www.contoso.com` 
    * `localhost` for local development (if applicable), such as `http://localhost:8080` or `https://localhost:8080` 
1. Select **Save**.


## Step 3: Run the portal

Now you can build and run a local portal instance in the development mode. In development mode, all the optimizations are turned off and the source maps are turned on.

Run the following command:

```console
npm run start
```

After a short time, the default browser automatically opens with your local developer portal instance. The default address is `http://localhost:8080`, but the port can change if `8080` is already occupied. When you make changes to the codebase of the project, it triggers a rebuild and refreshes your browser window.

## Step 4: Edit through the visual editor

Use the visual editor to carry out these tasks:

- Customize your portal
- Author content
- Organize the structure of the website
- Stylize its appearance

See [Tutorial: Access and customize the developer portal](api-management-howto-developer-portal-customize.md). It covers the basics of the administrative user interface and lists recommended changes to the default content. Save all changes in the local environment, and press **Ctrl+C** to close it.

## Step 5: Publish locally

The portal data originates in the form of strong-typed objects. The following command translates them into static files and places the output in the `./dist/website` directory:

```console
npm run publish-arm
```

## Step 6: Upload static files to a blob

Use the Azure CLI to upload the locally generated static files to a blob, and make sure your visitors can get to them:

1. Open Windows Command Prompt, PowerShell, or other command shell.

1. Run the following Azure CLI command.
   
    Replace `<account-access-key>` with an access key your storage account. You can get it from the **Security + networking** > **Access keys** section of your storage account.

    ```azurecli
    az storage blob upload-batch --source dist/website \
        --account-name <your-storage-account-name> \
        --destination '$web' \
        --account-key "<account-access-key>"
    ```

-->
## Step 7: Go to your website

Your website is now live under the hostname specified in your Azure Storage properties. Go to **Primary endpoint** in **Data management** > **Static website**.

## Step 8: Change API Management notification templates

Replace the developer portal URL in the API Management notification templates so that it points to your self-hosted portal. See [How to configure notifications and email templates in Azure API Management](api-management-howto-configure-notifications.md).

In particular, carry out the following changes to the default templates:

> [!NOTE]
> The values in the following **Updated** sections assume that you're hosting the portal at **https:\//portal.contoso.com/**. 

### Email change confirmation

Update the developer portal URL in the **Email change confirmation** notification template:

**Original content**

```html
<a id="confirmUrl" href="$ConfirmUrl" style="text-decoration:none">
  <strong>$ConfirmUrl</strong></a>
```

**Updated**

```html
<a id="confirmUrl" href="https://portal.contoso.com/signup?$ConfirmQuery" style="text-decoration:none">
  <strong>https://portal.contoso.com/signup?$ConfirmQuery</strong></a>
```

### New developer account confirmation

Update the developer portal URL in the **New developer account confirmation** notification template:

**Original content**

```html
<a id="confirmUrl" href="$ConfirmUrl" style="text-decoration:none">
  <strong>$ConfirmUrl</strong></a>
```

**Updated**

```html
<a id="confirmUrl" href="https://portal.contoso.com/signup?$ConfirmQuery" style="text-decoration:none">
  <strong>https://portal.contoso.com/signup?$ConfirmQuery</strong></a>
```

### Invite user

Update the developer portal URL in the **Invite user** notification template:

**Original content**

```html
<a href="$ConfirmUrl">$ConfirmUrl</a>
```

**Updated**

```html
<a href="https://portal.contoso.com/confirm-v2/identities/basic/invite?$ConfirmQuery">https://portal.contoso.com/confirm-v2/identities/basic/invite?$ConfirmQuery</a>
```

### New subscription activated

Update the developer portal URL in the **New subscription activated** notification template:

**Original content**

```html
Thank you for subscribing to the <a href="http://$DevPortalUrl/products/$ProdId"><strong>$ProdName</strong></a> and welcome to the $OrganizationName developer community. We are delighted to have you as part of the team and are looking forward to the amazing applications you will build using our API!
```

**Updated**

```html
Thank you for subscribing to the <a href="https://portal.contoso.com/product#product=$ProdId"><strong>$ProdName</strong></a> and welcome to the $OrganizationName developer community. We are delighted to have you as part of the team and are looking forward to the amazing applications you will build using our API!
```

**Original content**

```html
Visit the developer <a href="http://$DevPortalUrl/developer">profile area</a> to manage your subscription and subscription keys
```

**Updated**

```html
Visit the developer <a href="https://portal.contoso.com/profile">profile area</a> to manage your subscription and subscription keys
```

**Original content**

```html
<a href="http://$DevPortalUrl/docs/services?product=$ProdId">Learn about the API</a>
```

**Updated**

```html
<a href="https://portal.contoso.com/product#product=$ProdId">Learn about the API</a>
```

**Original content**

```html
<p style="font-size:12pt;font-family:'Segoe UI'">
  <strong>
    <a href="http://$DevPortalUrl/applications">Feature your app in the app gallery</a>
  </strong>
</p>
<p style="font-size:12pt;font-family:'Segoe UI'">You can publish your application on our gallery for increased visibility to potential new users.</p>
<p style="font-size:12pt;font-family:'Segoe UI'">
  <strong>
    <a href="http://$DevPortalUrl/issues">Stay in touch</a>
  </strong>
</p>
<p style="font-size:12pt;font-family:'Segoe UI'">
      If you have an issue, a question, a suggestion, a request, or if you just want to tell us something, go to the <a href="http://$DevPortalUrl/issues">Issues</a> page on the developer portal and create a new topic.
</p>
```

**Updated**

```html
<!--Remove the entire block of HTML code above.-->
```

### Password change confirmation

Update the developer portal URL in the **Password change confirmation** notification template:

**Original content**

```html
<a href="$DevPortalUrl">$DevPortalUrl</a>
```

**Updated**

```html
<a href="https://portal.contoso.com/confirm-password?$ConfirmQuery">https://portal.contoso.com/confirm-password?$ConfirmQuery</a>
```

### All templates

Update the developer portal URL in any template that has a link in the footer:

**Original content**

```html
<a href="$DevPortalUrl">$DevPortalUrl</a>
```

**Updated**

```html
<a href="https://portal.contoso.com/">https://portal.contoso.com/</a>
```

## Move from managed to self-hosted developer portal

Over time, your business requirements may change. You can end up in a situation where the managed version of the API Management developer portal no longer satisfies your needs. For example, a new requirement may force you to build a custom widget that integrates with a third-party data provider. Unlike the managed version, the self-hosted version of the portal offers you full flexibility and extensibility.

### Transition process

You can transition from the managed version to a self-hosted version within the same API Management service instance. The process preserves the modifications that you carried out in the managed version of the portal. Make sure you back up the portal's content beforehand. You can find the backup script in the `scripts` folder of the API Management developer portal [GitHub repo](https://github.com/Azure/api-management-developer-portal).

The conversion process is almost identical to setting up a generic self-hosted portal, as shown in previous steps in this article. There is one exception in the configuration step. The storage account in the `config.design.json` file needs to be the same as the storage account of the managed version of the portal. See [Tutorial: Use a Linux VM system-assigned identity to access Azure Storage via a SAS credential](../active-directory/managed-identities-azure-resources/tutorial-linux-vm-access-storage-sas.md#get-a-sas-credential-from-azure-resource-manager-to-make-storage-calls) for instructions on how to retrieve the SAS URL.

> [!TIP]
> We recommend using a separate storage account in the `config.publish.json` file. This approach gives you more control and simplifies the management of the hosting service of your portal.


## Related content

- Learn about [Alternative approaches to self-hosting](developer-portal-alternative-processes-self-host.md)
