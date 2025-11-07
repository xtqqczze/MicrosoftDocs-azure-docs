---
title: Discover And Assign Built In Machine Configuration Policies
description: Azure Policy provides a unified framework for defining and enforcing governance rules across your Azure resources.
ms.date: 11/07/2025
ms.topic: conceptual
---

# **Discover and Assign Built-In Machine Configuration Policies**

Azure Policy provides a unified framework for defining and enforcing governance rules across your Azure resources.  
Machine Configuration extends this capability to the **guest OS level**, allowing you to audit and enforce configurations *inside* Windows and Linux machines—helping ensure your workloads remain secure and compliant with internal and industry standards.

This section explains how to discover built-in Machine Configuration policies, understand what they do, and assign them to your environment. We’ll also walk through an example—using the **Audit Windows Time Zone** policy—to illustrate how parameters are used to tailor configurations to your organization’s needs.

## **1. Discover Built-In Machine Configuration Policies**

Azure Policy definitions describe *what* is being evaluated and *how* compliance is determined. Built-in definitions are maintained by Microsoft and automatically updated to align with current security and compliance standards.

To view and explore these built-in policies:

1.  Navigate to **Azure Portal → Policy → Definitions**.

2.  In the left-hand navigation, select **Definitions** under the *Authoring* section.

3.  Open the **Category** filter and select **Guest Configuration** and **Built-in** on Policy Type to display all built-in policies related to OS auditing and compliance.

![Image](../media/discover-and-assign-built-in-machine-configuration-policies/img-3f3ce788ba90429512e3fee4e20276cb966e4538.png)

4.  Browse the list to review available definitions, such as:

    1.  *Audit Linux machines that have the specified applications installed*

    2.  *Audit Windows machines that are not set to the specified time zone*

    3.  *Windows machines should meet requirements for the Azure compute security baseline*

5.  Click any policy name to open its details page. You can inspect:

    1.  The JSON definition

    2.  Available parameters and versions

    3.  Metadata such as category, mode, and required providers

![Image](../media/discover-and-assign-built-in-machine-configuration-policies/img-2ad297ad1246e4c27f777c98825b67a1bafda438.png)

**Read more:** Understand Azure Policy definitions and initiatives

## **2. Assign a Built-In Machine Configuration Policy**

A **policy assignment** determines *where* and *how* a policy definition is applied—whether to a management group, subscription, or resource group.  
When you assign a Machine Configuration policy, Azure evaluates all in-scope machines and reports compliance directly in the **Azure Policy → Compliance** blade.

### **Example: Assigning the “Audit Windows Time Zone” Policy**

Let’s use one of the built-in Machine Configuration policies—**Audit Windows machines that are not set to the specified time zone**—as an example.

1.  From the **Policy Definitions** page, select  
    **Audit Windows machines that are not set to the specified time zone**.

2.  Click **Assign Policy** at the top of the page.

3.  In the **Basics** tab:

    1.  Choose the **Scope** (subscription or management group).

    2.  Confirm that **Machine Configuration prerequisites** are deployed. (A link to deploy prerequisites appears automatically if not.)

    3.  Optionally specify exclusions if certain resources shouldn’t be evaluated.

![Image](../media/discover-and-assign-built-in-machine-configuration-policies/img-85d4e71787ec57907ee20ed9d74e68b576f1f36f.png)

4.  In the **Parameters** tab:

    1.  Set **Include Arc connected servers** to true if your environment includes Arc-enabled machines.

    2.  Choose the desired **Time zone** (for example, “Pacific Time (US & Canada)”).

![Image](../media/discover-and-assign-built-in-machine-configuration-policies/img-2b911c2eff35ab65d1c208c98d84a30c23fb4d3b.png)

5.  Review your configuration under **Review + create**, then click **Create**.

Once assigned, the policy will automatically begin evaluating machines within scope. Compliance results will surface in the **Policy → Compliance** view, where you can drill down to specific resources or export results.

*Note:* The same process applies to other built-in Machine Configuration policies—such as those auditing Linux baselines, password settings, or required applications.  
Parameters vary by definition and allow you to customize the audit scope without creating new policies.

**Read more:** [Assign a policy definition to your resources](https://learn.microsoft.com/en-us/azure/governance/policy/assign-policy-portal)

## **3. Programmatic Access and Automation**

While this guide focuses on portal-based workflows, you can also assign and manage Machine Configuration policies programmatically through CLI, PowerShell, or REST API.

| **Interface** | **Command/Reference** | **Documentation** |
|----|----|----|
| **Azure CLI** | az policy definition list and az policy assignment create | [Assign policy via Azure CLI](https://learn.microsoft.com/en-us/azure/governance/policy/assign-policy-azurecli) |
| **PowerShell** | Get-AzPolicyDefinition and New-AzPolicyAssignment | [Assign policy via PowerShell](https://learn.microsoft.com/en-us/powershell/module/az.policyinsights) |
| **REST API** | Microsoft.Authorization/policyAssignments | Azure Policy REST API Reference |
| **Guest Configuration** | az guestconfig assignment list | [Guest Configuration REST API Reference](https://learn.microsoft.com/en-us/rest/api/guestconfiguration/) |
| **Azure Resource Graph** | Query guestconfigurationresources table for compliance results | [Query Guest Configuration with Resource Graph](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data) |

## **Next Steps**

After assigning your policy, you can:

- **View compliance** in Azure Policy’s Compliance view.

- **Drill down to machine-level evidence** through the Guest Assignments page.

- **Query compliance at scale** using Azure Resource Graph.

Continue to: *\[View Compliance Results across Policy, ARG, and Guest Assignments\]* (next section)


## Next steps

- Review the converted content for accuracy
- Update any placeholder content
- Add relevant links and references

## References

- (none)