---
title: Apply Zero Trust principles to Azure services
description: Learn how to apply Zero Trust principles to Azure infrastructure and services with practical guidance for securing your Azure environment.
author: msmbaldwin
ms.service: security
ms.subservice: security-fundamentals
ms.topic: overview
ms.author: mbaldwin
ms.date: 11/06/2025
---

# Apply Zero Trust principles to Azure services

Zero Trust is a security strategy that assumes breach and verifies each request as though it originated from an uncontrolled network. This article provides guidance on applying Zero Trust principles specifically to Microsoft Azure services and infrastructure.

For comprehensive information about Zero Trust as a security model, including its principles and broader application across Microsoft products, see [What is Zero Trust?](/security/zero-trust/zero-trust-overview).

## Zero Trust principles

Zero Trust is based on three core principles:

- **Verify explicitly** - Always authenticate and authorize based on all available data points, including user identity, location, device health, and service or workload.
- **Use least privilege access** - Limit user access with Just-In-Time and Just-Enough-Access (JIT/JEA), risk-based adaptive policies, and data protection.
- **Assume breach** - Minimize blast radius and segment access. Verify end-to-end encryption and use analytics to get visibility, drive threat detection, and improve defenses.

## Applying Zero Trust to Azure

Applying Zero Trust to Azure requires a multi-disciplinary approach that addresses infrastructure, networking, identity, and data protection. The following sections provide guidance on how to implement Zero Trust across your Azure environment.

### Azure infrastructure services

To apply Zero Trust principles to Azure infrastructure components, you must understand the architectural patterns and systematically apply security controls across each layer.

For comprehensive guidance on applying Zero Trust to Azure IaaS workloads, see:

- [Apply Zero Trust principles to Azure IaaS overview](/security/zero-trust/azure-infrastructure-overview)
  - [Azure storage](/security/zero-trust/azure-infrastructure-storage)
  - [Virtual machines](/security/zero-trust/azure-infrastructure-virtual-machines)
  - [Spoke virtual networks](/security/zero-trust/azure-infrastructure-iaas)
  - [Hub virtual networks](/security/zero-trust/azure-infrastructure-networking)
  - [Spoke virtual networks with Azure PaaS services](/security/zero-trust/azure-infrastructure-paas)
- [Azure Virtual Desktop](/security/zero-trust/azure-infrastructure-avd)
- [Azure Virtual WAN](/security/zero-trust/azure-virtual-wan)

For a comprehensive overview of all Azure service guidance, see [Apply Zero Trust principles to Azure services](/security/zero-trust/apply-zero-trust-azure-services-overview).

### Azure networking

Network security is fundamental to Zero Trust implementation in Azure. Apply Zero Trust principles to Azure networking through encryption, segmentation, visibility, and modern security controls.

For detailed guidance on Azure networking security aligned with Zero Trust principles, see:

- [Apply Zero Trust principles to Azure networking](/security/zero-trust/azure-networking-overview)
  - [Encrypt your network traffic](/security/zero-trust/azure-networking-encryption)
  - [Segment your network traffic](/security/zero-trust/azure-networking-segmentation)
  - [Gain visibility into your network traffic](/security/zero-trust/azure-networking-visibility)
  - [Discontinue legacy network security technology](/security/zero-trust/azure-networking-legacy)

For comprehensive information on Azure network security capabilities and services, see [Azure network security overview](network-overview.md).

### Identity and access management

Identity is the control plane for Zero Trust in Azure. Microsoft Entra ID provides the foundation for verifying explicitly and enforcing least privilege access.

Key identity security capabilities include:

- **Conditional Access** - The primary policy engine for Zero Trust in Azure, enabling risk-based access decisions. See [Conditional Access](/entra/identity/conditional-access/overview) and [Conditional Access for Zero Trust](/azure/architecture/guide/security/conditional-access-design).
- **Privileged Identity Management** - Just-in-time privileged access to Azure resources
- **Microsoft Entra ID Protection** - Automated risk detection and remediation

For comprehensive identity security guidance, see [Azure identity management security overview](identity-management-overview.md).

### Data protection and encryption

Protecting data is central to the "assume breach" principle. Azure provides multiple layers of encryption and data protection.

Key data protection capabilities:

- **Azure Key Vault** - Secure storage and management of secrets, keys, and certificates
- **Encryption at rest** - Default encryption for Azure Storage, SQL Database, and other services
- **Encryption in transit** - TLS/SSL for data in motion
- **Confidential computing** - Protection of data during processing

For detailed encryption guidance, see:

- [Azure encryption overview](encryption-overview.md)
- [Azure data encryption at rest](encryption-atrest.md)
- [Azure Key Vault security overview](key-management.md)

### Threat protection and detection

The "assume breach" principle requires continuous monitoring and threat detection across your Azure environment.

**Microsoft Defender for Cloud** provides unified security management and advanced threat protection for Azure resources. Defender for Cloud should be enabled across all Azure subscriptions and works together with Microsoft Defender XDR for comprehensive protection.

For detailed threat protection guidance, see:

- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction)
- [Azure threat detection overview](threat-detection.md)
- [Microsoft Sentinel and Microsoft Defender XDR](/security/operations/siem-xdr-overview)

### Protecting against cyberattacks

Beyond daily security operations, organizations must prepare for destructive cyberattacks that target Azure resources.

For guidance on protecting Azure resources from cyberattacks, implementing detection, and preparing incident response plans, see [Protect your Azure resources from destructive cyberattacks](/security/zero-trust/azure-protect-resources-cyberattacks).

## Azure security services and capabilities

Azure provides comprehensive security services organized by functional area. Rather than listing all services, this article focuses on Zero Trust implementation patterns. For detailed information about specific security services, see:

- [Introduction to Azure security](overview.md) - Comprehensive overview of Azure security organized by functional area
- [End-to-end security in Azure](end-to-end.md) - Security architecture organized by protection, detection, and response
- [Azure platform security overview](platform.md) - Built-in platform security capabilities
- [Azure security services and technologies](services-technologies.md) - Comprehensive catalog of security services

For service-specific security guidance, see:

- [Virtual machines security overview](virtual-machines-overview.md)
- [Database security checklist](database-security-checklist.md)
- [Azure PaaS deployments best practices](paas-deployments.md)
- [Management and monitoring overview](management-monitoring-overview.md)

## Shared responsibility and the Cloud Adoption Framework

Security in Azure is a shared responsibility between Microsoft and customers. For guidance on how responsibilities are divided and how to implement Zero Trust as part of your cloud adoption journey, see:

- [Shared responsibility in the cloud](shared-responsibility.md)
- [Cloud Adoption Framework - Access control](/azure/cloud-adoption-framework/secure/access-control)
- [Microsoft Cloud Security Benchmark](/security/benchmark/azure/introduction)

## Developer guidance

Application developers play a critical role in Zero Trust implementation. For guidance on building Zero Trust-ready applications, see:

- [Develop using Zero Trust principles](/security/zero-trust/develop/overview)
- [Building apps with a Zero Trust approach to identity](/security/zero-trust/develop/identity)
- [Build Zero Trust-ready apps using Microsoft identity platform](../../active-directory/develop/zero-trust-for-developers.md)

## Next steps

- [Apply Zero Trust principles to Azure services overview](/security/zero-trust/apply-zero-trust-azure-services-overview)
- [Apply Zero Trust principles to Azure IaaS overview](/security/zero-trust/azure-infrastructure-overview)
- [Apply Zero Trust principles to Azure networking](/security/zero-trust/azure-networking-overview)
- [What is Zero Trust?](/security/zero-trust/zero-trust-overview)