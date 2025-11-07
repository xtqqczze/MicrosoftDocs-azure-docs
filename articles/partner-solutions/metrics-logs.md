---
title: Azure Native Integrations monitoring overview
description: "Overview of telemetry (metrics, resource logs, subscription activity, Microsoft Entra) for Azure Native Integrations and key operational considerations."
author: GitHub Copilot
ms.author: azteam-ps
ms.service: Azure Monitor
ms.topic: overview
ms.date: 11/07/2025

#customer intent: As a cloud operator, I want to understand what telemetry partner integrations collect so that I can plan monitoring and governance.

---

## Monitoring Azure Native Integrations

Monitoring and observability are essential for managing modern cloud environments. Azure integrates with leading partner solutions to provide comprehensive metrics and logs collection. These integrations enable centralized visibility, actionable insights, and streamlined troubleshooting across your Azure resources. 

## What Data Is Collected?

| Feature | Datadog | Dynatrace | New Relic | Elastic |
|---|---|---|---|---|
| Metrics Collection | Yes | Yes | Yes | No |
| Logs Collection | Yes | Yes | Yes | Yes |
| Tag-based Filtering | Yes (metrics/logs) | Yes (metrics/logs) | Yes (metrics/logs) | Yes (logs only) |
| Managed Identity for Metrics | Yes | Yes | Yes | Not mentioned |
| Microsoft Entra Logs | Yes | Yes | Yes | Yes |
| Setup Guides Linked | Yes | Yes | Yes | Yes |

### Metrics

Quantitative data reflecting the performance and health of your Azure resources.

For metrics, a system managed identity is created and assigned the Monitoring Reader role, which is required for data collection. Removing this identity or role assignment will prevent metric collection.

You can enable your partner resource to collect metrics for all Azure resources within any linked subscriptions.

For a complete list of available platform metrics, see Azure Monitor metrics index.
Optionally, you can limit metric collection for Azure VMs and App Service plans by attaching Azure tags to your resources.

For metrics, a system managed identity is created automatically and associated with the resource on Azure. The Monitoring Reader role is provided to the system managed identity as part of the setup. This role gives the partner service the ability to pull metrics for resources in your subscription from Azure Monitor.

> [!WARNING]
> Removing the system managed identity or the Monitoring Reader role assignment will prevent the partner from collecting metrics from your Azure resources.

### Tag rules for sending metrics

Virtual machines, Virtual Machine Scale Sets, and App Service plans with include tags send metrics to the partner, and those with exclude tags don't send metrics.
 Note
If there's a conflict between inclusion and exclusion rules, exclusion takes priority. There is no option to limit metric collection for other resource types.

For example, if you configure a tag rule in which only virtual machines, Virtual Machine Scale Sets, and App Service plans tagged with True are included, only resources with this tag will send metrics to the partner. All other VMs, Virtual Machine Scale Sets, and App Service plans will be excluded from metrics collection.

## Logs

Logs provide detailed records of activity and events within your Azure environment. These logs provide valuable insights for monitoring, troubleshooting, and auditing. With Azure Native Integrations, you can collect and forward various types of logs from your Azure resources directly to the partner service based on configurable tag-based rules. For a complete list of supported log categories, see [Supported Resource log categories for Azure Monitor](/azure/azure-monitor/reference/logs-index).

Logs for all defined sources are sent to partner resources based on the inclusion/exclusion tags. By default, logs are collected for all resources.

The tag rules basically match the tags that are available on Azure resources in your subscription. If you select Include and add tags that match resources for your subscription, they will be in scope for monitoring. By default, platform resource logs are enabled.

Tag rules for sending logs

- Azure resources with include tags send logs.
- Azure resources with exclude tags don't send logs.

> [!NOTE]
> If there's a conflict between inclusion and exclusion rules, exclusion takes priority.
Example: If you configure a tag rule in which resources tagged with Environment = Production are included, all Azure resources (of any type) with this tag will send logs to the partner service. Resources without this tag or with conflicting exclude tags won't send logs.

### Azure activity logs

Azure activity logs, or subscription-level logs, capture operations performed at the [control plane](/azure/azure-resource-manager/management/control-plane-and-data-plane) of your Azure subscription. These logs provide a comprehensive record of management events, such as resource creation, modification, and deletion and service health notifications. By analyzing subscription-level logs, you can answer important questions like who made changes, what actions (PUT, POST, DELETE) were taken, and when they occurred. This information is essential for auditing, governance, and understanding overall activity within your Azure environment. It helps you maintain security, track changes, and ensure compliance across your cloud resources. There's a single activity log for each Azure subscription.

### Azure resource logs

Azure resource logs capture detailed operations performed at the [data plane](/azure/azure-resource-manager/management/control-plane-and-data-plane) of individual Azure resources. These logs record interactions that are specific to each resource, such as reading data from a storage account, querying a database, or accessing secrets in Azure Key Vault. The content and structure of resource logs vary depending on the Azure service and resource type. By collecting and analyzing resource logs, you gain deeper visibility into application behavior and can troubleshoot issues at the resource level and monitor how your services are being used. This level of insight is valuable for performance optimization, security monitoring, and ensuring the reliability of your Azure workloads.

### Microsoft Entra Logs

Microsoft Entra logs provide detailed insights into identity and access management activities within your Azure environment. These logs help you monitor user sign-ins, authentication attempts, and changes to users, groups, or roles. This monitoring enables you to track access patterns, detect suspicious activity, and maintain compliance with security policies.
The Microsoft Entra admin center offers three main types of activity logs:

- [Sign-in logs](/entra/identity/monitoring-health/concept-sign-ins): Track user sign-ins and resource usage.
- [Audit logs](/entra/identity/monitoring-health/concept-audit-logs): Record changes to your tenant, such as user and group management or updates to resources.
- [Provisioning logs](/entra/identity/monitoring-health/concept-provisioning-logs): Capture activities performed by the provisioning service, like creating groups in external systems or importing users.

For instructions on how to send Microsoft Entra ID logs to a partner, see [Integrate Microsoft Entra logs with Azure Monitor logs](/entra/identity/monitoring-health/howto-integrate-activity-logs-with-azure-monitor-logs).


## Enabling and Managing Integration

Each service provides step-by-step instructions for setup and management.