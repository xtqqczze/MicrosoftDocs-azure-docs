---
title: End-to-end security in Azure | Microsoft Docs
description: This article provides an overview of Azure security architecture organized by protection, detection, and response capabilities, with links to detailed domain-specific documentation.
services: security
author: msmbaldwin
manager: rkarlin

ms.assetid: a5a7f60a-97e2-49b4-a8c5-7c010ff27ef8
ms.service: security
ms.subservice: security-fundamentals
ms.topic: conceptual
ms.date: 11/04/2025
ms.author: mbaldwin

---
# End-to-end security in Azure

Azure provides comprehensive security capabilities across all layers of your cloud deployments. Microsoft Azure delivers confidentiality, integrity, and availability of customer data while enabling transparent accountability. This article introduces Azure's security architecture organized by protection, detection, and response capabilities.

For detailed implementation guidance and best practices, refer to the domain-specific security overview articles linked throughout this document.


## Microsoft security architecture

Azure security services are organized into three foundational categories:

- **Secure and protect**: Implement defense-in-depth strategies across identity, infrastructure, networks, and data
- **Detect threats**: Identify suspicious activities and potential security incidents
- **Investigate and respond**: Analyze security events and take corrective actions

The following diagram illustrates how Azure security services align with these categories and the resources they protect:

:::image type="content" source="media/end-to-end/security-diagram.svg" alt-text="Diagram showing end-to-end security services in Azure." border="false":::


## Security controls and baselines

The [Microsoft cloud security benchmark](https://learn.microsoft.com/security/benchmark/azure/introduction) provides comprehensive security guidance for Azure services:

- **Security controls**: High-level recommendations applicable across your Azure tenant and services
- **Service baselines**: Implementation of controls for individual Azure services with specific configuration recommendations

Use these controls and baselines to:

- Establish security standards for cloud deployments
- Assess compliance at scale using [Microsoft Defender for Cloud regulatory compliance dashboard](https://learn.microsoft.com/azure/defender-for-cloud/regulatory-compliance-dashboard)
- Map to industry frameworks including CIS, NIST, and PCI-DSS
- Implement secure configurations with [Azure Policy](https://learn.microsoft.com/azure/governance/policy/overview)

For governance and compliance capabilities, see [Azure security management and monitoring overview](https://learn.microsoft.com/azure/security/fundamentals/management-monitoring-overview).

## Secure and protect

Azure provides layered security controls across identity, infrastructure, networks, and data. For detailed implementation guidance, refer to the domain-specific overview articles.

### Threat protection

[Microsoft Defender for Cloud](https://learn.microsoft.com/azure/defender-for-cloud/defender-for-cloud-introduction) provides unified security management with continuous assessment and advanced threat protection. For comprehensive coverage, see [Azure threat protection](https://learn.microsoft.com/azure/security/fundamentals/threat-detection).

### Identity and access

- [Microsoft Entra ID](https://learn.microsoft.com/entra/fundamentals/whatis) - Cloud identity and access management
- [Privileged Identity Management](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-configure) - Just-in-time privileged access
- [Microsoft Entra ID Protection](https://learn.microsoft.com/entra/id-protection/overview-identity-protection) - Automated risk detection and remediation

For details, see [Azure identity management security overview](https://learn.microsoft.com/azure/security/fundamentals/identity-management-overview).

### Network security

- [Azure Firewall](https://learn.microsoft.com/azure/firewall/overview) - Cloud-native network firewall with IDPS
- [Azure DDoS Protection](https://learn.microsoft.com/azure/ddos-protection/ddos-protection-overview) - Always-on DDoS mitigation
- [Azure VPN Gateway](https://learn.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpngateways) - Encrypted cross-premises connectivity
- [Azure Front Door](https://learn.microsoft.com/azure/frontdoor/front-door-overview) - Global load balancer with integrated WAF
- [Azure Private Link](https://learn.microsoft.com/azure/private-link/private-link-overview) - Private connectivity to Azure services

For details, see [Azure network security overview](https://learn.microsoft.com/azure/security/fundamentals/network-overview).

### Data protection

- [Azure Key Vault](https://learn.microsoft.com/azure/key-vault/general/overview) - Secure key and secret storage (FIPS 140-2 Level 1 Standard, FIPS 140-3 Level 3 Premium)
- [Key Vault Managed HSM](https://learn.microsoft.com/azure/key-vault/managed-hsm/overview) - Single-tenant FIPS 140-2 Level 3 HSM
- [Azure Storage Service Encryption](https://learn.microsoft.com/azure/storage/common/storage-service-encryption) - Automatic encryption at rest
- [Azure Backup](https://learn.microsoft.com/azure/backup/backup-overview) - Independent and isolated backups
- [Azure confidential computing](https://learn.microsoft.com/azure/confidential-computing/overview) - Hardware-based data protection in use

For details, see [Azure encryption overview](https://learn.microsoft.com/azure/security/fundamentals/encryption-overview) and [Key management in Azure](https://learn.microsoft.com/azure/security/fundamentals/key-management).

### Governance

- [Azure Policy](https://learn.microsoft.com/azure/governance/policy/overview) - Enforce standards and assess compliance

For details, see [Azure security management and monitoring overview](https://learn.microsoft.com/azure/security/fundamentals/management-monitoring-overview).

## Detect threats

Azure threat detection services identify suspicious activities and security incidents across your environment.

- [Microsoft Defender for Cloud](https://learn.microsoft.com/azure/defender-for-cloud/defender-for-cloud-introduction) - Advanced threat protection with workload-specific plans
- [Microsoft Sentinel](https://learn.microsoft.com/azure/sentinel/overview) - Cloud-native SIEM and SOAR solution
- [Microsoft Defender XDR](https://learn.microsoft.com/microsoft-365/security/defender/microsoft-365-defender) - Unified endpoint, identity, email, and application protection
- [Azure Network Watcher](https://learn.microsoft.com/azure/network-watcher/network-watcher-monitoring-overview) - Network monitoring and diagnostics
- [Microsoft Defender for Cloud Apps](https://learn.microsoft.com/defender-cloud-apps/what-is-defender-for-cloud-apps) - Cloud access security broker (CASB)

For comprehensive threat detection capabilities, see [Azure threat protection](https://learn.microsoft.com/azure/security/fundamentals/threat-detection).

## Investigate and respond

Azure provides tools to analyze security events and respond to incidents.

- [Microsoft Sentinel](https://learn.microsoft.com/azure/sentinel/overview) - Threat hunting with search and query tools
- [Azure Monitor](https://learn.microsoft.com/azure/azure-monitor/overview) - Comprehensive telemetry collection and analysis with Log Analytics workspaces
- [Microsoft Entra reports and monitoring](https://learn.microsoft.com/entra/identity/monitoring-health/concept-reporting-monitoring-overview) - Activity logs and audit history
- [Microsoft Defender for Cloud Apps](https://learn.microsoft.com/defender-cloud-apps/investigate) - Cloud environment investigation tools

For monitoring and operational guidance, see [Azure security management and monitoring overview](https://learn.microsoft.com/azure/security/fundamentals/management-monitoring-overview).

## Next steps

- Review [Azure security services and technologies](https://learn.microsoft.com/azure/security/fundamentals/services-technologies) for a comprehensive list of security capabilities
- Understand [shared responsibility in the cloud](https://learn.microsoft.com/azure/security/fundamentals/shared-responsibility)
- Explore [Azure security best practices and patterns](https://learn.microsoft.com/azure/security/fundamentals/best-practices-and-patterns)
- Learn about [Microsoft cloud security benchmark](https://learn.microsoft.com/security/benchmark/azure/introduction)
