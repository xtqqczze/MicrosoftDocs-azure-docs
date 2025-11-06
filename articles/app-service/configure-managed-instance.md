---
title: Configure Managed Instance on Azure App Service (preview)
description: Learn how to configure and deploy a Managed Instance on Azure App Service using Azure CLI and ARM templates. This guide covers general settings, storage mounts, registry keys, and Bastion/RDP access.
keywords: app service, azure app service, scale, scalable, scalability, app service plan, app service cost, managed instance, azure cli, arm templates, windows server, configuration script, bastion access, rdp, custom tooling
ms.topic: how-to
ms.date: 11/05/2025
ms.author: msangapu
author: msangapu-msft
ms.service: azure-app-service
---

# Configure Managed Instance on Azure App Service (preview)

This article explains how to configure a Managed Instance on Azure App Service and covers several key configuration areas:

- Managed identity
- Configuration scripts
- Storage mounts
- Registry keys
- Bastion/RDP access

> [!IMPORTANT]
> Managed Instance is in preview.

## Managed identity

Managed identities on Managed Instance are integrated with the App Service plan (and not the app). Customers can also have managed identities at the app level 

**mangesh to update this**

app: key vault references for env variables, talk to other services (azure sql) link to mi doc for app service?

Managed identities are required in the following scenarios:

- To securely access and retrieve your configuration script from Azure Storage.
- Access Key Vault(s) to supply credentials and values for Storage Mounts and Registry Key Adapters.
 
See [manage user-assigned managed identities](https://learn.microsoft.com/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal#create-a-user-assigned-managed-identity) to create a managed identity.

## Configuration scripts

Configuration scripts run at instance startup to apply persistent customization (COM registration, MSI installs, IIS config, ACL changes, enabling Windows Features, setting environment variables).

### Requirements

The following are required to use configuration scripts:


1. User-assigned managed identity or system-assigned is turned on for the App Service plan. Identity will be used to access the zip file (and script) in Storage.

2. A Storage account with a Blob container holding the script package (zip). The managed identity is assigned the Storage Blob Data Reader role at the account, container, or resource group scope.

3. A single zip file whose root contains `Install.ps1` (entry point).

Example minimal zip structure:

```
Install.ps1
MyComponent.msi
config.xml
```

To verify the Managed Instance plan has a managed identity:
1. Go to your Managed Instance in the Azure portal.
1. Select **Identity** > **User assigned**.
1. Verify a managed identity has been added.

To add a configuration script:

1. Go to your Managed Instance App Service plan in the Azure portal.
1. Select **Configuration** > **General Settings**.

In the _Configuration script_ section, begin by configuring your script.

| Setting | Value |
|--|--|
| Storage Account | Select your storage account |
| Container | Enter the name of your container |
| Zip file | Enter the name of the zip file |
| Value | Verify this is correct |

3. Select Apply to save the changes.

### Configuration script best practices

- Make scripts idempotent (check before install).
- Guard destructive operations (avoid modifying protected Windows system directories).
- Stagger heavy installations to reduce startup latency.

### Example component script

```powershell

# Install Components, for example Crystal Reports, Control Library, Database Driver
$ComponentInstaller = "myInstallerFileNameGoesHere.msi"
try {
    $Component = Join-Path $PSScriptRoot $ComponentInstaller
    Start-Process $Component -ArgumentList "/q" -Wait -ErrorAction Stop
} catch {
    Write-Error "Failed to install ${ComponentInstaller}: $_"
    exit 1
}
```

## Configure storage mounts

Storage mounts provide persistent external storage (for example Azure Files) accessible to your app. Use for legacy code needing shared filesystem access, not for secrets (use Key Vault).

### Requirements
1. Managed identity (for Key Vault access)  
2. Key Vault secret (credential source)  



To configure storage mounts:

1. Go to your Managed Instance in the Azure portal.
2. Select **Configuration** > **Mounts**.
1. Select **+ New storage mount**.


Provide the following details to configure the storage mount:

| Setting | Value |
|--|--|
| Name | Enter a mount mame |
| Storage type | Azure files, Custom, or Local (temporary storage)|
| Storage account | Select or enter a storage account |
| File share| Seleft a file share|
| Value | Select a Key vault |
| Secret | Select the key vault secret |
| Mount drive letter | Select drive letter path |

You can mount external storage (for example, Azure Files or NFS) to your Managed Instance. Mounted storage is persistent across restarts and accessible from your app’s file system.

### Types of storage mounts

Three storage mount types are supported:

- Azure Files - Connect your apps to an Azure Storage File Share
- Custom - Connect your apps to any UNC file path within your virtual network
- Local - Make use of temporary storage volume on the underlying worker instance

> Do not store secrets directly on mounts. Use [Azure Key Vault](https://learn.microsoft.com/azure/key-vault/general/overview) for secrets, then reference those secrets when configuring mount credentials.

#### Azure Files

To configure an Azure Files storage mount:

1. Create an Azure Storage Account and an Azure Files share.
2. Store a connection credential in Key Vault as a secret.  
   Supported secret contents:
   - Full connection string (Ex: `DefaultEndpointsProtocol=...;AccountName=...;AccountKey=...;EndpointSuffix=core.windows.net`)
   - (If supported) SAS token or account key (choose the format your platform expects).
3. Add the mount in Managed Instance (Azure portal or ARM/Bicep/Terraform).

Tips:
- Use least privilege: consider a SAS scoped to the file share instead of full account key.
- For Linux workers (if/when supported), destination may be a path like `/mnt/azurefiles`.
- Enforce share-level permissions via Azure RBAC + share ACLs for enhanced security.

#### Custom (UNC path)

Use this for SMB shares hosted elsewhere (on-premises, VM, or third-party). Ensure network connectivity (VNet integration / private endpoints / firewalls).

1. If credentials are needed, store them in a Key Vault secret in the format: `username=<user>,password=<password>`
   - Avoid domain admin accounts; use a least‑privilege service identity.
2. Add the mount in Managed Instance.

#### Local (temporary storage)

Local mounts map a writable directory/volume on the individual worker instance. Data is lost on:
- Worker restarts
- Platform maintenance
- Scaling operations (you may land on a new instance)

Do not use Local for durable persistence. Prefer Azure Files or Custom for long‑term data.

## Configure registry keys

Some applications depend on values read from the Windows Registry. Using a Registry Key adapter, customers can create registry keys and use secrets from Azure Key Vault as the value.

### Requirements
1. Managed identity (for Key Vault access)  
2. Key Vault secret (credential source)  
 

To configure registry keys:
1. Go to **Configuration** > **Registry Keys**.
1. Select **+ Add**.
1. Select new Azure storage mount.

| Setting | Value |
|--|--|
| Path | Enter the registry path |
| Vault | Enter an existing vault name|
| Secret | Select or enter the key vault secret|
| Type | String or DWORD |

1. Select **Add** to add the registry key.

> [CAUTION]
> Be cautious when modifying system-critical registry paths. Incorrect changes may impact instance stability.
>

## Configure Bastion/RDP access

Bastion and RDP access let you securely connect to your VM instance(s) through remote desktop. RDP via Azure Bastion is for transient diagnostics (log inspection, quick validation).

If you intend to use Bastion via the portal, then upgrade your Bastion resource to standard pricing tier and select "Native Client Support and IP-Based Connection.

Bastion quickstart: https://learn.microsoft.com/en-us/azure/bastion/quickstart-host-portal

The following is required for Bastion/RDP access:

1. Managed Instance must be virtual network (VNet) integrated.
2. Target VNet has (or will have) an Azure Bastion host:

To configure Bastion:

1. Go to **Configuration** > **Bastion/RDP**.
1. Verify the **Virtual Network** is connected.
1. Select **Allow Remote Desktop (via Bastion)**.

> [!CAUTION]
> Don't apply manual installers or configuration changes solely through RDP—they'll be lost on recycle or create configuration drift.

## Frequently Asked Questions (FAQ)

### What OS is running on Managed Instance on Azure App Service workers?

Windows Server 2022.

### Can I enable more Windows Roles and Features?

Yes. You can use a configuration script to enable more Windows Roles and Features. However, if a feature is [removed from a future release of Windows Server](https://learn.microsoft.com/windows-server/get-started/removed-deprecated-features-windows-server?tabs=ws25), it will also be unavailable in Managed Instance.

### Does Managed Instance on Azure App Service receive regular platform and application stack updates?

Yes. Worker instances receive regular platform updates and maintenance. Preinstalled application stacks are also updated regularly. Any more components installed via configuration scripts must be maintained by you.

### Which Application Stacks and versions are installed on Managed Instance on Azure App Service workers?

- Microsoft .NET Framework 3.5 and 4.8.1
- Microsoft .NET 8.0

> If you require other runtimes, you can install them using a configuration script. Note that these will not be maintained by the platform and must be updated manually.

### What limitations are there to the configuration script?

Configuration scripts can install dependencies, enable roles and features, and customize the OS. However, destructive operations (for example, deleting `Windows\System32`) are **not supported** and may result in instance instability.

### Under what permission level is a configuration script executed?

Configuration scripts are executed with **Administrator** permissions to allow installation and configuration of system-level components.

### What role permissions does an operator have when connecting to a worker instance using Bastion?

Operators connecting via Bastion have **Administrator** privileges during the session.

## How do I troubleshoot failures with my installation script or registry/storage adapters

Install script logs can be found on the Managed Instance workers in the directory c:\InstallScripts\Scriptn\Install.log or alternatively if outputting App Service Console Logs to Azure Monitor and Log Analytics, you can query directly.  
Adapter logs can be found in the root of the machine, alternatively they're logged into App Service Platform Logs.

## What is the addressable memory of a Managed Instance on Azure App Service worker instance?

The addressable memory of a Managed Instance on Azure App Service worker instance varies dependent on the SKU chosen.  The table below lists the addressable memory for the Managed Instance on Azure App Service worker instance.  It's important to consider if you have a configuration script which installs more components, services etc., these have an impact of memory available for use by your web applications.

| SKU | Cores | Memory (MB) |
|---|---|---|
| P0v4 | 1 | 2048 |
| P1v4 | 2 | 5952 |
| P2v4 | 4 | 13440 |
| P3v4 | 8 | 28672 |
| P1Mv4 | 2 | 13440 |
| P2Mv4 | 4 | 28672 |
| P3Mv4 | 8 | 60160 |
| P4Mv4 | 16 | 121088 |
| P5Mv4 | 32 | 246016 |

## Which Azure Storage service should I use to upload installation script?

Use Azure Storage blob service for uploading installation script and required dependencies. 

## Is there a restriction on naming and format for the installation script?

Yes. You need to name your installation script as install.ps1. Only PowerShell scripts are supported for installation scripts. Ensure to upload installation script and dependencies as a single Zip file. There is no forced naming format for the Zip file.

## Is there a size limit for the dependencies that I can upload as part of the zip file?

No. Currently no size limit is enforced . Please remember that overall size of the dependencies may impact the time taken to provision an instance for Managed Instance on App Service plan.

## Does adding or editing Managed Instance on App Service plan adapters restart the plan instance(s)?

Yes. Adding or editing Managed Instance on App Service plan adapters (installation script\storage\registry) do restart the underlying instance(s) and may impact all the web apps deployed to the plan. Remember that instance restarts removes all changes made via RDP session. Always use installation script to persist dependencies installation or other configuration changes required.

## My Managed Instance on App Service plan has multiple instances can I restart a single instance?

Yes. Navigate to Instances menu and click restart next to the instance name you want to restart. 

## My Managed Instance on App Service plan has multiple web applications can I restart a single web application?

Yes. Navigate to the overview blade for the desired web application and click restart.

## Can I assign Managed Identity to my web application within the Managed Instance on App Service plan?

Yes. You can assign a different Managed identity to a web application within the Managed Instance on App Service plan . Follow the guidance here https://learn.microsoft.com/en-us/azure/app-service/overview-managed-identity?tabs=portal%2Chttp 

## Is there a limitation on number of adapters that I can create for Managed Instance on App Service plan?

No. There is no upper limit on number of Storage and Registry adapters that you may create for Managed Instance on App Service plan. You can only create a single Installation Script adapter for Managed Instance on App Service plan.  Please remember that number of adapters may impact the time taken to provision an instance for Managed Instance on App Service plan.


## Next steps

- [Overview of Managed Instance on Azure App Service](overview-managed-instance.md)
- [Deploy using Azure CLI](quickstart-managed-instance.md)
