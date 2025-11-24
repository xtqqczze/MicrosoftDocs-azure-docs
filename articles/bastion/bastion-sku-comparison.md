---
title: Choose the Right Azure Bastion SKUs to Meet Your Needs
description: Learn about the different Azure Bastion SKU tiers and choose the right one for your requirements.
author: abell
ms.author: abell
ms.service: azure-bastion
ms.topic: concept-article
ms.date: 11/24/2025
# Customer intent: As a cloud administrator, I want to compare Azure Bastion SKU tiers and understand their features, so that I can select the appropriate tier for my organization's secure remote access requirements.
---

# Choose the Right Azure Bastion SKUs to Meet Your Needs

Azure Bastion offers four SKU tiers: **Developer** (free dev/test), **Basic** (essential production features), **Standard** (advanced features with scaling), and **Premium** (session recording and compliance). Each tier is designed for specific use cases and requirements.

For detailed information about all Azure Bastion features and configuration settings, see [About Bastion configuration settings](configuration-settings.md).

## Feature comparison

Compare the features across all four Azure Bastion SKU tiers:

| Category | Feature | Developer | Basic | Standard | Premium |
| --- | --- | --- | --- | --- | --- |
| **Deployment & Requirements** | Requires AzureBastionSubnet¹ | No | Yes | Yes | Yes² |
|  | Requires Public IP address¹ | No | Yes | Yes | Yes² |
|  | Dedicated bastion host | No³ | Yes | Yes | Yes |
|  | Availability zones | No | Yes | Yes | Yes |
|  | Virtual network peering support | No | Yes | Yes | Yes |
| **VM Connectivity** | Connect to VMs in same virtual network | Yes | Yes | Yes | Yes |
|  | Connect to VMs in peered virtual networks | No | Yes | Yes | Yes |
|  | Support for concurrent connections | No³ | Yes | Yes | Yes |
|  | Connect to Linux VM using SSH | Yes | Yes | Yes | Yes |
|  | Connect to Windows VM using RDP | Yes | Yes | Yes | Yes |
|  | Connect to Linux VM using RDP | No | No | Yes | Yes |
|  | Connect to Windows VM using SSH | No | No | Yes | Yes |
| **Authentication & Security** | Access Linux VM Private Keys in Azure Key Vault | Yes | Yes | Yes | Yes |
|  | Kerberos authentication | Yes | Yes | Yes | Yes |
|  | Session recording | No | No | No | Yes |
|  | Private-only deployment (no public IP) | No | No | No | Yes |
| **Connection Methods & Protocols** | Browser-based connection (Azure portal) | Yes | Yes | Yes | Yes |
|  | Connect to VMs using Azure CLI (native client) | No | No | Yes | Yes |
|  | Specify custom inbound port | No | No | Yes | Yes |
|  | Connect to VMs via IP address | No | No | Yes | Yes |
|  | Shareable link | No | No | Yes | Yes |
|  | Upload or download files | No | No | Yes | Yes |
| **Performance & Scalability** | Host scaling | No | No | Yes (2-50 instances) | Yes (2-50 instances) |
|  | Fixed instance count | 1 VM at a time³ | 2 instances | Configurable | Configurable |
|  | Maximum concurrent RDP sessions⁴ | 1 | 40 | 1,000 | 1,000 |
|  | Maximum concurrent SSH sessions⁴ | 1 | 80 | 2,000 | 2,000 |
| **User Experience** | VM audio output | Yes | Yes | Yes | Yes |
|  | Copy/paste (web-based clients) | Yes | Yes | Yes | Yes |
|  | Disable copy/paste (web-based clients) | No | No | Yes | Yes |
| **Cost** | Hourly charge | Free | Paid | Paid | Paid |
|  | Outbound data transfer charges | Free | Paid⁵ | Paid⁵ | Paid⁵ |

¹ For dedicated deployments (Basic, Standard, Premium), the AzureBastionSubnet must be /26 or larger (/25, /24, etc.). For more information, see [Azure Bastion subnet](configuration-settings.md#subnet).  
² Private-only deployment option doesn't require public IP or AzureBastionSubnet. For more information, see [Private-only deployment](private-only-deployment.md).  
³ Bastion Developer uses a shared resource and supports one VM connection at a time.  
⁴ At maximum scale (50 instances). For more information, see [Instances and host scaling](configuration-settings.md#instance).  
⁵ First 5 GB per month is free. For more information, see [Azure Bastion pricing](https://azure.microsoft.com/pricing/details/azure-bastion/).

## Performance and scalability

Understand the capacity and scaling characteristics of each SKU tier:

| Metric | Developer | Basic | Standard | Premium |
|--------|-----------|-------|----------|---------|
| **Deployment model** | Shared resource | Dedicated host | Dedicated host | Dedicated host |
| **Instance count** | N/A (shared) | 2 (fixed) | 2-50 (configurable) | 2-50 (configurable) |
| **Concurrent VM connections** | 1 VM at a time | Multiple VMs | Multiple VMs | Multiple VMs |
| **Max concurrent RDP sessions** | 1 | 40 (2 instances × 20) | 1,000 (50 instances × 20) | 1,000 (50 instances × 20) |
| **Max concurrent SSH sessions** | 1 | 80 (2 instances × 40) | 2,000 (50 instances × 40) | 2,000 (50 instances × 40) |
| **Per instance capacity** | N/A | 20 RDP + 40 SSH | 20 RDP + 40 SSH | 20 RDP + 40 SSH |

## Regional availability

Azure Bastion SKU availability varies by region:

- **Developer SKU**: Available in select regions. For the current list of supported regions, see [Connect with Azure Bastion Developer](quickstart-developer.md).
- **Basic, Standard, Premium SKUs**: Available in all Azure regions where Azure Bastion is supported.

## Decision framework

Use the following guidance to select the appropriate Azure Bastion SKU for your requirements.

### Developer SKU

Developer SKU is ideal for development and test environments where cost is the primary concern. Choose Developer SKU when:

- You're working exclusively in dev/test environments
- You want to minimize costs (completely free)
- You don't require virtual network peering or concurrent connections
- You're operating in a [supported region](quickstart-developer.md)

> [!WARNING]
> Developer SKU isn't suitable for production workloads. It provides access to only one VM at a time and doesn't support virtual network peering.

### Basic SKU

Basic SKU provides cost-effective dedicated deployment for production environments that require essential features. Choose Basic SKU when:

- You need dedicated production deployment with essential features
- Fixed capacity of two instances (40 RDP/80 SSH sessions) is sufficient
- You don't need advanced features (native client, shareable links, IP-based connections, custom ports, file transfer)
- You're working in a cost-conscious production environment

### Standard SKU

Standard SKU offers comprehensive remote access capabilities with advanced features and scalability. Choose Standard SKU when:

- You need advanced features (native client, shareable links, IP-based connections, custom ports, file transfer)
- You require host scaling (2-50 instances) for variable demand
- You need high concurrency (up to 1,000 RDP or 2,000 SSH sessions at max scale)

### Premium SKU

Premium SKU is recommended for production deployments requiring advanced security, compliance features, or future-proofing. Choose Premium SKU when:

- You require session recording for compliance or audit requirements
- You need private-only deployment (no public IP address)
- You want to future-proof your deployment for upcoming features
- Compliance requirements mandate session audit trails
- You need all Standard features plus advanced security and compliance capabilities

> [!TIP]
> The cost difference between Standard and Premium is marginal. Premium SKU is the recommended choice for production deployments.

## Upgrade considerations

Azure Bastion supports upgrading from lower SKUs to higher SKUs, but downgrading isn't supported.

### Upgrade paths

- **Developer to Basic/Standard/Premium**: Requires creating an AzureBastionSubnet (/26 or larger) and a public IP address (Standard SKU, Static allocation). See [Upgrade from Bastion Developer](upgrade-sku.md#upgrade-from-bastion-developer).
- **Basic to Standard**: Straightforward upgrade through the Azure portal. You can add features at the same time you upgrade. See [Upgrade from Basic or Standard SKU](upgrade-sku.md#upgrade-from-the-basic-or-standard-sku).
- **Standard to Premium**: Straightforward upgrade through the Azure portal. You can add features at the same time you upgrade.

> [!IMPORTANT]
> Upgrades take approximately 10 minutes. Downgrading a SKU isn't supported. You must delete and recreate Azure Bastion. You can add features during the upgrade process.

For step-by-step upgrade instructions, see [View or upgrade a SKU](upgrade-sku.md).

## Pricing model

Azure Bastion pricing combines hourly SKU charges with outbound data transfer costs. Developer SKU is free. For dedicated SKUs (Basic, Standard, Premium), you pay hourly rates plus data transfer charges (first 5 GB/month free). Additional instances for host scaling have lower incremental rates.

For detailed pricing information and cost optimization strategies, see [Azure Bastion pricing](https://azure.microsoft.com/pricing/details/azure-bastion/) and [Azure Bastion cost optimization principles](cost-optimization.md).

## Next steps

- [Connect with Azure Bastion Developer](quickstart-developer.md)
- [Deploy Bastion with default settings (Standard SKU)](quickstart-host-portal.md)
- [Deploy Bastion using specified settings (Basic SKU or higher)](tutorial-create-host-portal.md)
- [About Bastion configuration settings](configuration-settings.md)
- [View or upgrade a SKU](upgrade-sku.md)
- [Configure host scaling](configure-host-scaling.md)
- [Configure session recording](session-recording.md)
- [Deploy private-only Bastion](private-only-deployment.md)
- [Azure Bastion pricing](https://azure.microsoft.com/pricing/details/azure-bastion/)
