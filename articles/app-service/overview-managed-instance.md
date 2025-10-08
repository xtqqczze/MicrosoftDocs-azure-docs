---
title: Managed instance overview (preview)
description: App Service Managed Instance (MI) is a specialized, enterprise-grade hosting option that provides deep isolation, advanced customization, and secure integration with Azure resources—ideal for legacy and infrastructure-dependent web apps.
keywords: app service, azure app service, managed instance, isolation, vnet integration, registry, COM, RDP, installation scripts, key vault, pv4, pmv4
ms.topic: overview
ms.date: 09/19/2025
ms.author: msangapu
author: msangapu-msft
ms.service: azure-app-service
---

# What is App Service Managed Instance (preview)

Azure App Service Managed Instance (ASMI) is a specialized hosting option in Azure App Service. It combines the simplicity of PaaS and the flexibility of IaaS. Use ASMI for applications that require:

- Deep isolation
- Advanced customization
- Secure network integration

ASMI is ideal for legacy web applications or infrastructure-bound workloads that rely on COM components, registry access, or custom installers.

## Key capabilities

| Capability | Description |
|-----------|-------------|
| **Network isolation** | Plan-level VNet integration with private endpoints and restricted ingress and egress. |
| **Custom component support** | PowerShell install scripts for COM, registry, IIS, ACLs, and MSI installers. |
| **Registry adapters** | Registry keys backed by Azure Key Vault for secure configuration. |
| **Managed identity** | System and user-assigned identities for secure access to Azure resources. |
| **Operational efficiency** | Platform-managed load balancing, patching, and scaling. |
| **RDP via Azure Bastion** | Temporary diagnostics access. Make persistent changes through install scripts. |

## Architecture and isolation

MI provides plan-scoped isolation and full control over network boundaries. Apps run in a secure, dedicated environment with private routing to internal systems and still benefit from App Service’s managed infrastructure.

## Customization model

- **Install Scripts**: Upload zipped PowerShell scripts to Azure Storage, and set up the managed instance (MI) to run them at startup.
- **Registry Adapters**: Define registry keys at the plan level, and store the secret values in Azure Key Vault.
- **Drive Mapping**: Use the `net use` command in install scripts to map network shares, including drives beyond C: and D:.

> Remote Desktop Protocol (RDP) is for diagnostics only. Use install scripts for persistent configuration.

## Usage scenarios

| Scenario | Description |
|----------|-------------|
| **Lift and improve** | Migrate applications with minimal changes while gaining managed scale and high availability. |
| **Legacy replatforming** | Host applications with COM, registry, or MSI dependencies. |
| **Hybrid and regulated workloads** | Meet compliance requirements by using private networking and secure secret storage. |
| **Incremental modernization** | Move “as is” and adopt DevOps and observability practices over time. |

## Supported features

| Feature | Supported |
|--------|-----------|
| COM, registry, MSI | Yes |
| Drive mapping | Yes |
| RDP via Bastion | Yes |
| managed identity | Yes |
| VNet integration | Yes |
| TLS and custom domains | Yes |
| MSMQ client | Yes |
| CI/CD integration | Yes |
| Microsoft Entra ID | Yes |
| .NET and Java | Yes |


## Limitations and considerations

| Feature | Status |
|--------|--------|
| **Linux and Containers** | Not supported |
| **App Service SKUs** | PV4 and PMV4 only |
| **Durable RDP Changes** | Use install scripts |
| **Application Insights** | Preview rings might limit classic enablement |
| **Remote Debugging** | Not available in preview |
| **Certificate Automation** | Validate in each environment |


## Comparison: App Service vs. managed instance

| Area | App Service | Managed Instance |
|------|-------------|------------------|
| Hosting | Multi-tenant or ASE | Plan-scoped isolation |
| COM or MSI support | No | Yes |
| RDP access | No | Yes |
| IIS Manager | No | Yes |
| Drive mapping | Limited | Yes |
| VNet integration | Yes (app level, optional) | Yes (plan level) |
| Containers or Linux | Yes | No |

## Example customizing MI

An enterprise replatforms a legacy application with COM and registry dependencies:

1. Upload the PowerShell installer to Azure Storage.
1. Configure registry adapters with Azure Key Vault.
1. Integrate with a virtual network (VNet) for private access.
1. Use Remote Desktop Protocol (RDP) through Azure Bastion for diagnostics only.

## Best practices

- Use install scripts for persistent configuration.
- Centralize secrets using Key Vault and registry adapters.
- Validate telemetry setup in preview environments.
- Test scripts in staging before production rollout.
- Align network rules with dependency inventories.

## Next steps

- [App Service overview](overview.md)
- [Security in App Service](overview-security.md)
- [Reliability architecture](/reliability/reliability-app-service.md)
- [App Service Environment comparison](./environment/overview.md)
