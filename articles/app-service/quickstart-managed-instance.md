---
title: Create an App Service Managed Instance
description: Learn how to deploy your first App Service Managed Instance (ASMI) environment using Azure CLI and ARM templates.
keywords: app service, azure app service, scale, scalable, scalability, app service plan, app service cost
ms.topic: quickstart
ms.date: 09/12/2025
ms.author: msangapu
author: msangapu-msft
ms.service: azure-app-service
---

# Deploy App Service Managed Instance

This article shows you how to deploy your first Azure App Service Managed Instance (ASMI) environment using Azure CLI and ARM templates. You create the required Azure resources, set up networking and identities, and deploy a web app to your managed instance. This process is for users in the ASMI private preview and requires access to the East US 2 EUAP region.

## Prerequisites

Before you begin, make sure you have:

- Enrollment in the ASMI private preview program
- Azure CLI installed on your local machine
- Subscription access to the East US 2 EUAP region

## Create resource group

Create a resource group to hold all ASMI resources.

1. Open your terminal, and run the following command.
   ```shell
   az group create --name my-asmi-rg --location eastus2euap
   ```

## Create supporting resources

You need a virtual network, managed identity, storage account, and Key Vault to support your ASMI environment.

### Create virtual network

Set up a virtual network with a dedicated subnet for ASMI.

1. Run the following command.
   ```shell
   az network vnet create \
     --resource-group my-asmi-rg \
     --name my-asmi-vnet \
     --address-prefix 10.0.0.0/16 \
     --subnet-name default \
     --subnet-prefix 10.0.0.0/24 \
     --location eastus2euap
   ```
1. Check that the subnet is delegated to `Microsoft.Web/serverFarms` and isn't shared with other resources.

### Create user-assigned managed identity

1. Set up a managed identity.
   ```shell
   az identity create --name my-asmi-identity --resource-group my-asmi-rg --location eastus2euap
   ```

### Create storage account

1. Set up a storage account for scripts and files.
   ```shell
   az storage account create \
     --name myasmistorage \
     --resource-group my-asmi-rg \
     --location eastus2euap \
     --sku Standard_LRS \
     --allow-blob-public-access true
   ```

### Create Key Vault

1. Set up a Key Vault for storing secrets.
   ```shell
   az keyvault create \
     --name my-asmi-kv \
     --resource-group my-asmi-rg \
     --location eastus2euap \
     --enable-public-network true
   ```

## Deploy App Service Managed Instance plan

Deploy the ASMI plan using an ARM template, and enter the required parameters.

1. Run the following command, and replace the parameter values as needed.
   ```shell
   az deployment group create \
     --resource-group my-asmi-rg \
     --template-file create-app-service-managed-instance-plan.json \
     --parameters \
     appServicePlanName=my-asmi-plan \
     virtualNetworkSubnetResourceId=<subnet-resource-id> \
     userAssignedIdentityResourceId=<identity-resource-id> \
     keyVaultSecretUriForRegistryKey=<registry-key-secret-uri> \
     installScriptSourceUri=<blob-uri-to-install-script> \
     storageFileSharePath=<file-share-path> \
     storageDestinationPath="c:\\db" \
     keyVaultSecretUriForConnectionString=<connection-string-secret-uri> \
     registryKeyPath="HKEY_LOCAL_MACHINE\\Software\\Devshop\\sampval"
   ```

In the command, replace the placeholder text in angle brackets, like `<subnet-resource-id>`, with your own values. Use italics for user input if needed.

## Create web app

Deploy your first web app to the managed instance.

1. Run:
   ```shell
   az webapp create \
     --resource-group my-asmi-rg \
     --plan my-asmi-plan \
     --name my-asmi-app \
     --runtime "DOTNET|6.0"
   ```
2. **Important:** Do not enable Application Insights due to a known issue affecting Kudu startup.

## RDP for troubleshooting (optional)

You can use Azure Bastion to RDP into ASMI instances for troubleshooting.

1. Retrieve instance IPs:
   ```shell
   az rest --method get \
     --url https://brazilus.management.azure.com/subscriptions/<subscription>/resourceGroups/my-asmi-rg/providers/Microsoft.Web/serverfarms/my-asmi-plan/instances?api-version=2024-11-01
   ```
2. Get RDP password:
   ```shell
   az rest --method post \
     --url https://brazilus.management.azure.com/subscriptions/<subscription>/resourceGroups/my-asmi-rg/providers/Microsoft.Web/serverfarms/my-asmi-plan/getrdppassword?api-version=2024-11-01
   ```
3. Connect using Bastion:
   ```shell
   az network bastion rdp \
     --name my-bastion \
     --resource-group my-asmi-rg \
     --target-ip-address <instance-ip>
   ```
> **Note:** Changes made via RDP are ephemeral. Use installation scripts for persistent configuration.