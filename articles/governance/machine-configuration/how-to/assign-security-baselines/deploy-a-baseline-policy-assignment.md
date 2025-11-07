---
title: Deploy A Baseline Policy Assignment
description: A security baseline policy assignment enables continuous compliance tracking, with results surfaced in the Azure Portal to validate that your custom configur...
ms.date: 11/07/2025
ms.topic: conceptual
---

## **TOC Entry: Deploy a Security Baseline Policy Assignment**

A security baseline policy assignment enables continuous compliance tracking, with results surfaced in the Azure Portal to validate that your custom configurations are correctly applied across all target Windows and Linux machines. Policy assignments apply to Azure and non-Azure virtual machines (that are [Azure Arc-enabled servers)](https://learn.microsoft.com/en-us/azure/azure-arc/servers/overview), extending security and compliance management across hybrid, multicloud, and edge environments. The following Policy definitions support customization:

- *Linux machines should meet requirements for the Azure compute security baseline*

- *Windows machines should meet requirements for the Azure compute security baseline*

- *\[Preview\]* *Official CIS Security Benchmarks for Linux Workloads*

Assignment of a security baseline policy is managed through [Machine Configuration](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview), which enforces compliance by auditing machine settings against your chosen security baseline.

You can assign baselines via the Azure Portal, Azure CLI, or automate the process in CI/CD pipelines for consistent rollout.

**Note:** Before assigning any security baseline policy, make sure you’ve deployed the Machine Configuration prerequisite initiative. This initiative installs the extension on virtual machines and enables secure communication with a managed identity.

### **Deploy via the Azure Portal**

The portal provides the most direct path to create or test a baseline assignment.

#### **Step 1 — Open Machine Configuration Policies**

1.  Go to **Azure Portal \> Policy \> Machine Configuration**.

2.  Under **Definitions**, choose your desired baseline—for example:

    1.  *\[Preview\]* Official CIS Security Benchmarks for Linux Workloads

    2.  *Azure Security Baseline for Windows*

    3.  *Azure Security Baseline for Linux*

#### **Step 2 — Select and Customize**

1.  Choose **Modify settings** to tailor which benchmarks and versions you want to include.

2.  Review and optionally edit parameters for individual rules.

3.  When satisfied, click **Review + download** to generate your customized settings JSON.

4.  Press **Download All Baselines** to save the file.

Each JSON file encapsulates all selected parameters and metadata.  
Use this file later when creating the assignment.

#### **Step 3 — Create the Assignment**

1.  Select **Create audit Policy Assignment**.

2.  In the page, define:

    1.  **Scope** (subscription or management group)

    2.  **Assignment name** and optional description

3.  Under the **Parameters** tab, locate **Baseline Settings,** you may need to uncheck *“Only show parameters that need input or review”*

> ![Image](../../media/deploy-a-baseline-policy-assignment/img-ac7fbee604f41b62c868a5bb65c0e4db3a063efd.png)

1.  Click **Browse** → Upload the JSON file you downloaded earlier.

2.  Confirm **Effect** = AuditIfNotExists for compliance tracking.

<!-- -->

4.  Review and create.

This upload step passes your custom configuration to the BaselineSettings parameter within the relevant built-in policies.

For full assignment options (scope, remediation, non-compliance messages, managed identities), refer to Assign a policy definition in the Azure portal.

### **Deploy via Azure CLI or CI/CD Pipeline**

For automated policy deployment, you can create the same assignment programmatically using the Policy-as-code SDK.

#### **Step 1 — Prepare your JSON file**

Ensure you have downloaded the baseline settings JSON generated from the portal. Example path:

baselineFile="./CustomizedBaselineSettings.json"

#### **Step 2 — Assign the Policy**

Use the Azure CLI to deploy the assignment:

az policy assignment create \\  
--name "CIS-Linux-Baseline-Custom" \\  
--display-name "CIS Linux Baseline (Customized)" \\  
--policy "/providers/Microsoft.Authorization/policyDefinitions/cis-linux-baseline" \\  
--params @"\$baselineFile" \\  
--scope "/subscriptions/\<subscription-id\>" \\  
--identity

You can find additional examples in Assign policy with Azure CLI.

### **View Existing Security Baseline Assignments**

After deploying your customized baseline, you can verify its status and scope in the **Assignments** tab under **Policy → Machine Configuration** in the Azure Portal.
![Image](../../media/deploy-a-baseline-policy-assignment/img-6c568abe762c9bc5c6174a54f3b93ccae84db8b4.png)  

This view lists all baseline policy assignments, including their policy definition, management group or subscription, and resource group. You can use filters (e.g., by policy name, subscription, or scope) to quickly locate your assignment. Selecting a specific assignment opens its details, where you can review parameter input (such as your imported JSON file), scope, and compliance status once evaluations complete.

**Tip:** The compliance results in this view correspond to the same audit configuration surfaced in Azure Policy Compliance, ARG, and Guest Assignments — helping you validate that your custom baselines are applied correctly across all target machines.


## Next steps

- Review the converted content for accuracy
- Update any placeholder content
- Add relevant links and references

## References

- (none)