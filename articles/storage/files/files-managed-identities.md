---
title: Use Managed Identities with Azure Files (preview)
description: This article explains how you can authenticate managed identities to allow applications and virtual machines to access SMB Azure file shares using identity-based authentication with Microsoft Entra ID.
author: khdownie
ms.service: azure-file-storage
ms.topic: how-to
ms.date: 10/30/2025
ms.author: kendownie
ms.custom:
  - devx-track-azurepowershell
# Customer intent: As a cloud administrator, I want to improve security by authenticating managed identities to allow applications and virtual machines to access SMB Azure Files shares using identity-based authentication with Microsoft Entra ID instead of using a storage account key.
---

# Access SMB Azure file shares using managed identities with Microsoft Entra ID (preview)

**Applies to:** :heavy_check_mark: SMB Azure file shares

This article explains how you can use [managed identities](/entra/identity/managed-identities-azure-resources/overview) to allow Windows and Linux virtual machines (VMs) to access SMB Azure file shares using identity-based authentication with Microsoft Entra ID (preview). 

A managed identity is an identity in Microsoft Entra ID that is automatically managed by Azure. You typically use managed identities when developing cloud applications to manage the credentials for authenticating to Azure services. 

By the end of this guide, you'll have a storage account with SMB OAuth configured and a VM configured with a managed identity. Then you'll mount a file share using identity-based authentication, with no need to use a storage account key.

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

Open PowerShell as administrator and run the following command to set the PowerShell execution policy:

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

## Configure SMB OAuth on your storage account

In order to authenticate a managed identity, you must enable the SMB OAuth property on the storage account that contains the Azure file share you want to access. We recommend creating a new storage account for this purpose. You can use an existing storage account only if it doesn't have Microsoft Entra Kerberos enabled as the identity source.

To create a new storage account with SMBOAuth enabled, run the following PowerShell command as administrator. Replace `<resource-group>`, `<storage-account-name>`, and `<region>` with your values. You can specify a different SKU if needed.

```powershell
New-AzStorageAccount -ResourceGroupName <resource-group> -Name <storage-account-name> -SkuName Standard_LRS -Location <region> -EnableSmbOAuth $true
```

To enable SMBOAuth on an existing storage account, run the following PowerShell command. Replace `<resource-group>` and `<storage-account-name>` with your values.

```powershell
Set-AzStorageAccount -ResourceGroupName <resource-group> -Name <storage-account-name> -EnableSmbOAuth $true
```

If you see errors that the resource was disallowed by policy, then you might have a policy set on your subscription disallowing `Set-AzStorageAccount`. To workaround, retry using the following command:

```powershell
Set-AzStorageAccount -ResourceGroupName <resource-group> -Name <storage-account-name> -EnableSmbOAuth $true -AllowBlobPublicAccess $false
```

Next, create an SMB file share on the storage account. Replace `<resource-group>`, `<storage-account-name>`, and `<file-share-name>` with your values. 

```powershell
$storageAccount = Get-AzStorageAccount -ResourceGroupName <resource-group> -Name <storage-account-name>
New-AzStorageShare -Name <file-share-name> -Context $storageAccount.Context
```

You should now have a storage account and file share ready for SMB OAuth authentication. Verify in the Azure portal that your storage account and file share were created.

## Configure managed identity

You can use managed identities with Windows or Linux. Select the appropriate tab and follow the instructions for your operating system.

### [Windows](#tab/windows)

For Windows, the enablement steps are different for Azure VMs versus non-Azure VMs. Once a managed identity is enabled on the VM, all necessary permissions can be granted via Azure RBAC.

### Enable managed identity on an Azure VM

If you want to authenticate an Azure VM, follow these steps.

1. Sign in to the Azure portal and create a Windows VM. Your VM must be running Windows Server 2019 or higher for server SKUs, or any Windows client SKU. See [Create a Windows virtual machine in the Azure portal](/azure/virtual-machines/windows/quick-create-portal).

1. Enable a managed identity on the VM. It can be either [system-assigned or user-assigned](/entra/identity/managed-identities-azure-resources/overview#differences-between-system-assigned-and-user-assigned-managed-identities). If the VM has both system- and user-assigned identities, Azure defaults to system assigned. Assign only one for best results. You can enable a system-assigned managed identity during VM creation on the **Management** tab.

    :::image type="content" source="media/managed-identities/enable-system-assigned-managed-identity.png" alt-text="Screenshot showing how to enable system assigned managed identity when creating a new VM using the Azure portal." border="true":::

1. Assign the built-in Azure RBAC role **Storage File Data SMB MI Admin** role to the managed identity at the desired scope. See [Steps to assign an Azure role](/azure/role-based-access-control/role-assignments-steps).

### Enable managed identity on a non-Azure Windows device

To enable a managed identity on non-Azure Windows machines (on-prem or other cloud), follow these steps.

1. [Onboard them to Azure Arc and assign a managed identity](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-identity-and-access-management).

1. Assign the built-in Azure RBAC role **Storage File Data SMB MI Admin** role to the managed identity at the desired scope. See [Steps to assign an Azure role](/azure/role-based-access-control/role-assignments-steps).


### [Linux](#tab/linux)

To configure a managed identity on a Linux VM running in Azure, follow these steps. Your VM must be running Azure Linux 3.0, Ubuntu 22.04, or Ubuntu 24.04.

> [!NOTE]
> System-assigned managed identities aren't supported on Linux VMs. You must create a user-assigned managed identity.

1. Sign in to the Azure portal and [create a user-assigned managed identity](/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal#create-a-user-assigned-managed-identity).

1. Navigate to the managed identity and copy your client ID. You'll need this later when configuring the Linux VM to use the managed identity.

1. Navigate to the storage account that contains the file share. Select **IAM (Access control)** from the service menu.

1. Assign the built-in **Storage File Data SMB MI Admin** role to the managed identity at the right scope.

1. Navigate to your Linux VM. From the service menu, select **Security**, and then select **Identity**.

1. You’ll see two options: **System-assigned** and **User-assigned**. Enable a user-assigned managed identity for the VM. Select the User-assigned identity you created earlier and assign it to the VM using the client ID you copied in the previous step.

---

## Prepare your client to authenticate using a managed identity

Follow these steps to prepare your system to mount the file share using managed identity authentication. The steps are different for Windows and Linux clients.

### [Windows](#tab/windows)

To prepare your client VM or Windows device to authenticate using a managed identity, follow these steps.

1. Log into your VM or device that has the managed identity assigned and open a PowerShell window as administrator. You'll need either PowerShell 5.1+ or PowerShell 7+.

1. Install the [Azure Files SMB Managed Identity Client](https://www.powershellgallery.com/packages/AzFilesSmbMIClient/1.0.4) PowerShell module and import it:

   ```powershell
   Install-Module AzFilesSMBMIClient 
   Import-Module AzFilesSMBMIClient 
   ```

1. Check your current Powershell execution policy by running the following command:

   ```powershell
   Get-ExecutionPolicy -List 
   ```

   If the execution policy on CurrentUser is **Restricted** or **Undefined**, change it to **RemoteSigned**. If the execution policy is **RemoteSigned**, **Default**, **AllSigned**, **Bypass**, or **Unrestricted**, you can skip this step. 

   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser 
   ```

### Refresh the authentication credentials

Before you can mount the file share using the managed identity, you must refresh the authentication credentials and specify your storage account endpoint. To copy your storage account URI, navigate to the storage account in the Azure portal and then select **Settings** > **Endpoints** from the service menu. Be sure to copy the entire URI including the trailing slash: `https://<storage-account-name>.file.core.windows.net/`

```powershell
AzFilesSMBMIClient.exe refresh --uri https://<storage-account-name>.file.core.windows.net/
```

This will get an OAuth token and insert it in the Kerberos cache, and will auto-refresh when the token is close to expiration. Optionally, you can omit the `refresh`.

If your Windows VM has both user-assigned and system-assigned managed identities configured, you can use the following command to specify the user-assigned managed identity:

```powershell
AzFilesSmbMIClient.exe refresh --uri https://<storage-account-name>.file.core.windows.net/ --clientId <ClientId> 
```

> [!TIP]
> To view complete usage information and examples, run the executable without any parameters: `AzFilesSmbMIClient.exe`

### [Linux](#tab/linux)

To prepare your Linux VM to authenticate using a managed identity, follow these steps.

---

## Mount a file share using a managed identity

You should now be able to mount the file share on Windows or Linux without using a storage account key.

### [Windows](#tab/windows)

On Windows clients, you can directly access your Azure file share using the UNC path by entering the following into File Explorer. Be sure to replace `<storage-account-name>` with your storage account name and `<file-share-name>` with your file share name:

`\\<storage-account-name>.file.core.windows.net\<file-share-name>`

See [Mount SMB Azure file share on Windows](storage-how-to-use-files-windows.md).

### [Linux](#tab/linux)

Linux content here.

See [Mount SMB Azure file shares on Linux clients](storage-how-to-use-files-linux.md).

---

## Troubleshooting

If you encounter issues when mounting your file share, follow these steps to enable verbose logging and collect diagnostic information.

1. On Windows clients, use the Registry Editor to set the **Data** level for **verbosity** to 0x00000004 (4) for `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Azure\Storage\Files\SmbAuth`.

1. Try to mount the share again and reproduce the error.

1. You should now have a file named `AzFilesSmbMILog.log`. Send the log file to azurefilespm@microsoft.com for assistance.

## Client library installation and integration options 

For developers who need to integrate managed identities into their applications, multiple implementation approaches are available depending on your application architecture and requirements.

### Managed assembly integration: NuGet package

For .NET applications, the [Microsoft.Azure.AzFilesSmbMI](https://msazure.pkgs.visualstudio.com/_packaging/Official/nuget/v3/index.json) NuGet package includes a managed assembly (Microsoft.Azure.AzFilesSmbMI.dll) that provides direct access to the SMB OAuth authentication functionality. This approach is recommended for C# and other .NET-based applications.

Installation: `Install-Package Microsoft.Azure.AzFilesSmbMI -version 1.2.3168.94`

### Native DLL integration

For native applications requiring direct API access, AzFilesSmbMIClient is available as a [native DLL](https://github.com/Azure/AzFilesSmbMIClient). This is particularly useful for C/C++ applications or systems requiring lower-level integration. See the [Windows implementation](https://github.com/Azure/AzFilesSmbMIClient/tree/main/Windows) and [API reference](https://github.com/Azure/AzFilesSmbMIClient/blob/main/Windows/dll/src/AzFilesSmbMI.h) (native header file).

#### Native API methods

The native DLL exports the following core methods for credential management:

```cpp
extern "C" AZFILESSMBMI_API HRESULT SmbSetCredential( 
    _In_  PCWSTR pwszFileEndpointUri, 
    _In_  PCWSTR pwszOauthToken, 
    _In_  PCWSTR pwszClientID, 
    _Out_ PDWORD pdwCredentialExpiresInSeconds 
); 
extern "C" AZFILESSMBMI_API HRESULT SmbRefreshCredential( 
    _In_ PCWSTR pwszFileEndpointUri, 
    _In_ PCWSTR pwszClientID 
); 
extern "C" AZFILESSMBMI_API HRESULT SmbClearCredential( 
    _In_ PCWSTR pwszFileEndpointUri 
); 
```

## See also
 
- [Overview of Azure Files identity-based authentication for SMB access](storage-files-active-directory-overview.md)
- [Overview of Azure Files authorization and access control](storage-files-authorization-overview.md)
