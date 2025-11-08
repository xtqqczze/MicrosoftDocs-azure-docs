---
title: Secure Azure Infrastructure for SAP Applications
description: This article provides a link collection and guidance about secure Azure infrastructure for SAP applications.
services: virtual-machines-windows,virtual-network,storage
author: cgardin
manager: juergent
ms.service: sap-on-azure
ms.subservice: sap-vm-workloads
ms.topic: concept-article
ms.custom: devx-track-azurecli, devx-track-azurepowershell, linux-related-content
ms.date: 10/07/2025
ms.author: cgardin
# Customer intent: Secure Azure infrastructure for SAP applications
---

# Secure Azure infrastructure for SAP applications

A well-secured SAP solution incorporates many security concepts with many layers that span multiple domains:

- Identity management, provisioning and single sign-on (SSO), multifactor authentication (MFA), global secure access, secure network connection
- Auditing, log analytics, and event management
- Security Information and Event Management (SIEM) and Security Orchestration, Automation, and Response (SOAR) solutions
- Antivirus and anti-malware endpoint protection
- Encryption and key management
- Operating system hardening
- Azure infrastructure hardening

These topics are covered in a series of related pages. SAP applications should be incorporated into the overall Zero Trust security solution for the entire IT landscape. For more information, see the [Microsoft Security page about Zero Trust strategy and architecture](https://www.microsoft.com/security/business/zero-trust?msockid=343d619786f36e041990740887e36ff0).

The SAP security solution should reference the Zero Trust security model. A Zero Trust security solution validates each action at each layer, such as identity, endpoint network access, authentication, and MFA, through SAP application and data access.

:::image type="content" source="media/sap-security-instructure/microsoft-zero-trust-security-diagram.png" border="false" alt-text="Diagram of Microsoft Zero Trust design." lightbox="media/sap-security-instructure/microsoft-zero-trust-security-diagram.png":::

The purpose of this article is to provide a single location with links and a brief description on how to implement identity, security, and audit-related features for SAP solutions running on Azure Hyperscale service tier. This article doesn't specify which security features you should implement, because requirements depend on risk profile, industry, and regulatory environment. This article does make some default recommendations, such as a general recommendation to use Microsoft Defender for Endpoint, transparent database encryption, and backup encryption on all systems.

If you're designing and implementing identity, security, and audit solutions for SAP, review the concepts in [Introduction to the Microsoft cloud security benchmark](/security/benchmark/azure/introduction). You can find more checklists in [Secure overview (Cloud Adoption Framework)](/azure/cloud-adoption-framework/secure/overview#cloud-security-checklist).

## Deployment checklist

The design and implementation of a comprehensive security solution for SAP applications running on Azure is a consulting project.

This article provides a basic deployment pattern that covers a minimum security configuration and a more secure configuration. Organizations that require high security solutions should seek expert consulting advice. Highly secured SAP landscapes could increase operational complexity and make tasks such as system refreshes, upgrades, remote access for support, debugging, and testing for high availability and disaster recovery difficult or complex.

### Minimum: Security deployment checklist

- Defender for Endpoint is active in real-time mode on all endpoints (SAP and non-SAP). Unprotected endpoints are a gateway that an attacker can use to compromise other protected endpoints.
- Defender XDR rules are in place for alerting on (and on Windows, blocking) high-risk executable files.
- Microsoft Sentinel for SAP or another SIEM/SOAR solution is in place.
- All database management systems (DBMSs) are protected with transparent database encryption. Keys are stored in Azure Key Vault (if supported) or hardware security modules (HSMs) (if supported).
- Operating system, DBMS, and other passwords are stored in Key Vault.
- Linux sign-in has passwords disabled. Users can sign in only by using keys.
- Generation 2 virtual machines (VMs) and trusted launch are enabled on all VMs.
- Storage accounts use platform-managed keys (PMKs).
- VM, HANA, SQL, and Oracle backups go to an Azure Backup vault with immutable storage.

### More secure: Security deployment checklist

- Defender for Endpoint is active in real-time mode on all endpoints (SAP and non-SAP). Unprotected endpoints are a gateway an attacker can use to compromise other protected endpoints.
- Defender XDR rules are in place for alerting on (and on Windows, blocking) high-risk executable files.
- Microsoft Sentinel for SAP or another SIEM/SOAR solution is in place.
- All DBMSs are protected with transparent database encryption. Keys are stored in Key Vault (if supported) or HSM (if supported).
- Operating system, DBMS, and other passwords are stored in Key Vault.
- Linux sign-in has passwords disabled. Users can sign in only by using keys.
- Generation 2 VMs and trusted launch are enabled on all VMs. Boot integrity monitoring is enabled.
- Host-based encryption is enabled for all VMs.
- All VMs are modern-generation VMs that support Intel Total Memory Encryption (TME).
- Storage accounts use PMKs for general storage and customer-managed keys (CMKs) for sensitive data.
- VM, HANA, SQL, and Oracle backups go to an Azure Backup vault with immutable storage.
- There's a stronger segregation of duties among SAP Basis, backup, server team, and security/key management.

## Defender for Endpoint

Defender for Endpoint is the only comprehensive antivirus and SAP Endpoint Detection and Response (EDR) solution that's comprehensively benchmarked and tested with SAP benchmarking tools and documented for SAP workloads.

Defender for Endpoint should be deployed on all NetWeaver, S4HANA, HANA, and AnyDB servers without exception. The following deployment guidance for Defender fully covers the correct deployment and configuration of Defender for Endpoint for SAP applications:

- [Microsoft Defender for Endpoint](/defender-endpoint/mde-linux-deployment-on-sap)
- [Microsoft Defender Endpoint on Windows Server with SAP](/defender-endpoint/mde-sap-windows-server)

## Defender XDR

In addition to antivirus and EDR protection Defender can provide more protection with features such as advanced threat hunting, Vulnerability Management, and other capabilities.

The SAPXPG can be exploited and should be monitored using this procedure: [Custom detection rules with advanced hunting: Protecting SAP external OS commands (SAPXPG) - Microsoft Defender for Endpoint](/defender-endpoint/mde-sap-custom-detection-rules).

Defender Vulnerability Management can detect vulnerabilities in the Operating System and Database layer. For more information, see [Microsoft Defender Vulnerability Management dashboard - Microsoft Defender Vulnerability Management](/defender-vulnerability-management/tvm-dashboard-insights). Defender Vulnerability Management doesn't have the functionality to detect ABAP and Java vulnerabilities today

Defender for Storage for Blob What is [Microsoft Defender for Storage - Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-storage-introduction).

For information about support for Azure Files SMB, see the blob post [Azure Files support and new updates in advanced threat protection for Azure Storage](https://azure.microsoft.com/blog/azure-files-support-and-new-updates-in-advanced-threat-protection-for-azure-storage/).

Microsoft Secure Score and Vulnerability Management is discussed in the Operating System section below [Microsoft Defender Vulnerability Management dashboard](/defender-vulnerability-management/tvm-dashboard-insights).

## Microsoft Sentinel for SAP connectors

Microsoft Sentinel SIEM/SOAR solution has a connector for SAP. SAP application specific signals such as user logons and access to sensitive transactions can be monitored and corelated with other SIEM/SOAR signals, such as network access and data exfiltration.

- [Microsoft Sentinel solution for SAP applications overview](/azure/sentinel/sap/solution-overview)
- [140 - The one with Microsoft Sentinel for SAP (Yoav Daniely, Yossi Hasson & Martin Pankraz, Sebastian Ullrich - YouTube](https://www.youtube.com/watch?v=uVsrqCoVWlI)

## Database-level encryption: Transparent database encryption and backup encryption

It's recommended to enable transparent database encryption for all DBMS running SAP applications on Azure. Testing shows that the performance overhead is between zero to two percent. The advantages of transparent database encryption far outweigh the disadvantages. Most DBMS platforms create encrypted backups if the database is transparent database encryption enabled mitigating one common attack vector, theft of backups.

SAP HANA Transparent Database Encryption: SAP HANA doesn't support storing Keys in Azure Key Vault or any other HSM device. For more information, see [3444154 - HSM for SAP HANA Encryption Key Management](https://userapps.support.sap.com/sap/support/knowledge/en/3444154). To enable transparent database encryption on HANA follow [Enable Encryption | SAP Help Portal](https://help.sap.com/docs/SAP_HANA_PLATFORM/6b94445c94ae495c83a19646e7c3fd56/4b11e7dee04f4dd98301fcd86e2f3d8b.html)

SQL Server Transparent Database Encryption is fully integrated into the Azure Key Vault.

- [1380493 - SQL Server Transparent Data Encryption](https://me.sap.com/notes/1380493)
- [Transparent data encryption - SQL Server](/sql/relational-databases/security/encryption/transparent-data-encryption)

Oracle DBMS supports transparent database encryption in combination with SAP applications. Transparent database encryption keys can be stored in HSM PKCS#11 devices

- [974876 - Oracle Transparent Data Encryption](https://me.sap.com/notes/974876/E)
- [2591575 - Using Oracle Transparent Data Encryption with SAP NetWeaver](https://me.sap.com/notes/2591575)
- [Oracle Database Transparent Data Encryption](https://thalesdocs.com/gphsm/ptk/protectserver3/docs/integration_docs/oracle/index.html) – Thales

DB2 Native Encryption is supported in combination with SAP applications. Encryption keys can be stored in HSM PKCS#11 devices.

- [Running an SAP NetWeaver Application Server on DB2 for LUW with the IBM DB2 Encryption Technology](https://www.sap.com/documents/2015/07/7e504681-5b7c-0010-82c7-eda71af511fa.html)
- [DB2 native encryption - IBM Documentation](https://www.ibm.com/docs/en/db2/12.1.0?topic=rest-db2-native-encryption)
- [IBM DB2 and Thales Luna HSMs - Integration Guide | Thales](https://cpl.thalesgroup.com/resources/encryption/ibm-db2-luna-hsms-integration-guide#:~:text=This%20document%20is%20intended%20to%20guide%20security%20administrators,databases%20and%20backup%20images%20using%20DB2%20native%20encryption.)

## Key management: Azure Key Vault and HSM

Azure supports two solutions for Key Management:

- Azure Key Vault: A native Azure service that provides Key Management services (non PKCS#11 compliant).
- Azure Cloud HSM: A hardware level PKCS#11 FIPS 140-3 Level 3 single tenant solution.

More information on these services:

- [What is Azure Key Vault?](/azure/key-vault/general/basic-concepts)
- [Overview of Azure Cloud HSM Preview](/azure/cloud-hsm/overview)
- [How to choose the right key management solution - How to choose between Azure Key Vault, Azure Managed HSM, Azure Dedicated HSM, and Azure Payment HSM](/azure/security/fundamentals/key-management-choose).

It's recommended to store OS and application passwords in Azure Key Vault. Training on secret management [Manage secrets in your server apps with Azure Key Vault - Training](/training/modules/manage-secrets-with-azure-key-vault/?source=recommendations).

Defender for Key Vault is recommended to alert if suspicious activity occurs on Azure Key Vault [Microsoft Defender for Key Vault - the benefits and features - Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-key-vault-introduction).

## OS-level hardening

Operating System patching is one key layer in a secure solution. It isn't possible to consistently and reliably update VMs at scale manually without the use of patch management tools. Azure Update Manager should be used to accelerate and automate this process [Azure Update Manager overview](/azure/update-manager/overview).

> [!NOTE]
> Linux kernel hotpatching has restrictions when the target VMs are running Defender for Endpoint. Review the Defender for Endpoint for SAP documentation. Linux patching requiring OS reboot should be handled manually on Pacemaker systems.

The Microsoft Secure Score should be used to monitor status of a landscape [Microsoft Secure Score for Devices - Microsoft Defender Vulnerability Management](/defender-vulnerability-management/tvm-microsoft-secure-score-devices).

### SUSE, Red Hat, and Oracle Linux

The following links have resources for hardening Linux OS distributions:

- [Azure security baseline for Virtual Machines - Linux Virtual Machines](/security/benchmark/azure/baselines/virtual-machines-linux-virtual-machines-security-baseline)
- [The 18 CIS Critical Security Controls](https://www.cisecurity.org/controls/cis-controls-list)
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks)
- [Operating System Security Hardening Guide for SAP HANA for SUSE Linux Enterprise Server 15 GA and SP1](https://documentation.suse.com/sbp/sap-15/html/OS_Security_Hardening_Guide_for_SAP_HANA_SLES15/index.html)
- [Security hardening guide for SAP HANA | Red Hat Enterprise Linux for SAP Solutions | 9 | Red Hat Documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux_for_sap_solutions/9/html-single/security_hardening_guide_for_sap_hana/index)

High priority items for Linux Operating Systems include:

- Generation 2 VMs with Secure Boot
- Don't allow third Party Repositories (supply chain attack)
- Use Keys and disable password sign-in in sshd_config
- Use Managed Identify for Pacemaker not SPN [Azure SAP Pacemaker MSI SPN](https://techcommunity.microsoft.com/blog/sapapplications/sap-on-azure-high-availability-%E2%80%93-change-from-spn-to-msi-for-pacemaker-clusters-u/3609278)
- Disable root sign-in

It's supported to use SELinux with modern RHEL releases. Microsoft doesn't provide support for SELinux and careful testing is required. For more information, see [3108302 - SAP HANA DB: Recommended OS Settings for RHEL 9](https://me.sap.com/notes/3108302/E).

### Windows operating system

[Azure security baseline for Virtual Machines - Windows Virtual Machines](/security/benchmark/azure/baselines/virtual-machines-windows-virtual-machines-security-baseline)

High priority items for Windows Operating System include:

- Generation 2 VMs with Secure Boot
- Minimize the installation of any 3rd party software
- Configure Windows Firewall with minimal open ports via Group Policy
- SMB Encryption enforced via Group Policy [Configure the SMB client to require encryption in Windows](/windows-server/storage/file-server/configure-smb-client-require-encryption?tabs=group-policy)
- After installation, it's supported to lock the \<sid>adm username as described in SAP Note 1837765. The service account SAPService\<SID> should have "deny interactive login" (the default setting after installation). The SAPService\<SID> and \<sid>adm account must not be deleted. Review [1837765 - Security policies for \<SID>adm and SAPService\<SID> on Windows](https://me.sap.com/notes/1837765/E)
- Configure Windows Group Policy to clear last user name, on permit AD authenticated sign-in (mitigates against cloning attack) and disable legacy TLS and SMB protocols

Other links for Windows:

- [Windows Server 2025 Security Book (download)](https://aka.ms/ws2025securitybook)
- [Windows Server Security documentation](/windows-server/security/security-and-assurance)

## Azure Infrastructure Platform Security

Azure infrastructure security configuration can be enhanced to reduce or eliminate attack vectors.

### Generation 2 VM and Trusted Launch

It's recommended to only deploy Generation 2 VMs and to activate Trusted Launch.

> [!NOTE]
> Note only recent versions of SUSE 15 support Trusted Launch. [Trusted Launch for Azure VMs - Azure Virtual Machines](/azure/virtual-machines/trusted-launch#operating-systems-supported)

[Trusted Launch for Azure VMs - Azure Virtual Machines](/azure/virtual-machines/trusted-launch)

[Improve the security of Generation 2 VMs via Trusted Launch in Azure DevTest Labs | Develop from the cloud](https://devblogs.microsoft.com/develop-from-the-cloud/improve-the-security-of-generation-2-vms-via-trusted-launch-in-azure-devtest-labs/)

The conversion from Gen1 to Gen2 can be a little complex especially for Windows OS. It's recommended to only deploy Gen2 Trusted Launch VMs by default. [Upgrade Gen1 VMs to Trusted launch - Azure Virtual Machines](/azure/virtual-machines/trusted-launch-existing-vm-gen-1?tabs=windows%2Cpowershell).

The list of Azure VMs supported Trusted Launch is listed here [Trusted Launch for Azure VMs - Azure Virtual Machines](/azure/virtual-machines/trusted-launch#virtual-machines-sizes).

Defender for Cloud can monitor Trusted Launch. [Trusted Launch for Azure VMs - Azure Virtual Machines](/azure/virtual-machines/trusted-launch#microsoft-defender-for-cloud-integration).

### Encryption in Transit for Azure Files NFS & SMB

Azure Files NFS traffic can be encrypted to protect against packet tracing and other threats:

- [How to Encrypt Data in Transit for NFS shares](/azure/storage/files/encryption-in-transit-for-nfs-shares?tabs=Ubuntu)
- [Azure Files NFS Encryption in Transit for SAP on Azure Systems](/azure/sap/workloads/sap-azure-files-nfs-encryption-in-transit-guide?tabs=SUSE)

Azure Files SMB supports Encryption in Transit by default [SMB file shares in Azure Files](/azure/storage/files/files-smb-protocol?tabs=azure-portal#security).

### Encryption at Host (HBE)

Currently customers should contact Microsoft to verify M-series VMs have the latest drivers required for Encryption at Host. M-series v3, D series, and E series VMs can use Encryption at Host without restriction.
Encryption at Host is tested with SAP and can be used without restriction on modern Azure VMs. The overhead is around 2%.

- [Server-side encryption of Azure managed disks - Azure Virtual Machines](/azure/virtual-machines/disk-encryption#encryption-at-host---end-to-end-encryption-for-your-vm-data)
- [Overview of managed disk encryption options - Azure Virtual Machines](/azure/virtual-machines/disk-encryption-overview#comparison)

### Storage Account Encryption

Storage Accounts use either Platform Managed Keys (PMK) or Customer Managed Keys (CMK). Both are fully supported with SAP applications. [Azure Storage encryption for data at rest](/azure/storage/common/storage-service-encryption).

Customer Managed Keys within one tenant or across tenants is supported Use a disk encryption set across [Microsoft Entra tenants - Azure Virtual Machines](/azure/virtual-machines/disks-cross-tenant-customer-managed-keys?tabs=azure-portal).

Double Encryption at rest can be used for highly secure SAP systems [Enable double encryption at rest for managed disks - Azure Virtual Machines](/azure/virtual-machines/disks-enable-double-encryption-at-rest-portal?tabs=portal) (not supported on Ultra or Premium SSD v2).

A comparison of Disk Encryption technologies can be found here [Overview of managed disk encryption options - Azure Virtual Machines](/azure/virtual-machines/disk-encryption-overview#comparison).

> [!IMPORTANT]
> Azure Disk Encryption isn't supported for SAP systems.

### Virtual Network Encryption

Virtual Network Encryption can be considered for high security deployments and gateways. There are some [feature restrictions](/azure/virtual-network/virtual-network-encryption-overview#limitations). Virtual Network Encryption is currently used for specific high security scenarios.
[What is Azure Virtual Network encryption? - Azure Virtual Network](/azure/virtual-network/virtual-network-encryption-overview)

### Intel Total Memory Encryption (TME)

Modern Azure VMs automatically use the TME-MK feature built into modern CPUs. High security customers should use modern VMs and contact Microsoft directly for confirmation that all VM types supported TME. For more information [Runtime Encryption of Memory with Intel&reg; Total Memory](https://www.intel.com/content/www/us/en/developer/articles/news/runtime-encryption-of-memory-with-intel-tme-mk.html)

### Azure Automation account for Azure Site Recovery Agent updates

Review the latest documentation for Azure Site Recovery to configure the Azure Automation user account required for Azure Site Recovery Agent updates from a 'Contributor' to a lower security context. More information can be found [Azure Site Recovery documentation](/azure/site-recovery/).

### Remove Public Endpoints

Public endpoints for Azure objects such as storage accounts and Azure Files should be removed

[Use private endpoints - Azure Storage](/azure/storage/common/storage-private-endpoints)

[Set the default public network access rule: Azure Storage](/azure/storage/common/storage-network-security-set-default-access?tabs=azure-portal)

### DNS hijacking and Subdomain Takeover

[Prevent subdomain takeovers with Azure DNS alias records and Azure App Service's custom domain verification](/azure/security/fundamentals/subdomain-takeover)

In addition Defender for DNS can be used to protect against Malware/RAT command and control targets and other protections [Microsoft Defender for DNS - the benefits and features - Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-dns-introduction)

### Azure Bastion

System Administrator's workstations can be infected with Malware such as Key loggers. Azure Bastion is recommended [Azure Bastion documentation](/azure/bastion/)

## Ransomware Protection

The Azure platform includes powerful ransomware protection features.
It's recommended to use the Azure Immutable Backup Vault to prevent Ransomware or other trojans from encrypting backups. Azure offers WORM storage for this purpose.

[Azure Backup for SAP HANA and SQL Server can write to Azure Blob StorageAzure backup and restore plan to protect against ransomware](/azure/security/fundamentals/backup-plan-to-protect-against-ransomware#azure-backup)

It's possible to configure storage to require a PIN code or MFA before any modification can be performed on backups.

It's possible to configure fully SEC 17a-4(f) Locked Immutable storage policies. [Configure immutability policies for containers - Azure Storage](/azure/storage/blobs/immutable-policy-configure-container-scope?tabs=azure-portal#lock-a-time-based-retention-policy)

It's recommended to review these steps and select the appropriate measures [Azure backup and restore plan to protect against ransomware](/azure/security/fundamentals/backup-plan-to-protect-against-ransomware#steps-to-take-before-an-attack)

Further links:

- [Concept of Immutable vault for Azure Backup - Azure Backup](/azure/backup/backup-azure-immutable-vault-concept?tabs=recovery-services-vault)
- [Azure security fundamentals documentation](/azure/security/fundamentals/)
- [Microsoft Digital Defense Report and Security Intelligence Insights](https://www.microsoft.com/security/business/security-intelligence-report?msockid=343d619786f36e041990740887e36ff0)
- Microsoft also offers support and consulting services for security related topics. See the blog post [DART: the Microsoft cybersecurity team we hope you never meet](https://www.microsoft.com/security/blog/2019/03/25/dart-the-microsoft-cybersecurity-team-we-hope-you-never-meet/).
- Microsoft provides tools to remove ransomware and other Malware from Windows. For more information, see [Microsoft Safety Scanner Download - Microsoft Defender for Endpoint](/defender-endpoint/safety-scanner-download)
- [Windows Malicious Software Removal Tool 64-bit](https://www.microsoft.com/download/details.aspx?id=9905).
- [FAQ - Protect backups from Ransomware with Azure Backup - Azure Backup](/azure/backup/protect-backups-from-ransomware-faq)

Further recommendations for large organizations include segregation of duties. For example, the SAP Administrators and Server Administrators should only have Read Only access to the Backup Vault. Multiuser Authorization and Resource Guard can be implemented to protect against rouge administrators and ransomware. For more information, see [Configure Multi-user authorization using Resource Guard - Azure Backup](/azure/backup/multi-user-authorization?tabs=azure-portal&pivots=vaults-recovery-services-vault).

Extra protection from Ransomware can be achieved by deploying [Azure Firewall Premium Improve your security defenses for ransomware attacks with Azure Firewall Premium](/azure/security/fundamentals/ransomware-protection-with-azure-firewall).

## Unsupported Technologies

Azure Disk Encryption isn't supported for SAP solutions. RHEL and SLES Linux images for SAP applications are considered to be 'custom images' and aren't tested or supported. Azure Encryption at Host is typically used for customers with a requirement for at rest encryption.

> [!Important]
> Azure Disk Encryption is now a deprecated feature. For more information, see [Azure updates](https://azure.microsoft.com/updates?id=493779).

## SAP Security Notes

SAP release information about vulnerabilities in their products on the second Tuesday of every month. Vulnerabilities with a CVE score between 9.0 and 10 are severe and should be immediately mitigated.

- Entry point for [SAP Security Notes](https://support.sap.com/en/my-support/knowledge-base/security-notes-news.html)
- Second Tuesday of every month [SAP release Security Notes](https://support.sap.com/en/my-support/knowledge-base/security-notes-news.html?anchorId=section_370125364)
- Searchable [database of Security Notes](https://me.sap.com/app/securitynotes)

Security Analysts and Forums have reported an increase in the exploitation of SAP specific vulnerabilities. It's recommended to expedite the implementation of CVE Score 9.0 and above. Vulnerabilities that don't require authentication should be expedited through the SAP landscape.

## Related content

- [Microsoft Security Response Center](https://www.microsoft.com/msrc?rtc=1&oneroute=true)
- [3356389 - Antivirus or other security software affecting SAP operations](https://me.sap.com/notes/3356389/E)
- [CVE: Common Vulnerabilities and Exposures](https://www.cve.org/)
- [Azure operational security checklist](/azure/security/fundamentals/operational-checklist)
- [Microsoft Purview classic data governance best practices for security - Microsoft Purview | Azure Docs](/purview/data-gov-classic-security-best-practices)
- [Azure Bastion documentation](/azure/bastion/)
- [Azure security fundamentals documentation](/azure/security/fundamentals/)
- [SAP HANA Database Encryption - SAP Community](https://community.sap.com/t5/technology-blog-posts-by-members/sap-hana-database-encryption/ba-p/13555367)
- [3345490 - Common Criteria Compliance FAQ](https://me.sap.com/notes/3345490)
- [Microsoft Security Compliance Toolkit Guide](/windows/security/operating-system-security/device-management/windows-security-configuration-framework/security-compliance-toolkit-10)
- [SQL Server database security for SAP on Azure - Cloud Adoption Framework](/azure/cloud-adoption-framework/scenarios/sap/sap-lza-database-security)
- [Firmware measured boot and host attestation](/azure/security/fundamentals/measured-boot-host-attestation)
