---
title: Authorize access for AzCopy with a service principal
description: You can provide authorization credentials for AzCopy operations by using a service principal.
author: normesta
ms.service: azure-storage
ms.topic: how-to
ms.date: 02/26/2025
ms.author: normesta
ms.subservice: storage-common-concepts
ms.custom: devx-track-azurecli, devx-track-azurepowershell
# Customer intent: "As a cloud administrator, I want to authorize access for AzCopy operations using Microsoft Entra ID, so that I can streamline file uploads and downloads without the need for SAS tokens, enhancing security and ease of management."
---

# Authorize access for AzCopy with a service principal

You can provide AzCopy with authorization credentials by using service principal.

For more information about AzCopy, [Get started with AzCopy](storage-use-azcopy-v10.md).

## Verify role assignments

The level of authorization that you need is based on whether you plan to upload files or just download them.

If you just want to download files, then verify that the [Storage Blob Data Reader](../../role-based-access-control/built-in-roles.md#storage-blob-data-reader) role (Azure Blob Storage) or the [Storage File Data Privileged Reader](../../role-based-access-control/built-in-roles.md#storage-file-data-privileged-reader) role (Azure Files) has been assigned to your user identity, managed identity, or service principal.

If you want to upload files to Azure Blob Storage, then verify that one of these roles has been assigned to your security principal.

- [Storage Blob Data Contributor](../../role-based-access-control/built-in-roles.md#storage-blob-data-contributor)
- [Storage Blob Data Owner](../../role-based-access-control/built-in-roles.md#storage-blob-data-owner)

If you want to upload files to an Azure file share, then verify that the [Storage File Data Privileged Reader](../../role-based-access-control/built-in-roles.md#storage-file-data-privileged-reader) has been assigned to your security principal.

These roles can be assigned to your security principal in any of these scopes:

- Container (file system) or file share
- Storage account
- Resource group
- Subscription

To learn how to verify and assign roles, see [Assign an Azure role for access to blob data](../blobs/assign-azure-role-data-access.md) (Blob Storage) or [Choose how to authorize access to file data in the Azure portal](../files/authorize-data-operations-portal.md) (Azure Files).

> [!NOTE]
> Keep in mind that Azure role assignments can take up to five minutes to propagate.

You don't need to have one of these roles assigned to your security principal if your security principal is added to the access control list (ACL) of the target container or directory. In the ACL, your security principal needs write permission on the target directory, and execute permission on container and each parent directory.

To learn more, see [Access control model in Azure Data Lake Storage](../blobs/data-lake-storage-access-control-model.md).

## Authorize with AzCopy

To authorize access, you'll set in-memory environment variables. Then run any AzCopy command. AzCopy will retrieve the Auth token required to complete the operation. After the operation completes, the token disappears from memory.

AzCopy retrieves the OAuth token by using the credentials that you provide. Alternatively, AzCopy can use the OAuth token of an active Azure CLI or Azure PowerShell session.

This is a great option if you plan to use AzCopy inside of a script that runs without user interaction, particularly when running on-premises. If you plan to run AzCopy on VMs that run in Azure, a managed service identity is easier to administer. To learn more, see the [Authorize a managed identity](#authorize-a-managed-identity) section of this article.

> [!CAUTION]
> Microsoft recommends that you use the most secure authentication flow available. The authentication flow described in this procedure requires a very high degree of trust in the application, and carries risks that are not present in other flows. You should only use this flow when other more secure flows, such as managed identities, aren't viable.

You can sign into your account by using a client secret or by using the password of a certificate that is associated with your service principal's app registration.

To learn more about creating service principal, see [How to: Use the portal to create a Microsoft Entra application and service principal that can access resources](../../active-directory/develop/howto-create-service-principal-portal.md).

To learn more about service principals in general, see [Application and service principal objects in Microsoft Entra ID](../../active-directory/develop/app-objects-and-service-principals.md)

##### Authorize a service principal by using a client secret

Type the following command, and then press the ENTER key.

```bash
export AZCOPY_AUTO_LOGIN_TYPE=SPN
export AZCOPY_SPA_APPLICATION_ID=<application-id>
export AZCOPY_SPA_CLIENT_SECRET=<client-secret>
export AZCOPY_TENANT_ID=<tenant-id>
```

Replace the `<application-id>` placeholder with the application ID of your service principal's app registration. Replace the `<client-secret>` placeholder with the client secret. Replace the `<tenant-id>` placeholder with the tenant ID of the organization to which the storage account belongs. To find the tenant ID, select **Tenant properties > Tenant ID** in the Azure portal.

> [!NOTE]
> Consider using a prompt to collect the password from the user. That way, your password won't appear in your command history.

Then, run any azcopy command (For example: `azcopy list https://contoso.blob.core.windows.net`).

##### Authorize a service principal by using a certificate

If you prefer to use your own credentials for authorization, you can upload a certificate to your app registration, and then use that certificate to log in.

In addition to uploading your certificate to your app registration, you'll also need to have a copy of the certificate saved to the machine or VM where AzCopy will be running. This copy of the certificate should be in .PFX or .PEM format, and must include the private key. The private key should be password-protected. If you're using Windows, and your certificate exists only in a certificate store, make sure to export that certificate to a PFX file (including the private key). For guidance, see [Export-PfxCertificate](/powershell/module/pki/export-pfxcertificate)

Type the following command, and then press the ENTER key.

```bash
export AZCOPY_AUTO_LOGIN_TYPE=SPN
export AZCOPY_SPA_APPLICATION_ID=<application-id>
export AZCOPY_SPA_CERT_PATH=<path-to-certificate-file>
export AZCOPY_SPA_CERT_PASSWORD=<certificate-password>
export AZCOPY_TENANT_ID=<tenant-id>
```

Replace the `<application-id>` placeholder with the application ID of your service principal's app registration. Replace the `<path-to-certificate-file>` placeholder with the relative or fully qualified path to the certificate file. AzCopy saves the path to this certificate but it doesn't save a copy of the certificate, so make sure to keep that certificate in place. Replace the `<certificate-password>` placeholder with the password of the certificate. Replace the `<tenant-id>` placeholder with the tenant ID of the organization to which the storage account belongs. To find the tenant ID, select **Tenant properties > Tenant ID** in the Azure portal.

> [!NOTE]
> Consider using a prompt to collect the password from the user. That way, your password won't appear in your command history.

Then, run any azcopy command (For example: `azcopy list https://contoso.blob.core.windows.net`).

## Authorize by using the AzCopy login command

As an alternative to using in-memory variables, you authorize access by using the azcopy login command.

The azcopy login command retrieves an OAuth token and then places that token into a secret store on your system. If your operating system doesn't have a secret store such as a Linux keyring, the azcopy login command won't work because there is nowhere to place the token.

### Authorize a service principal

Before you run a script, you have to sign in interactively at least one time so that you can provide AzCopy with the credentials of your service principal.  Those credentials are stored in a secured and encrypted file so that your script doesn't have to provide that sensitive information.

You can sign into your account by using a client secret or by using the password of a certificate that is associated with your service principal's app registration.

To learn more about creating service principal, see [How to: Use the portal to create a Microsoft Entra application and service principal that can access resources](../../active-directory/develop/howto-create-service-principal-portal.md).

> [!CAUTION]
> Microsoft recommends that you use the most secure authentication flow available. The authentication flow described in this procedure requires a very high degree of trust in the application, and carries risks that are not present in other flows. You should only use this flow when other more secure flows, such as managed identities, aren't viable.

#### Authorize a service principal by using a client secret

Start by setting the `AZCOPY_SPA_CLIENT_SECRET` environment variable to the client secret of your service principal's app registration.

> [!NOTE]
> Make sure to set this value from your command prompt, and not in the environment variable settings of your operating system. That way, the value is available only to the current session.

This example shows how you could do this in PowerShell.

```azcopy
$env:AZCOPY_SPA_CLIENT_SECRET="$(Read-Host -prompt "Enter key")"
```

> [!NOTE]
> Consider using a prompt as shown in this example. That way, your password won't appear in your console's command history.

Next, type the following command, and then press the ENTER key.

```azcopy
azcopy login --service-principal  --application-id application-id --tenant-id=tenant-id
```

Replace the `<application-id>` placeholder with the application ID of your service principal's app registration. Replace the `<tenant-id>` placeholder with the tenant ID of the organization to which the storage account belongs. To find the tenant ID, select **Tenant properties > Tenant ID** in the Azure portal.

#### Authorize a service principal by using a certificate

If you prefer to use your own credentials for authorization, you can upload a certificate to your app registration, and then use that certificate to log in.

In addition to uploading your certificate to your app registration, you'll also need to have a copy of the certificate saved to the machine or VM where AzCopy will be running. This copy of the certificate should be in .PFX or .PEM format, and must include the private key. The private key should be password-protected. If you're using Windows, and your certificate exists only in a certificate store, make sure to export that certificate to a PFX file (including the private key). For guidance, see [Export-PfxCertificate](/powershell/module/pki/export-pfxcertificate)

Next, set the `AZCOPY_SPA_CERT_PASSWORD` environment variable to the certificate password.

> [!NOTE]
> Make sure to set this value from your command prompt, and not in the environment variable settings of your operating system. That way, the value is available only to the current session.

This example shows how you could do this task in PowerShell.

```azcopy
$env:AZCOPY_SPA_CERT_PASSWORD="$(Read-Host -prompt "Enter key")"
```

Next, type the following command, and then press the ENTER key.

```azcopy
azcopy login --service-principal --application-id application-id --certificate-path <path-to-certificate-file> --tenant-id=<tenant-id>
```

Replace the `<application-id>` placeholder with the application ID of your service principal's app registration. Replace the `<path-to-certificate-file>` placeholder with the relative or fully qualified path to the certificate file. AzCopy saves the path to this certificate but it doesn't save a copy of the certificate, so make sure to keep that certificate in place. Replace the `<tenant-id>` placeholder with the tenant ID of the organization to which the storage account belongs. To find the tenant ID, select **Tenant properties > Tenant ID** in the Azure portal.

> [!NOTE]
> Consider using a prompt as shown in this example. That way, your password won't appear in your console's command history.

## Next steps

- For more information about AzCopy, [Get started with AzCopy](storage-use-azcopy-v10.md)

- If you have questions, issues, or general feedback, submit them [on GitHub](https://github.com/Azure/azure-storage-azcopy) page.
