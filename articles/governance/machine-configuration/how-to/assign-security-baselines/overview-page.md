---
title: Overview Page
description: **Overview**
ms.date: 11/07/2025
ms.topic: conceptual
---

# **TOC Entry: Overview Page**

**Overview**  
Customizable security baselines built on Azure Policy and Machine Configuration enable organizations to assess, monitor, and continuously improve server compliance against trusted industry benchmarks.

This capability introduces *audit* baselines for both Windows and Linux, empowering customers to align security posture with internal compliance frameworks and regulatory standards. By passing custom baseline parameter input directly into Azure Policy, you can now represent organization-specific controls at scale.

These baselines deliver **a cloud-native governance experience** for both Azure machines and non-Azure machines connected through [Azure Arc](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview), including machines running on-premises, in other public clouds, or at the edge. Together, Policy and Machine Configuration establish a unified control plane for compliance visibility, enabling you to assess, monitor, and **enforce consistent security standards across your entire estate**, regardless of location or platform. This approach reflects **Microsoft’s Secure by Design** and **Secure by Default principles**, ensuring robust security and compliance everywhere your workloads run.

### **Key Scenarios**

**Baseline Customization**  
Create tailored baselines using the *Modify Settings* wizard under **Policy \> Machine Configuration**. Administrators can enable, exclude, or adjust rules from industry benchmarks (like CIS Benchmarks or Microsoft baselines) to match internal standards. Each customization builds a downloadable JSON file that captures configuration intent — a reusable artifact compatible for policy-as-code workflows.

**Assign Audit Policies**  
Use Azure Policy to deploy your customized baseline parameters across Azure and Arc-connected machines. When an audit policy is assigned, Azure Policy evaluates configuration states against selected benchmarks, reports compliance in real time, and surfaces findings across **Azure Policy**, **Azure Resource Graph (ARG)**, and the **Guest Assignments** view.

**Integration and Automation**  
Integrate baselines into CI/CD pipelines or configuration management workflows. Each baseline produces a declarative settings catalog (JSON) that can be version-controlled and deployed using CLI, ARM, or Bicep templates — ensuring reproducible compliance configurations across environments.

### **Supported Standards**

| **Standard** | **Description** |
|----|----|
| **Center for Internet Security (CIS) Linux Benchmarks** | Official CIS Benchmarks for all [Azure endorsed Linux distributions](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/endorsed-distros) in parity with what’s published on the CIS [website](https://www.cisecurity.org/). |
| **Azure Compute Security Baseline for Windows** | Applies customized values for Windows Server 2022 and Windows Server 2025. |
| **Azure Compute Security Baseline for Linux** | Enforces consistent security controls aligned with Azure Compute guidance. |

Additional standards (e.g., STIG), operating systems, and remediation capabilities will be introduced in future releases.

### **Availability**

All **public Azure regions** are supported.

**NOTE**: Support for **Azure Government** and **Sovereign Clouds** will be added closer to General Availability.

### **Getting Started**

**Process Overview**  
The end-to-end experience for configuring Customizable Security Baselines follows these high-level steps:

1.  **Select a baseline** from the *Machine Configuration* blade under Azure Policy.

2.  **Modify settings** — enable, exclude, or parameterize rules to match your internal requirements.

3.  **Download the JSON file** representing your configured baseline.

4.  **Assign the baseline policy** using the Azure Portal, CLI, or CI/CD integration.

5.  **Review compliance results** through Azure Policy, Azure Resource Graph, or the Guest Assignments page.

**Prerequisites**

- **Azure Machine Configuration** **prerequisite policy initiative** must be deployed. This enables Guest Configuration policies and installs the required extension on VMs.

- An Azure subscription or management group containing supported Windows and Linux VMs.

- Sufficient permissions to create and assign custom policy definitions (Owner or Resource Policy Contributor roles).

## **Next Steps**

- Get Started with creating a security baseline policy assignment

- Learn more about Azure Machine Configuration

- Experiment with baseline customization and integration into DevOps workflows.

- Monitor the documentation for updates as new standards and features are released.


## Next steps

- Review the converted content for accuracy
- Update any placeholder content
- Add relevant links and references

## References

- (none)