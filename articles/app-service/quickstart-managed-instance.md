---
title: Create Managed Instance on Azure App Service (preview) using ARM
description: Learn how to configure Managed Instance on Azure App Service
keywords: app service, azure app service, scale, scalable, scalability, app service plan, app service cost
ms.topic: quickstart
ms.date: 11/052025
ms.author: msangapu
author: msangapu-msft
ms.service: azure-app-service
---

# Deploy Managed Instance on Azure App Service (preview)

> [!IMPORTANT]
> Managed Instance is in public preview, limited to select regions and the **PV4** / **PMV4** SKUs. Linux and containers are not supported. Validate functionality before production use.

Managed Instance on Azure App Service combines the simplicity of platform-as-a-service with the flexibility of infrastructure-level control. It is designed for applications that require deep isolation, advanced customization, and secure network integration.

In this quickstart you will:
1. Create a Managed Instance plan (preview) with install scripts.
1. Deploy a sample web app to the plan.
1. Verify the deployment.

## Prerequisites

* **Azure account**: You need an Azure account with an active subscription. If you don't already have one, you can [create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

* **Access to the approved regions**: During the preview, the only allowed regions for Managed Instance are the *East Asia*, *East US*, *North Europe*, and *West Central US* regions.

* **Azure CLI 2.79.0 or later**. See [Install Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli).

## Create a Managed Instance plan

Start by creating the Managed Instance plan.

1. Sign in to the [Azure portal](https://portal.azure.com).
1. Select **+ Create a resource**.
1. Search for **managed instance**
1. Select **Web App (for Managed Instance) (preview)** in the results.
1. Select **Create** to start the create process.

### Complete Basics tab

On the Basic tab, provide the following details.

#### Project details

| Setting | Value |
|-------|----------|
| Subscription | Your Azure subscription |
| Resource Group | **Create new > mi-rg** |


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
| Pricing plans* | Select a pricing plan. |

<sup>*</sup>If the Pv4 / Pmv4 SKU isn't visible in _pricing plans_, confirm region availability or request more quota.

### Complete Advanced tab

On the Advanced tab, provide the following details.

#### Configuration script
| Setting | Value |
|-------|----------|
| Storage Account | Use default plan or create new (for example, 'contoso-mi-plan')|
| Container | Select a pricing plan |
| Zip file | Select a pricing plan |
| Value | Verify this is correct |
| Identity | Select your managed identity |

1. Select **Review + create**

## Review + Create

1. Validate summary shows:
   - Windows runtime
   - Pv4 or Pmv4 Managed Instance SKU
   - System-assigned identity (if enabled)
   - Any optional scripts/registry entries
2. Select Create.

Deployment typically takes several minutes while the plan and networking are provisioned.


## Troubleshooting quick notes

| Issue | Action |
|-------|--------|
| Plan creation fails | Confirm Pv4/Pmv4 quota and region support. |
| Subnet error/delegation failure | Ensure empty subnet and correct delegation (Microsoft.Web/serverFarms). |
| Script not executing | Verify Storage URI validity and managed identity access. |
| Key Vault secret not resolving | Check identity permissions and correct SecretUri syntax. |
| RDP option missing | Bastion not provisioned or feature disabled in this preview ring. |


## Next steps

- [App Service overview](overview.md)
- [Managed Instance Quickstart](quickstart-managed-instance.md)
- [Security in App Service](overview-security.md)
- [App Service Environment comparison](./environment/overview.md)