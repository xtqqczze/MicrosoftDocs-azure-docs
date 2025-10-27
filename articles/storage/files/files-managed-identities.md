---
title: Use Managed Identities with Azure Files (preview)
description: This article explains how you can authenticate managed identities to allow applications and virtual machines to access SMB Azure file shares using identity-based authentication with Microsoft Entra ID.
author: khdownie
ms.service: azure-file-storage
ms.topic: how-to
ms.date: 10/27/2025
ms.author: kendownie
ms.custom:
  - devx-track-azurepowershell
  - references_regions
# Customer intent: As a cloud administrator, I want to improve security by authenticating managed identities to allow applications and virtual machines to access SMB Azure Files shares using identity-based authentication with Microsoft Entra ID instead of using a storage account key.
---

# Access SMB Azure file shares using managed identities with Microsoft Entra ID (preview)

**Applies to:** :heavy_check_mark: SMB Azure file shares

This article explains how you can use [managed identities](/entra/identity/managed-identities-azure-resources/overview) to allow applications and virtual machines (VMs) to access SMB Azure file shares using identity-based authentication with Microsoft Entra ID (preview). A managed identity is an identity in Microsoft Entra ID that is automatically managed by Azure. You typically use managed identities when developing cloud applications to manage the credentials for authenticating to Azure services. 

By the end of this guide, you'll have a storage account and VM configured with a managed identity. Then you'll mount a file share without using a storage account key.

## Why authenticate using a managed identity?

For security reasons, using storage account keys to access a file share isn't recommended. When you assign a managed identity to a VM, you can use that identity to authenticate the VM.

Benefits include:

- **Enhanced security:** No dependency on storage account keys to manage or expose

- **Simplified management:** No key rotation required

- **Fine-grained access control:** Role-based access at the identity level

- **Automation friendly:** Easy to integrate with CI/CD pipelines and applications

- **Cost effective:** Managed identities can be used at no extra cost

## Prerequisites

This article assumes that you have an Azure subscription with permissions to create storage accounts and assign Azure Role-Based Access Control (RBAC) roles.

### Prepare your PowerShell environment

Open a PowerShell window as administrator and run the following command to set the PowerShell execution policy:

```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser 
```

Make sure you have the latest PowerShellGet:

```powershell
Install-Module PowerShellGet -Force -AllowClobber 
```

Install the Az module if it isn't already installed:

```powershell
Install-Module -Name Az -Repository PSGallery -Force 
Import-Module Az 
```

Sign into Azure:

```powershell
Connect-AzAccount
```

Select your subscription by specifying your subscription ID (recommended):

```powershell
Set-AzContext -SubscriptionId "<subscription-ID>" 
```

You can also select your subscription by specifying your subscription name:

```powershell
Set-AzContext -Subscription "<subscription-name>" 
```

## Configure the SMB oAuth property on your storage account

In order to authenticate a managed identity, you must configure the SMB OAuth property on the storage account that contains the Azure file share you want to access. We recommend creating a new storage account for this purpose. You can use an existing storage account only if it doesn't have Microsoft Entra Kerberos enabled as the identity source.

Download this script to create or configure the storage account. Save it as `SBD_PREP.ps1`. 

Open a PowerShell window as administrator and use the downloaded script to create or modify a storage account and create a file share. Replace `<subscription-ID>`, `<resource-group>`, `<region-name>`, `<storage-account-name>`, and `<file-share-name>` with your own values.

```powershell
.\SBD_PREP.ps1 -subscription <subscription-ID> -resourceGroup <resource-group> -location <region-name> -accountName <storage-account-name> -shareName <file-share-name>
```

You can ignore any warnings unless the script fails with exceptions. 

Running the script multiple times is safe. It will reapply the SMB OAuth property and skip file share creation if the file share already exists. 

Once the script completes, you should have a storage account and file share ready for SMB OAuth authentication. Verify in the Azure portal that your storage account and file share were created.

## Prepare your VM and assign roles

The enablement steps are different for Azure VMs versus non-Azure VMs. Once enabled, all necessary permissions can be granted via Azure RBAC.

### Azure VM enablement

If you want to authenticate an Azure VM, follow these steps.

1. Create a VM in Azure. Your VM must be running Windows Server 2019 or higher for server SKUs, or any Windows client SKU. See [Create a Windows virtual machine in the Azure portal](/azure/virtual-machines/windows/quick-create-portal).

1. Enable a managed identity on the VM. It can be either [system-assigned or user-assigned](/entra/identity/managed-identities-azure-resources/overview#differences-between-system-assigned-and-user-assigned-managed-identities). If the VM has both system- and user-assigned identities, Azure defaults to system assigned. Assign only one for best results. You can enable a system-assigned managed identity during VM creation on the **Management** tab.

    :::image type="content" source="media/files-managed-identities/enable-system-assigned-managed-identity.png" alt-text="Screenshot showing how to enable system assigned managed identity when creating a new VM using the Azure portal." border="true":::

1. Assign the built-in Azure RBAC role **Storage File Data SMB MI Admin** role to the managed identity at the desired scope. See [Steps to assign an Azure role](/azure/role-based-access-control/role-assignments-steps).

### Non-Azure Windows device enablement  

For non-Azure Windows machines (on-prem or other cloud), follow these steps. 

1. [Onboard them to Azure Arc and assign a managed identity](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-identity-and-access-management).

1. Assign the built-in Azure RBAC role **Storage File Data SMB MI Admin** role to the managed identity at the desired scope. See [Steps to assign an Azure role](/azure/role-based-access-control/role-assignments-steps).

## Mount a file share on a Windows VM

Now that your storage account and permissions are configured, follow these steps to mount the file share using managed identity authentication.



> [!TIP]
> To view complete usage information and examples, run the executable without any parameters: `AzFilesSmbMIClient.exe`


## See also
 
- [Overview of Azure Files identity-based authentication for SMB access](storage-files-active-directory-overview.md)
- [Overview of Azure Files authorization and access control](storage-files-authorization-overview.md)
