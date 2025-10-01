---
title: Authorize access for AzCopy with a managed identity
description: You can provide authorization credentials for AzCopy operations by a managed identity
author: normesta
ms.service: azure-storage
ms.topic: how-to
ms.date: 02/26/2025
ms.author: normesta
ms.subservice: storage-common-concepts
ms.custom: devx-track-azurecli, devx-track-azurepowershell
# Customer intent: "As a cloud administrator or developer, I want to authorize AzCopy operations using managed identities, so that I can securely transfer files to and from Azure Storage without managing credentials or SAS tokens, especially in automated scenarios and VM-based workloads."
---

# Authorize access for AzCopy using a managed identity

Managed identities provide a secure and convenient way to authorize [AzCopy](storage-use-azcopy-v10.md) operations without storing credentials or managing SAS tokens. This authentication method is particularly valuable for automated scripts, CI/CD pipelines, and applications running on Azure Virtual Machines or other Azure services.

This article shows you how to configure AzCopy to use either system-assigned or user-assigned managed identities. You'll learn to authorize access through environment variables, the AzCopy login command, or by leveraging existing Azure CLI or Azure PowerShell sessions.

To learn about other ways to authorize access to AzCopy, see [Authorize AzCopy](storage-use-azcopy-v10.md#authorize-azcopy).

## Verify role assignments

Ensure your managed identity has the required Azure role for your intended operations:

- **Download operations**: [Storage Blob Data Reader](../../role-based-access-control/built-in-roles.md#storage-blob-data-reader) (Blob Storage) or [Storage File Data Privileged Reader](../../role-based-access-control/built-in-roles.md#storage-file-data-privileged-reader) (Azure Files)

- **Upload operations**: [Storage Blob Data Contributor](../../role-based-access-control/built-in-roles.md#storage-blob-data-contributor) or [Storage Blob Data Owner](../../role-based-access-control/built-in-roles.md#storage-blob-data-owner) (Blob Storage) or [Storage File Data Privileged Contributor](../../role-based-access-control/built-in-roles.md#storage-file-data-privileged-contributor) (Azure Files)

For role assignment instructions, see [Assign an Azure role for access to blob data](../blobs/assign-azure-role-data-access.md) (Blob Storage) or [Choose how to authorize access to file data in the Azure portal](../files/authorize-data-operations-portal.md) (Azure Files).

> [!NOTE]
> Role assignments can take up to five minutes to propagate.

If you're transferring blobs in an account that has a hierarchical namespace, you don't need to have one of these roles assigned to your security principal if your security principal is added to the access control list (ACL) of the target container or directory. In the ACL, your security principal needs write permission on the target directory, and execute permission on container and each parent directory. To learn more, see [Access control model in Azure Data Lake Storage](../blobs/data-lake-storage-access-control-model.md).

## Authorize with environment variables

To authorize access, you'll set in-memory environment variables. Then run any AzCopy command. AzCopy will retrieve the Auth token required to complete the operation. After the operation completes, the token disappears from memory.

AzCopy retrieves the OAuth token by using the credentials that you provide. Alternatively, AzCopy can use the OAuth token of an active Azure CLI or Azure PowerShell session.

This is a great option if you plan to use AzCopy inside of a script that runs without user interaction, and the script runs from an Azure Virtual Machine (VM). When using this option, you won't have to store any credentials on the VM.

You can sign into your account by using a system-wide managed identity that you've enabled on your VM, or by using the client ID, Object ID, or Resource ID of a user-assigned managed identity that you've assigned to your VM.

To learn more about how to enable a system-wide managed identity or create a user-assigned managed identity, see [Configure managed identities for Azure resources on a VM using the Azure portal](../../active-directory/managed-identities-azure-resources/qs-configure-portal-windows-vm.md#enable-system-assigned-managed-identity-on-an-existing-vm).

### Authorize with a system-wide managed identity

First, make sure that you've enabled a system-wide managed identity on your VM. See [System-assigned managed identity](../../active-directory/managed-identities-azure-resources/qs-configure-portal-windows-vm.md#system-assigned-managed-identity).

Type the following command, and then press the ENTER key.

```bash
export AZCOPY_AUTO_LOGIN_TYPE=MSI
```

Then, run any azcopy command (For example: `azcopy list https://contoso.blob.core.windows.net`).

### Authorize with a user-assigned managed identity

First, make sure that you've enabled a user-assigned managed identity on your VM. See [User-assigned managed identity](../../active-directory/managed-identities-azure-resources/qs-configure-portal-windows-vm.md#user-assigned-managed-identity).

Type the following command, and then press the ENTER key.

```bash
export AZCOPY_AUTO_LOGIN_TYPE=MSI
```

Then, type any of the following commands, and then press the ENTER key.

```bash
export AZCOPY_MSI_CLIENT_ID=<client-id>
```

Replace the `<client-id>` placeholder with the client ID of the user-assigned managed identity.

```bash
export AZCOPY_MSI_OBJECT_ID=<object-id>
```

Replace the `<object-id>` placeholder with the object ID of the user-assigned managed identity.

```bash
export AZCOPY_MSI_RESOURCE_STRING=<resource-id>
```

Replace the `<resource-id>` placeholder with the resource ID of the user-assigned managed identity.

After you set these variables, you can run any azcopy command (For example: `azcopy list https://contoso.blob.core.windows.net`).

<a id="service-principal"></a>

## Authorize with the AzCopy login command

As an alternative to using in-memory variables, you authorize access by using the azcopy login command.

The azcopy login command retrieves an OAuth token and then places that token into a secret store on your system. If your operating system doesn't have a secret store such as a Linux keyring, the azcopy login command won't work because there is nowhere to place the token.

### Authorize with a system-wide managed identity

First, make sure that you've enabled a system-wide managed identity on your VM. See [System-assigned managed identity](../../active-directory/managed-identities-azure-resources/qs-configure-portal-windows-vm.md#system-assigned-managed-identity).

Then, in your command console, type the following command, and then press the ENTER key.

```azcopy
azcopy login --identity
```

### Authorize with a user-assigned managed identity

First, make sure that you've enabled a user-assigned managed identity on your VM. See [User-assigned managed identity](../../active-directory/managed-identities-azure-resources/qs-configure-portal-windows-vm.md#user-assigned-managed-identity).

Then, in your command console, type any of the following commands, and then press the ENTER key.

```azcopy
azcopy login --identity --identity-client-id "<client-id>"
```

Replace the `<client-id>` placeholder with the client ID of the user-assigned managed identity.

```azcopy
azcopy login --identity --identity-object-id "<object-id>"
```

Replace the `<object-id>` placeholder with the object ID of the user-assigned managed identity.

```azcopy
azcopy login --identity --identity-resource-id "<resource-id>"
```

Replace the `<resource-id>` placeholder with the resource ID of the user-assigned managed identity.

## Authorize with Azure CLI

If you sign in by using Azure CLI, then Azure CLI obtains an OAuth token that AzCopy can use to authorize operations. 

To enable AzCopy to use that token, type the following command, and then press the ENTER key.

```bash
export AZCOPY_AUTO_LOGIN_TYPE=AZCLI
export AZCOPY_TENANT_ID=<tenant-id>
```

For more information about how to sign in with the Azure CLI, see [Sign into Azure with a managed identity using Azure CLI](/cli/azure/authenticate-azure-cli-managed-identity).

## Authorize with Azure PowerShell

If you sign in by using Azure PowerShell, then Azure PowerShell obtains an OAuth token that AzCopy can use to authorize operations.  

To enable AzCopy to use that token, type the following command, and then press the ENTER key.

```PowerShell
$Env:AZCOPY_AUTO_LOGIN_TYPE="PSCRED"
```

For more information about how to sign in with the Azure PowerShell, see [Sign in with Azure PowerShell](/powershell/azure/authenticate-noninteractive#login-with-a-managed-identity).

## Next steps

- For more information about AzCopy, [Get started with AzCopy](storage-use-azcopy-v10.md)

- If you have questions, issues, or general feedback, submit them [on GitHub](https://github.com/Azure/azure-storage-azcopy) page.
