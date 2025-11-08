---
title: Managed Instance on App Service overview (preview)
description: Managed Instance on Azure App Service is a specialized hosting option that provides isolation, customization, and secure integration with Azure resources, ideal for legacy, and infrastructure-dependent web apps.
keywords: app service, azure app service, managed instance, isolation, vnet integration, registry, COM, RDP, installation scripts, key vault, pv4, pmv4, windows services, GAC, third-party dependencies
ms.topic: overview
ms.date: 11/05/2025
ms.author: msangapu
author: msangapu-msft
ms.service: azure-app-service
---

# Managed Instance on Azure App Service (preview)

Managed Instance on Azure App Service (preview) is a dedicated, plan‑scoped hosting option for Windows web apps that need deep OS/middleware customization, optional private networking, and secure integration with Azure resources. It targets legacy or infrastructure‑dependent workloads (Component Object Model, registry, Microsoft/Windows Installer) while retaining App Service’s managed patching, scaling, diagnostics, and identity features.

> [!IMPORTANT]
> Managed Instance is in public preview, available in select regions and limited to Pv4 and Pmv4 pricing plans. Linux and containers aren't supported.

## Key capabilities

The following table summarizes the main capabilities that Managed Instance offers:

| Capability | Description |
|-----------|-------------|
| Network isolation | Plan-level virtual network integration with private endpoints, custom routing, and NSG support |
| Custom component support | PowerShell install scripts for Component Object Model (COM), registry, Internet Information Services (IIS) configuration, ACLs, Microsoft/Windows Installers (MSI) (Ex. third-party components; Windows services; install components into Global Assembly Cache (GAC), enable additional Windows features (Ex. Message Queuing (MSMQ) client) |
| Registry adapters | Registry keys that Azure Key Vault backs for secure configuration |
| Storage flexibility | Azure Files with Key Vault, UNC paths, and local ephemeral storage (default 2 GB) |
| Managed identity | System and user-assigned identities for secure resource access |
| Operational efficiency | Platform-managed load balancing, patching cadence, and autoscale (PV4/PMV4 only) |
| RDP via Azure Bastion | Temporary diagnostics access using Bastion and virtual network; persistent changes require install scripts |

## Architecture and isolation

Managed Instance provides plan-scoped isolation and gives you full control over network boundaries. Applications run in a dedicated environment with private routing to internal systems while benefiting from App Service’s managed infrastructure. Key elements include:

- Private DNS integration for internal name resolution
- Dedicated compute for predictable performance
- Network view at the plan level for NSGs, NAT gateways, and route tables

## Customization model

Managed Instance introduces a flexible configuration approach:

- **Install scripts**: Upload zipped PowerShell scripts to Azure Storage with managed identity. Scripts run at startup for persistent configuration.  
  - Changes made during RDP sessions are temporary and lost after restart or platform maintenance.
  - Logs for script execution are stored in App Service console logs and can be streamed to Azure Monitor.

- **Registry adapters**: Define registry keys at the plan level and store secret values in Azure Key Vault.

- **Storage mounts**: Expose storage mappings using drive letter of your choice. Options supported include Azure Files, Custom (UNC Paths) and Local (temporary storage). Local storage is non-persistent across restarts. Use Azure Files or UNC paths for durable storage.

## Logging and troubleshooting

- Storage mount and registry adapter events are captured in App Service platform logs. These logs can be streamed via Logstream or integrated with Azure Monitor.
- Install script logs are available in App Service console logs and on the instance (e.g., C:\InstallScripts\<scriptName>\Install.log). Use Logstream or Azure Monitor for centralized access.
- RDP access requires Azure Bastion and VNet integration. IIS Manager and Event Viewer are recommended for diagnostics.

## Usage scenarios

The following table outlines common scenarios where Managed Instance is beneficial:

| Scenario | Description |
|----------|-------------|
| Lift and improve | Migrate applications with minimal changes while gaining managed scale and high availability |
| Legacy replatforming | Host applications with COM, registry, or MSI dependencies |
| Hybrid and regulated workloads | Meet compliance requirements using private networking and secure secret storage |
| Incremental modernization | Move "as is" and adopt DevOps and observability practices over time |

## Supported features

This table lists features supported in Managed Instance:

| Feature | Description |
|---------|-------------|
| COM, registry, MSI | Run legacy installers and register COM components via startup (install) scripts; define persistent registry values (secrets via Key Vault–backed registry adapters). |
| Drive mapping / network share access | Scripted access to network shares or mounted storage for legacy code expecting a path beyond default local directories (use install scripts or storage mount features; avoid manual RDP mapping). |
| RDP via Azure Bastion (diagnostics) | Just-in-time RDP access for troubleshooting (logs, Event Viewer, IIS Manager). All persistent changes must be scripted; RDP sessions are non-durable. |
| Managed identity | System- and user-assigned identities for secure, keyless access to Azure resources (Key Vault, Storage, etc.). |
| VNet integration (plan level) | Optional plan-scoped virtual network attachment for private routing, restricted egress, and alignment with internal network/security policies (can be added after creation). |
| TLS and custom domains | Standard App Service certificate binding and custom domain configuration; validate automation flows during preview. |
| Auto-scaling | Horizontal scale out/in across plan instances using App Service scale settings; vertical scale limited to Pv4 / Pmv4 SKUs. |
| MSMQ client | Support for Microsoft Message Queuing client components installed/configured through scripts for legacy messaging workloads. |
| CI/CD integration | Works with GitHub Actions, Azure DevOps, and other deployment methods (zip, package, run-from-package) like standard App Service. |
| Microsoft Entra ID (authentication) | Built-in authentication/authorization integration (App Service Authentication) with Entra ID and supported identity providers. |
| .NET runtimes (.NET Framework 3.5, 4.8, .NET 8) and custom stacks | Pre-installed Windows runtimes; additional or alternate frameworks/tools can be added via install scripts (you own patching for anything you add). |

## Limitations and considerations

The following table summarizes limitations and considerations for Managed Instance:

| Feature | Status |
|--------|--------|
| Linux and Containers | Not supported (Windows code only) |
| App Service SKUs | Pv4 and Pmv4 only |
| Durable RDP changes | Use install scripts |
| WebJobs | Not supported |
| Region availability | Limited to select Azure regions<sup>*</sup>. Microsoft continually adds availability to other regions. |
| NTLM/Kerberos Auth, Domain Joined Instances |  (Inbound Authentication Support via Entra ID and Managed Identity Authentication Support for other Azure Service like Azure SQL) |
| Support for Non-Web Workloads like TCP\Net Pipes | Not supported |

<sup>*</sup>Example preview regions (subject to change): East Asia, West Central US, North Europe, East US.

## Comparison: App Service vs. Managed Instance

This table compares standard App Service and Managed Instance:

| Area | App Service | Managed Instance |
|------|-------------|------------------|
| Hosting | Multi-tenant or ASE | Multi-tenant, plan-scoped isolation |
| COM or MSI support | No | Yes |
| RDP access | No | Yes |
| IIS Manager (via RDP)| No | Yes |
| Drive mapping | No | Yes |
| VNet integration | Yes (app level) | Yes (plan level) |
| Containers or Linux | Yes | No |
| Scaling | Yes | Yes (horizontal; vertical constrained to PV4/PMV4 SKUs) |
| Language/runtime breadth | Windows & Linux stacks; containers | Windows stacks; custom via scripts (no Linux/container) |

## When to Use Managed Instance vs. App Service

| Scenario | Recommended Option |
|----------|--------------------|
| You need RDP access for advanced diagnostics | **Managed Instance** |
| Need COM/registry/MSI or IIS Manager | **Managed Instance** |
| You're migrating legacy .NET apps with minimal code changes | **Managed Instance** |
| Plan‑level isolation with private routing? | **Managed Instance** |
| You're building cloud-native apps using modern frameworks (e.g., .NET, Node.js, Python) | **App Service (Windows/Linux)** or **Managed Instance** |
| Need only multi-language modern web (no deep OS customization)? | **App Service (Windows/Linux)** |
| You require Linux or container support | **App Service (Windows/Linux)** |


## Best practices

- Use install scripts for persistent configuration.
- Centralize secrets using Key Vault and registry adapters.
- Validate telemetry setup in preview environments.
- Test scripts in staging before production rollout.
- Align network rules with dependency inventories.
- Monitor with Microsoft Defender for Cloud for threat detection.

## Next steps

- [App Service overview](overview.md)
- [Managed Instance Quickstart](quickstart-managed-instance.md)
- [Security in App Service](overview-security.md)
- [App Service Environment comparison](./environment/overview.md)