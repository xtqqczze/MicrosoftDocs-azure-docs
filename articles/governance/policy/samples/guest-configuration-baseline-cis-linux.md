---
title: Reference - Azure Policy guest configuration baseline for Linux
description: Details of the Linux baseline on Azure implemented through Azure Policy guest configuration.
ms.date: 06/16/2025
author: pallakatos
ms.author: pallakatos
ms.topic: reference
ms.custom: generated
---
# CIS Security Benchmarks for Linux Workloads

## Introduction

The Center for Internet Security (CIS) benchmarks are globally recognized security configuration guidelines for hardening systems and applications. CIS benchmarks provide two implementation levels:

- **Level 1 (L1)**: Essential security configurations that provide a clear security benefit without significant impact on functionality
- **Level 2 (L2)**: More stringent security configurations intended for environments requiring higher security, potentially with some impact on functionality or usability

This page documents Azure's new capability offering built-in CIS Benchmarks to your workloads which you can tailor to your needs.

## Using CIS Benchmarks in Azure

Customers can now apply CIS Linux security baselines using **Azure Policy with Machine Configuration**. This new capability enables:

- **Automated compliance assessment**: Continuously monitor your Linux systems against official CIS benchmarks
- **Tailored benchmarks**: Customize the benchmark by defining exceptions and custom parameters
- **Compliance reporting**: Get detailed CIS style reports on your systems

To get started, navigate to Azure Policy in the Azure portal and you will find a new blade on the left side under the **"Authoring"** menu item called **"Machine Configuration"**. Click on that and select the definition called: **"Official Center for Internet Security (CIS) Benchmarks for Linux Workloads"** and then click on **"Modify Settings"** which will bring you the next page where you can select the distributions you want to customize the CIS Benchmarks for.

The built-in Policy name associated with this capability is: ***[Preview]: Official CIS Security Benchmarks for Linux Workloads***

All of the supported Benchmarks are powered by **[azure-osconfig's](https://github.com/Azure/azure-osconfig/)** new compliance engine.

## Supported Benchmarks and Versions

The following Linux distributions and CIS benchmark versions are currently supported, all certified by CIS for benchmark assessment:

| Distribution | CIS Benchmark Version | Profiles | CIS Certified | Audit | Auto-Remediation |
|--------------|----------------------|----------|---------------|-------|------------------|
| Ubuntu 22.04 LTS + Pro | v2.0.0 | L1 + L2 Server | ✓ | ✓ | X |
| Ubuntu 24.04 LTS + Pro | v1.0.0 | L1 + L2 Server | ✓ | ✓ | X |
| RedHat Enterprise Linux 8 | v3.0.0 | L1 + L2 Server | ✓ | ✓ | X |
| RedHat Enterprise Linux 9 | v2.0.0 | L1 + L2 Server | ✓ | ✓ | X |
| Alma Linux 8 | v3.0.0 | L1 + L2 Server | ✓ | ✓ | X |
| Alma Linux 9 | v2.0.0 | L1 + L2 Server | ✓ | ✓ | X |
| Rocky Linux 8 | v2.0.0 | L1 + L2 Server | ✓ | ✓ | X |
| Rocky Linux 9 | v2.0.0 | L1 + L2 Server | ✓ | ✓ | X |
| Oracle Linux 8 | v3.0.0 | L1 + L2 Server | ✓ | ✓ | X |
| Oracle Linux 9 | v2.0.0 | L1 + L2 Server | ✓ | ✓ | X |
| Debian Linux 12 | v1.1.0 | L1 + L2 Server | ✓ | ✓ | X |
| SUSE Linux Enterprise 15 | v2.0.1 | L1 + L2 Server | ✓ | ✓ | X |

**Note**: Auto-remediation capabilities are planned for future releases and will be marked with ✓ when available.

**Note**: You can use these benchmarks against your hardened images - we are working with the vendors to minimise deviations.

**Note** You can also use these benchmarks against custom images you've built based on top of Vanilla distros as long as the **/etc/os-release** is intact with the original content.

## Custom Parameters

The compliance engine is capable of interpreting dynamic parameters for rule evaluation, which means we are opening up flexible rule customization without requiring code changes. Parameters allow rules to be configured with different values while maintaining the same underlying audit logic.

Parameters are exposed through both the user interface and in the final JSON configuration files which you can download through the Machine Configuration UX experience. However, **we haven't exposed all available parameters initially**, as some rules contain 5-10 or even up to 20 logical conditions and relevant parametersa which could easily overwhelm users. Instead, we're taking a customer-driven approach - **enabling additional rule parameters based on customer feedback**. This ensures we prioritize the most valuable customization options while maintaining a clean user experience.

Please choose one of the following way to let us know which Rule /  CIS Benchmark / Distribution / Version you want to have which parameters enabled for customization:

- [GitHub issue under azure-osconfig repository](https://github.com/Azure/azure-osconfig/issues)
- [Azure Support Case](https://azure.microsoft.com/en-us/support/create-ticket)


### Practical Example: Cron Package Variations
Consider the /etc/cron.daily permissions rule. Some customers may choose to use different cron implementations (e.g., cron, cronie, or bcron). The CIS rule defines by default the package name to be "cron" - however the parameters allow you to customize the package names:

Default: packageName: "cron" and alternativePackageName: "cronie"
Custom: Change packageName to "bcron" for systems using the bcron implementation
The same way you can also apply changes to file permissions, groups, owners etc.

#### Original Rule

        {
            "ruleId": "1249e006-cfa1-93cb-bece-8159bcfdd5d6",
            "name": "Ensure permissions on /etc/cron.daily are configured;DesiredObjectValue",
            "value": "mask=0077 owner=root group=root packageName=cron alternativePackageName=cronie"

        }
#### Customized Rule

        {
            "ruleId": "1249e006-cfa1-93cb-bece-8159bcfdd5d6",
            "name": "Ensure permissions on /etc/cron.daily are configured;DesiredObjectValue",
            "value": "mask=0077 owner=root group=root packageName=bcron alternativePackageName=cronie"
        }




## Release Notes

### Current Release
- **Version**: 1.0.0
- **Release Date**: June 2025
- **Features**:
  - Initial release of CIS Linux baselines for Azure Policy
  - Support for 12 Linux distributions
  - Audit-only functionality for compliance assessment
  - CIS-certified benchmark implementations (list above)
  - Custom parameters (details below)



---

For questions or support regarding CIS Linux baselines in Azure Policy, please refer to the Azure Policy documentation or contact Azure support.
