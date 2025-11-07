---
title: Understand The Baseline Json Format
description: This article explains how to read and author the **baseline JSON parameter** used by **Azure Machine Configuration** for **CIS Linux Benchmarks** and **Azure...
ms.date: 11/07/2025
ms.topic: conceptual
---

# **Understand the Baseline Settings Parameter Format**

This article explains how to read and author the **baseline JSON parameter** used by **Azure Machine Configuration** for **CIS Linux Benchmarks** and **Azure Security Baseline (ASB)**.  
It covers how *“apply-all”* works, how settings *exclusions* are expressed, and provides concise JSON examples for **CIS Benchmarks (Linux)** and **Azure Security Baseline (Windows and Linux)**.

## **Schema at a Glance**

| **Field** | **Description** |
|----|----|
| **standard** | "CIS" or "Microsoft" — identifies the baseline source. |
| **baselineSettings\[\]** | One or more baselines included in the payload. |
| **name** | Name of the baseline (e.g., *CIS Oracle Linux 8*, *Azure Security Baseline for Windows*). |
| **version** | Baseline version string. |
| **settings\[\]** | Optional list of rule entries. When empty (\[\]), all rules apply. |

### **Interpreting the “settings” array**

| **Configuration** | **Meaning** |
|----|----|
| settings: \[\] | Apply **all** rules for the specified baseline/OS (“apply-all”). |
| settings: \[{ … }\] | Apply **only the specified** rules or values; all other rules are excluded. |
| Baseline block omitted | **Exclude** that OS or distribution completely (0 rules apply). |

**Important:**  
“Apply-all default settings” is signaled by including the distributions benchmark block with an empty settings array. Exclusion is signaled by omitting the entire baseline block.

## **CIS Benchmarks (Linux)**

CIS benchmarks are defined **per distribution/version**. A single JSON file may contain multiple distro blocks (e.g., AlmaLinux, Oracle Linux, RHEL).

### **Reading CIS JSON Payloads**

- settings: \[\] → Apply **all** default CIS rules for that distro/version). This approach keeps the payload minimal.

- settings: \[{ … }\] → Apply only the listed rules; all other rules are omitted from evaluation.

- Distro block missing → Excluded (no rules applied).

### **Example: CIS JSON (Linux)**

{  
"standard": "CIS",  
"baselineSettings": \[  
{  
"name": "CIS Oracle Linux 8",  
"version": "3.0.0",  
"settings": \[  
{ "ruleId": "cis-ssh-5.2.1", "name": "Ensure SSH Protocol is set to 2", "value": "2" },  
{ "ruleId": "cis-audit-4.1", "name": "Ensure auditing for processes that start prior to auditd", "value": "1" },

// ....  
\]  
},  
{  
"name": "CIS AlmaLinux 8",  
"version": "3.0.0",  
"settings": \[\] // apply all settings as default  
}  
\]  
}

In the example above:

- **Oracle Linux 8:** Only two rules are evaluated.

- **AlmaLinux 8:** All rules apply.

- **Other distros:** Not listed, so excluded.

## **Azure Security Baselines (ASB)**

Azure Security Baseline (ASB) is published separately for **Windows** and **Linux** and follows the same schema structure. Unlike CIS, these baselines often include **role- or version-specific** settings.

### **ASB for Windows**

ASB for Windows allows complex scoping of rule values per Windows Server **year** and **role** using the following pattern:

WindowsServer\\Year\>\\Server-Role\>:\<Value\>

- A **wildcard (\*)** can be used to apply a setting across all roles or versions.

- This format supports integers and strings as valid input in the settings value.

For example:

WindowsServer\2025\DomainController:1;WindowsServer\2025\MemberServer:1;WindowsServer\2022\\:1

### **Example: ASB JSON (Windows)**

{  
"standard": "Microsoft",  
"baselineSettings": \[  
{  
"name": "Azure Security Baseline for Windows",  
"version": "1.0.0",  
"settings": \[  
{  
"ruleId": "ab12cd34-5678-90ef-gh12-3456789ijklm",  
"name": "Ensure Windows Firewall is enabled for all profiles",  
"value": "WindowsServer\\2025\\\*:1"  
},

// .....  
\]  
}  
\]  
}

### **ASB for Linux**

ASB for Linux follows the same structure but omits Windows-specific scoping.  
Rules are defined per control with expected values.

### **Example: ASB JSON (Linux)**

{  
"standard": "Microsoft",  
"baselineSettings": \[  
{  
"name": "Azure Security Baseline for Linux",  
"version": "1.0.0",  
"settings": \[  
{  
"ruleId": "35868e8c-97eb-4981-ab79-99b25101cc86",  
"name": "Ensure that the SSH protocol is configured;DesiredObjectValue",  
"value": "1"  
},

// ...  
\]  
}  
\]  
}

## **Next Steps**

- Customize and deploy baseline policies in Azure Policy

- Query compliance results using Azure Resource Graph

- Azure Machine Configuration overview


## Next steps

- Review the converted content for accuracy
- Update any placeholder content
- Add relevant links and references

## References

- (none)