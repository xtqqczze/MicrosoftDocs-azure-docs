---
title: Overview of assessments for Arc-enabled resources (Preview)
description: Learn how Azure Migrate assessments and business case work with Arc-enabled resources for migration planning to Azure.
author: snehithm
ms.author: snehithm
ms.service: azure-migrate
ms.topic: concept-article
ms.date: 10/23/2025
ms.custom: engagement-fy25
---

# Overview of assessments for Arc-enabled resources (Preview)

This article provides an overview of how Azure Migrate works with [Azure Arc-enabled servers](../azure-arc/servers/overview.md) and [Azure Arc-enabled SQL Server](../azure-arc/data/overview.md) to assess your on-premises resources for migration to Azure.

If you have already Arc-enabled your on-premises servers and SQL Server instances, Azure Migrate can use this existing infrastructure to discover, assess, and build a business case for migration without requiring any additional on-premises deployments.

> [!IMPORTANT]
> This feature is currently in preview. As an 'Early Access Preview' feature, the capabilities presented in this article are subject to [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## What is Arc-based discovery?

Arc-based discovery is a discovery method in Azure Migrate that leverages your existing Azure Arc infrastructure to automatically discover and assess Arc-enabled resources for migration to Azure. Unlike appliance-based discovery, Arc-based discovery requires no additional on-premises deployments and uses native integration between Azure Migrate and Azure Arc.

### Key benefits

- **No additional on-premises infrastructure**: Uses your existing Arc-enabled servers and SQL Server instances.
- **Fast time to insights**: Default business cases and assessments are automatically generated when you create a project, typically within an hour.
- **Subscription-based scoping**: Select one or more subscriptions containing Arc resources to include in your project.
- **Simplified management**: Manage scope, sync data, and view inventory directly from Azure Arc Center.
- **Optional performance data collection**: Install the Azure Migrate Collector VM extension to collect performance history for right-sized assessments.

## Supported Arc resource types

Azure Migrate supports discovery and assessment of the following Arc-enabled resource types:

| Resource Type | Assessment Support | Details |
|---------------|-------------------|---------|
| **Arc-enabled servers** | ✅ Supported | Windows and Linux servers running Arc connected machine agent version 1.46 or higher |
| **Arc-enabled SQL Server** | ✅ Supported | SQL Server instances managed by Azure Arc |

## How Arc-based discovery works

### Discovery process

1. **Create an Azure Migrate project**: Create a project from Azure Arc Center and select subscriptions containing Arc resources.

2. **Automatic data sync**: Azure Migrate automatically syncs metadata from your Arc-enabled resources in the selected subscriptions. This includes:
   - Server configuration (CPU, memory, disk, network)
   - Operating system information
   - SQL Server instance and database information
   - Current location and settings

3. **Default artifacts generation**: After sync completes, Azure Migrate automatically generates:
   - Two default business cases (modernize strategy and faster migration strategy)
   - One default assessment covering all workloads (servers and SQL Servers)

4. **Optional performance collection**: Install the Azure Migrate Collector VM extension on Arc-enabled servers to collect:
   - CPU and memory utilization over time
   - Disk IOPS and throughput
   - Network utilization

### Data synchronization

The Azure Migrate project stores metadata about your Arc resources in the region you select during project creation, regardless of where the Arc-enabled servers are located. This metadata includes:

- Server inventory (name, operating system, hardware configuration)
- SQL Server instances and databases
- Arc agent version and status

To keep data current, you can manually trigger a sync at any time from the Azure Arc Center. This is useful when:
- New Arc-enabled servers are added to subscriptions in scope
- Servers are removed from the environment
- Configuration changes occur

## Project scope management

Unlike appliance-based projects that discover resources in a specific datacenter, Arc-based projects are scoped by Azure subscriptions. When creating a project:

- Select one or more subscriptions containing Arc resources
- Only Arc-enabled resources with agent version 1.46 or higher are included
- Resources must have the Microsoft.OffAzure resource provider registered

You can edit the scope at any time to add or remove subscriptions. Ensure you have the following permissions on subscriptions you want to include:
- `Microsoft.HybridCompute/Machines/read`
- `Microsoft.AzureArcData/SqlInstances/read`

## Assessment types

Arc-based discovery supports the same assessment types as other discovery methods:

### Application assessments
Assess multiple workload types together (servers and SQL Servers) as part of a single application. This provides a holistic view of migration readiness and costs.

### Workload-specific assessments
Create separate assessments for:
- **Azure VM assessments**: For Arc-enabled servers
- **Azure SQL assessments**: For Arc-enabled SQL Server instances

All assessments evaluate:
- **Migration readiness**: Whether resources are suitable for migration to Azure
- **Right-sized targets**: Recommended Azure SKUs based on configuration and optionally performance data
- **Cost estimates**: Monthly Azure resource costs in the target region

## Business case

When you create an Azure Migrate project with Arc resources, two default business cases are automatically generated:

### Default business cases

1. **Modernize strategy** (`default-modernize`): Evaluates migration using Platform-as-a-Service (PaaS) options where possible, such as:
   - Azure SQL Database or Azure SQL Managed Instance for SQL workloads
   - Azure App Service for web applications
   - Azure VMs when PaaS isn't suitable

2. **Faster migration to Azure** (`default-faster-mgn-az-vm`): Evaluates Infrastructure-as-a-Service (IaaS) lift-and-shift migration to Azure VMs for all workloads.

Both business cases calculate:
- Estimated cost savings compared to on-premises
- Total cost of ownership (TCO) in Azure
- Return on investment (ROI) timeline

You can create custom business cases with different settings or scoped to specific resources. For more information, see [Build a business case](how-to-build-a-business-case.md).

## Performance-based vs. as-on-premises sizing

Arc-based discovery supports two sizing approaches:

### As-on-premises sizing (default)
- Recommendations are based on current on-premises server configuration
- No performance data collection required
- Assumes peak capacity utilization
- May result in larger Azure SKUs than necessary

### Performance-based sizing (requires VM extension)
- Recommendations are based on actual resource utilization over time
- Requires Azure Migrate Collector VM extension installation
- Uses performance history to determine optimal SKUs
- Typically results in cost savings through right-sizing

To enable performance-based sizing:
1. Install the Azure Migrate Collector VM extension on Arc-enabled servers
2. Wait for performance data collection (recommended: at least one week)
3. Create or recalculate assessments with performance-based sizing

Learn more about [installing the Azure Migrate Collector VM extension](how-to-install-arc-collector-extension.md).

## Azure Migrate Collector VM extension

The Azure Migrate Collector VM extension is an optional component that provides enhanced assessment capabilities:

### What it collects
- CPU utilization percentages over time
- Memory utilization percentages over time  
- Disk IOPS (read and write operations)
- Disk throughput (MB/s read and write)
- Network utilization

### Installation options
- **Single server**: Use Azure CLI commands for Windows or Linux Arc-enabled servers
- **At scale**: Use Azure Policy to deploy across all Arc-enabled servers in selected subscriptions

### Requirements
- Arc agent version 1.46 or higher
- Hybrid Server Resource Administrator role on Arc-enabled server resources
- Network connectivity to regional Azure Migrate endpoints

For detailed installation instructions and regional endpoints, see [Install Azure Migrate Collector VM extension](how-to-install-arc-collector-extension.md) and [Extension reference](arc-collector-extension-reference.md).

## Current limitations

During the preview, the following limitations apply:

- **Sizing methodology**: Assessments without the VM extension use as-on-premises sizing. They don't perform right-sizing based on performance history.
- **Target recommendations**: Only Azure VM targets are recommended. AVS and other specialized targets aren't supported.
- **Management costs**: Business cases don't account for Azure management service costs (such as Azure Update Manager for Arc-enabled servers). They assume on-premises management solutions.
- **Dependency analysis**: Software inventory and dependency mapping aren't available for Arc-discovered resources.
- **Web app discovery**: ASP.NET web apps aren't discovered through Arc-based discovery.

## Comparison with other discovery methods

| Feature | Arc-based discovery | Appliance-based discovery | Import-based discovery |
|---------|---------------------|---------------------------|------------------------|
| **On-premises deployment** | None (uses existing Arc) | Requires appliance VM | None |
| **Setup time** | < 30 minutes | 1-2 hours | < 30 minutes |
| **Discovery scope** | Azure subscriptions | Datacenter/environment | Manual inventory |
| **Automatic discovery** | ✅ Yes | ✅ Yes | ❌ No |
| **Performance data** | ✅ Yes (with extension) | ✅ Yes (automatic) | ❌ No |
| **Software inventory** | ❌ No | ✅ Yes | ❌ No |
| **Dependency mapping** | ❌ No | ✅ Yes | ❌ No |
| **Default business case** | ✅ Yes | ❌ No | ❌ No |
| **Default assessment** | ✅ Yes | ❌ No | ❌ No |
| **SQL Server discovery** | ✅ Yes | ✅ Yes | ❌ No |
| **Web app discovery** | ❌ No | ✅ Yes | ❌ No |

## Prerequisites

Before using Arc-based discovery for Azure Migrate assessments, ensure:

### Azure subscriptions
- At least one subscription where `Microsoft.OffAzure` and `Microsoft.Migrate` resource providers are registered
- At least one resource group where you have Contributor permissions to create a Migrate project
- Subscriptions with Arc resources must have the `Microsoft.OffAzure` resource provider registered

### Permissions
On subscriptions with Arc resources you want to assess:
- `Microsoft.HybridCompute/Machines/read`
- `Microsoft.AzureArcData/SqlInstances/read`

For installing the VM extension:
- Hybrid Server Resource Administrator role on Arc-enabled server resources

### Arc infrastructure
- Arc-enabled servers running agent version 1.46 (September 2024) or higher
- Older agent versions are excluded from discovery

### Networking (for VM extension)
- Arc-enabled servers must be able to reach regional Azure Migrate endpoints
- See [Extension reference](arc-collector-extension-reference.md) for the complete list of regional endpoints

## Getting started

To get started with Arc-based discovery:

1. Follow the [Quickstart: Create a migrate project for Arc resources](quickstart-create-migrate-project-for-arc-resources.md)
2. Review default business cases and assessments
3. Optionally install the Azure Migrate Collector VM extension for performance-based sizing
4. Create custom assessments or business cases as needed

## Next steps

- [Create a migrate project for Arc resources](quickstart-create-migrate-project-for-arc-resources.md)
- [Install Azure Migrate Collector VM extension](how-to-install-arc-collector-extension.md)
- [Sync and manage Arc resources](how-to-sync-arc-resources.md)
- [Build a business case](how-to-build-a-business-case.md)
- [Create an application assessment](create-application-assessment.md)