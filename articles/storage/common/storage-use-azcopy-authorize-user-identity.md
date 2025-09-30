---
title: Authorize access for AzCopy with a user identity
description: You can provide authorization credentials for AzCopy operations by using a Microsoft Entra ID user identity.
author: normesta
ms.service: azure-storage
ms.topic: how-to
ms.date: 02/26/2025
ms.author: normesta
ms.subservice: storage-common-concepts
ms.custom: devx-track-azurecli, devx-track-azurepowershell
# Customer intent: "As a cloud administrator, I want to authorize access for AzCopy operations using Microsoft Entra ID, so that I can streamline file uploads and downloads without the need for SAS tokens, enhancing security and ease of management."
---

# Authorize access for AzCopy with a user identity

You can provide [AzCopy](storage-use-azcopy-v10.md) with authorization credentials by using Microsoft Entra user identity. By using Microsoft Entra ID, you can provide credentials once instead of having to append a SAS token to each command. Start by verifying your role assignments. Then, authorize your the user identity by using environment variables or by using the AzCopy login command. 

> [!TIP]
> You can also authorize access by using a managed identity, security principal or a shared access signature. To learn about other ways to authorize access to AzCopy, see [Authorize AzCopy](storage-use-azcopy-v10.md#authorize-azcopy).

## Verify role assignments

The appropriate Azure role must be assigned to your user identity. Role assignments can take up to five minutes to propagate. Use the following table as a guide.

| Task | Azure Storage service | Azure role |
|---|---|---|
| Upload data | Azure Blob Storage<sup>1</sup> | [Storage Blob Data Contributor](../../role-based-access-control/built-in-roles.md#storage-blob-data-contributor)<br>[Storage Blob Data Owner](../../role-based-access-control/built-in-roles.md#storage-blob-data-owner) | 
| Upload data | Azure Files | [Storage File Data Privileged Reader](../../role-based-access-control/built-in-roles.md#storage-file-data-privileged-reader) |
| Download data | Azure Blob Storage<sup>1</sup> | [Storage Blob Data Reader](../../role-based-access-control/built-in-roles.md#storage-blob-data-reader) |
| Download Data | Azure Files | [Storage File Data Privileged Reader](../../role-based-access-control/built-in-roles.md#storage-file-data-privileged-reader) |

<sup>1</sup>   You don't need to have one of these roles assigned to your user identity if your user identity is added to the access control list (ACL) of the target container or directory. In the ACL, your user identity needs write permission on the target directory, and execute permission on container and each parent directory. To learn more, see [Access control model in Azure Data Lake Storage](../blobs/data-lake-storage-access-control-model.md).

To learn how to verify and assign roles, see [Assign an Azure role for access to blob data](../blobs/assign-azure-role-data-access.md).
To learn how to verify and assign roles, see [Choose how to authorize access to file data in the Azure portal](../files/authorize-data-operations-portal.md).

## Authorize with environment variables

To authorize access, you'll set in-memory environment variables. Then run any AzCopy command. AzCopy will retrieve the Auth token required to complete the operation. After the operation completes, the token disappears from memory. AzCopy retrieves the OAuth token by using the credentials that you provide. 

After you've verified that your user identity has been given the necessary authorization level, type the following command, and then press the ENTER key.

```bash
export AZCOPY_AUTO_LOGIN_TYPE=DEVICE
```
Then, run any azcopy command (For example: `azcopy list https://contoso.blob.core.windows.net`).

This command returns an authentication code and the URL of a website. Open the website, provide the code, and then choose the **Next** button.

![Create a container](media/storage-use-azcopy-v10/azcopy-login.png)

A sign-in window will appear. In that window, sign into your Azure account by using your Azure account credentials. After you've successfully signed in, the operation can complete.

## Authorize with the AzCopy login command

As an alternative to using in-memory variables, you authorize access by using the azcopy login command.

The azcopy login command retrieves an OAuth token and then places that token into a secret store on your system. If your operating system doesn't have a secret store such as a Linux keyring, the azcopy login command won't work because there is nowhere to place the token.

After you've verified that your user identity has been given the necessary authorization level, open a command prompt, type the following command, and then press the ENTER key.

```azcopy
azcopy login
```

If you receive an error, try including the tenant ID of the organization to which the storage account belongs.

```azcopy
azcopy login --tenant-id=<tenant-id>
```

Replace the `<tenant-id>` placeholder with the tenant ID of the organization to which the storage account belongs. To find the tenant ID, select **Tenant properties > Tenant ID** in the Azure portal.

This command returns an authentication code and the URL of a website. Open the website, provide the code, and then choose the **Next** button.

![Create a container](media/storage-use-azcopy-v10/azcopy-login.png)

A sign-in window will appear. In that window, sign into your Azure account by using your Azure account credentials. After you've successfully signed in, you can close the browser window and begin using AzCopy.

## Authorize with Azure CLI

If you sign in by using Azure CLI, then Azure CLI obtains an OAuth token that AzCopy can use to authorize operations. 

To enable AzCopy to use that token, type the following command, and then press the ENTER key.

```bash
export AZCOPY_AUTO_LOGIN_TYPE=AZCLI
export AZCOPY_TENANT_ID=<tenant-id>
```

For more information about how to sign in with the Azure CLI, see [Sign in with Azure CLI](/cli/azure/authenticate-azure-cli).

## Authorize with Azure PowerShell

If you sign in by using Azure PowerShell, then Azure PowerShell obtains an OAuth token that AzCopy can use to authorize operations.  

To enable AzCopy to use that token, type the following command, and then press the ENTER key.

```PowerShell
$Env:AZCOPY_AUTO_LOGIN_TYPE="PSCRED"
```

For more information about how to sign in with the Azure PowerShell, see [Sign in with Azure PowerShell](/powershell/azure/authenticate-azureps).

## Next steps

- For more information about AzCopy, [Get started with AzCopy](storage-use-azcopy-v10.md)

- If you have questions, issues, or general feedback, submit them [on GitHub](https://github.com/Azure/azure-storage-azcopy) page.
