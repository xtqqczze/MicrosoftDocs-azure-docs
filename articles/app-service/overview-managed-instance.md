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
> Managed Instance is in public preview, available in select regions and limited to Pv4 and Pmv4 [pricing plans](https://azure.microsoft.com/pricing/calculator/). Linux and containers aren't supported.

## Key capabilities

The following table summarizes the main capabilities that Managed Instance offers:

| Category | Capability |
|-----------|-------------|
| Network isolation | Plan-level virtual network integration with:<br>• Private endpoints and custom routing<br>• NSG support, NAT gateways, and route tables<br>• Private DNS integration for internal name resolution<br>• Optional plan-scoped attachment (can be added after creation) |
| Compute isolation | • Plan-scoped isolation with full control over network boundaries<br>• Dedicated compute for predictable performance<br>• Applications run in dedicated environment with private routing to internal systems |
| Custom component support | PowerShell install scripts for:<br>• Component Object Model (COM)<br>• Registry and persistent registry values<br>• Internet Information Services (IIS) configuration<br>• ACLs and Microsoft/Windows Installers (MSI)<br>• Third-party components and Windows services<br>• Install components into Global Assembly Cache (GAC)<br>• Additional Windows features (Ex. MSMQ client)<br>• Custom frameworks and tools (you own patching for custom additions) |
| Registry adapters | Registry keys that Azure Key Vault backs for secure configuration |
| Storage flexibility | • Azure Files with Key Vault<br>• Universal Naming Convention (UNC) paths and network share access<br>• Local, temporary storage (default 2 GB)<br>• Scripted drive mapping for legacy code |
| Managed identity (at the App Service plan) | • System-assigned and user-assigned identities<br>• Keyless access to Azure resources (Key Vault, Storage, etc.) |
| Operational efficiency | Platform-managed:<br>• Load balancing<br>• Patching cadence<br>• Horizontal autoscale (scale out/in across plan instances)<br>• Vertical scale (Pv4/Pmv4 SKUs only) |
| Remote Desktop Protocol | • Just-in-time RDP access via Azure Bastion for diagnostics (logs, Event Viewer, IIS Manager)<br>• Non-durable sessions; persistent changes require install scripts |
| Security and authentication | • TLS and custom domain support with certificate binding<br>• Built-in App Service Authentication with Microsoft Entra ID and supported identity providers |
| Runtime support | • Pre-installed .NET Framework (3.5, 4.8) and .NET 8<br>• Custom stacks via install scripts |
| CI/CD integration | GitHub Actions, Azure DevOps, and standard deployment methods (zip, package, run-from-package) |

## Azure portal configurable settings

Managed Instance introduces a flexible configuration approach:

- **Configuration (install) scripts**: Upload zipped PowerShell scripts to Azure Storage with managed identity. Scripts run at startup for persistent configuration.  
  - Changes made during RDP sessions are temporary and lost after restart or platform maintenance.
  - Logs for script execution are stored in App Service console logs and can be streamed to Azure Monitor.

- **Windows registry keys**: Define registry keys at the plan level and store secret values in Azure Key Vault.

- **Storage mounts**: Expose storage mappings using drive letter of your choice. Options supported include Azure Files, Custom (UNC Paths) and Local (temporary storage). Local storage is non-persistent across restarts. Use Azure Files or UNC paths for durable storage.

-  **RDP**: Remote desktop.

## Logging and troubleshooting

- Managed Instance logs are created at the App Service plan level and not the app level.
- Storage mount and registry adapter events are captured in App Service platform logs. These logs can be streamed via Logstream or integrated with Azure Monitor.
- Install script logs are available in App Service console logs and on the instance (e.g., C:\InstallScripts\<scriptName>\Install.log). Use Logstream or Azure Monitor for centralized access.
- RDP access requires Azure Bastion and VNet integration. IIS Manager and Event Viewer are recommended for diagnostics.

## Choosing the Right Hosting Option

### Use Managed Instance if you need:

**Legacy Windows dependencies**
- COM components, registry access, MSI installers
- IIS Manager and RDP access for diagnostics
- Drive mapping or UNC path access

**Migration with minimal code changes**
- "Lift and improve" legacy .NET Framework apps
- Incremental modernization approach
- Plan-level network isolation for regulated workloads

**Advanced customization**
- PowerShell configuration scripts at startup
- Windows features (MSMQ, additional roles)
- Custom third-party components in GAC

### Use Standard App Service if you need:

- Modern cloud-native development (any language)
- Linux or container support
- Simplified management without OS customization
- Broader runtime and framework options

### Use App Service Environment (ASE) if you need:

- Full network isolation for 100+ applications
- Large-scale dedicated infrastructure

## Current Limitations (Preview)

| Limitation | Details |
|-----------|---------|
| **Platform** | Windows only (no Linux/containers) |
| **SKUs** | Pv4 and Pmv4 only |
| **Regions** | East Asia, West Central US, North Europe, East US |
| **Authentication** | Entra ID and Managed Identity only (no domain join/NTLM/Kerberos) |
| **Workloads** | Web apps only (no WebJobs, TCP/NetPipes) |
| **Configuration** | Persistent changes require scripts (RDP is diagnostics-only) |

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