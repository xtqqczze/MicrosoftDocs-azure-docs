---
title: Specify Custom Parameters For Baseline Policy
description: Machine Configuration security baselines provide a unified approach to enforcing security and compliance across diverse environments—including Azure, hybrid,...
ms.date: 11/07/2025
ms.topic: conceptual
---

# **TOC Entry: Specify Custom Parameters for Baseline Policy**

Machine Configuration security baselines provide a unified approach to enforcing security and compliance across diverse environments—including Azure, hybrid, multicloud, and edge scenarios—by supporting both native Azure virtual machines and non-Azure servers that are [Azure Arc-enabled machines](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview) (Windows and Linux).

With built-in security baselines, you can customize security controls to meet your specific requirements to ensure they meet your organization’s requirements before deploying security baselines in your environment.

The new Azure Policy Settings Picker experience streamlines this process, allowing you to select which settings to evaluate, adjust configuration parameters for granular control (including advanced input formats for Linux and Windows), and export your customized baseline as a reusable JSON file. This flexibility ensures that policy enforcement is consistent, precise, and adaptable to complex enterprise needs, regardless of where your workloads run.

**Prerequisite:** Ensure the *Machine Configuration prerequisites* initiative has been assigned to your subscription. You can confirm this from the **Policy \> Machine Configuration** blade in the Azure portal.

### **1. Open the Machine Configuration blade**

1.  In the Azure portal, navigate to **Policy \> Machine Configuration**.

2.  Select the **Definitions** tab.

![Image](../../media/specify-custom-parameters-for-baseline-policy/img-70552accb81b064d8eb5154e3db0a07883f3e336.png)

3.  Choose one of the built-in baselines:

    1.  **Official CIS Benchmarks for Linux Workloads**

    2.  **Azure Security Baseline for Windows**

    3.  **Azure Security Baseline for Linux**

4.  Click **Modify settings**.

![Image](../../media/specify-custom-parameters-for-baseline-policy/img-af335da50e8c406e8da1a6a767b38c324bef2edf.png)

### **2. Select baselines and versions**

The configuration experience differs slightly between Linux and Windows baselines:

- **CIS Benchmarks for Linux:** You can enable one or more supported distributions (such as RHEL, Alma Linux, Rocky Linux, or Ubuntu). Unselected distributions are excluded from evaluation. For each enabled distro, select the CIS Benchmark version you want to apply.  
  ![Image](../../media/specify-custom-parameters-for-baseline-policy/img-88df9e6de728e403ee3db6580e616049c3744a72.png)

- **For Azure Baselines (Windows or Linux):** These baselines apply uniformly across operating systems and don’t require distro selection. Simply confirm the baseline version under **Basics** and continue.  
  ![Image](../../media/specify-custom-parameters-for-baseline-policy/img-ee20054ef65f2587d2090949b1175dc5f00c0385.png)

### **3. Modify settings**

On the **Modify settings** tab, review and adjust configuration rules for your selected baselines.

- Use the checkbox next to each rule to include or exclude it from evaluation.

- For configurable rules, edit the **Parameter value** field to define your organization’s required state.

![Image](../../media/specify-custom-parameters-for-baseline-policy/img-045f78dbb4cced276113efc11ed26093f3ebaee7.png)

- View per rule Metadata by clicking on a highlighted rule, which will open the context pane showing details such as **Rule ID**, **Description**, **Severity**, and **Compliance Standard**.

![Image](../../media/specify-custom-parameters-for-baseline-policy/img-325b504563492223316abbbfd8aa3c59341a1174.png)

These features are available uniformly for all benchmarks and baselines in Machine Configuration.

#### **Custom Input for CIS Benchmarks for Linux**

To support advanced customization, **CIS Benchmarks for Linux** may use a **structured input format** for some parameter values. This format allows you to define multiple attributes in a single line—for example, specifying both the expected service state and the package name.

**Example format:**

key1=value1 key2=value2 key3=value3

**Example input:**

serviceName=named.service expectedUnitFileState=enabled expectedActiveState=active packageName=bind

This enables fine-grained control, allowing you to model complex configurations that align with your existing Linux environment.

![Image](../../media/specify-custom-parameters-for-baseline-policy/img-da620a40a5b0afb02dc2e6a321b2e3c3fc95aed3.png)

#### **Custom Input for Azure Security Baseline (Windows)**

To achieve similar granularity in applicability of baseline settings, the **Azure Security Baseline for Windows** supports **formatted string input** for complex rule targeting across OS editions and server roles.

Each value uses the format:

WindowsServer\\Year\>\\ServerRole\>:\<Value\>

Separate multiple targets using semicolons “;”.  
A wildcard \* may also be used to apply a rule across all versions or roles (for example, WindowsServer\2022\\:1).

**Example input:**

WindowsServer\2025\DomainController:1;WindowsServer\2025\MemberServer:1;WindowsServer\2022\\:1

This provides precise scoping for your rule application—for example, applying a setting only to *Domain Controllers* on *Windows Server 2025*, or across all roles on *Windows Server 2022*.

![Image](../../media/specify-custom-parameters-for-baseline-policy/img-61888be031b1619545527d02c423351ff1eacb9c.png)

### **4. Review and download**

After completing your changes:

1.  Select the **Review + download** tab.

2.  Review any edited or excluded settings.

![Image](../../media/specify-custom-parameters-for-baseline-policy/img-8214ea961e6a47de263b9fd1a47c1530662ccc74.png)

3.  Click **Download All Baselines** to export your customized configuration as a JSON file.

You can also select **Assign audit policy** to create a policy assignment directly from your customized baseline within the portal.

This JSON artifact defines all active settings for your baseline, making it easy to version, share, or reuse across environments and deployment pipelines.

Next step: **<u>Deploy a Baseline Policy Assignment →</u>**


## Next steps

- Review the converted content for accuracy
- Update any placeholder content
- Add relevant links and references

## References

- (none)