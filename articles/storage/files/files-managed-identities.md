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

This article explains how you can authenticate managed identities to allow applications and virtual machines (VMs) to access SMB Azure file shares using identity-based authentication with Microsoft Entra ID (preview). It covers role assignments, storage account setup, VM preparation, package installation, and client configuration. By the end of this guide, you'll have a storage account and VM configured with a managed identity. Then you'll mount a file share without using a storage account key.

## Why authenticate using a managed identity?

For security reasons, using storage account keys to access a file share isn't recommended. When you assign a managed identity to a VM, you can use that identity to authenticate the VM with Azure Files

Benefits include:

- **Enhanced security:** No dependency on storage account keys to manage or expose

- **Simplified management:** No key rotation required

- **Fine-grained access control:** Role-based access at the identity level

- **Automation friendly:** Easy to integrate with CI/CD pipelines and applications

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

The enablement steps are different for Azure VMs versus non-Azure VMs.

> [!NOTE]
> If the VM has both system and user assigned identities, Azure defaults to system assigned. Assign only one for best results. 

## See also
 
- [Overview of Azure Files identity-based authentication for SMB access](storage-files-active-directory-overview.md)
- [Overview of Azure Files authorization and access control](storage-files-authorization-overview.md)
