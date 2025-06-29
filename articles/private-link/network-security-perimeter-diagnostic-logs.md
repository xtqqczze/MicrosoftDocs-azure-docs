---
title: 'Diagnostic logs for Network Security Perimeter'
titleSuffix: Azure Private Link
description: Learn the options for storing diagnostic logs for Network Security Perimeter and how to enable logging through the Azure portal.
author: mbender-ms
ms.author: mbender
ms.service: azure-private-link
ms.topic: concept-article
ms.date: 05/16/2025
ms.custom: references_regions, ignite-2024
#CustomerIntent: As a network administrator, I want to enable diagnostic logging for Network Security Perimeter, so that I can monitor and analyze the network traffic to and from my resources.
# Customer intent: "As a network administrator, I want to enable and configure diagnostic logging for the Network Security Perimeter, so that I can effectively monitor and analyze access logs for enhanced security oversight."
---

# Diagnostic logs for Network Security Perimeter

In this article, you learn about the diagnostic logs for Network Security Perimeter and how to enable logging. You learn access logs categories used. Then, you discover the options for storing diagnostic logs and how to enable logging through the Azure portal.

[!INCLUDE [network-security-perimeter-preview-message](../../includes/network-security-perimeter-preview-message.md)]

## Access logs categories

Access logs categories for a network security perimeter are based on the results of access rules evaluation. The log categories chosen in the diagnostic settings are sent to the customer chosen storage location. The following are the descriptions for each of the access log categories including the modes in which they're applicable:

| **Log category** | **Description** | **Applicable to Modes** |
| --- | --- | --- |
| **NspPublicInboundPerimeterRulesAllowed** | Inbound access is allowed based on network security perimeter access rules. | Transition/Enforced |
| **NspPublicInboundPerimeterRulesDenied** | Public inbound access denied by network security perimeter. | Enforced |
| **NspPublicOutboundPerimeterRulesAllowed** | Outbound access is allowed based on network security perimeter access rules. | Transition/Enforced |
| **NspPublicOutboundPerimeterRulesDenied** | Public outbound access denied by network security perimeter. | Enforced |
| **NspOutboundAttempt** | Outbound attempt within network security perimeter. | Transition/Enforced |
| **NspIntraPerimeterInboundAllowed** | Inbound access within perimeter is allowed. | Transition/Enforced |
| **NspPublicInboundResourceRulesAllowed** | When network security perimeter rules deny, inbound access is allowed based on PaaS resource rules. | Transition |
| **NspPublicInboundResourceRulesDenied** | When network security perimeter rules deny, inbound access denied by PaaS resource rules. | Transition |
| **NspPublicOutboundResourceRulesAllowed** | When network security perimeter rules deny, outbound access allowed based on PaaS resource rules. | Transition |
| **NspPublicOutboundResourceRulesDenied** | When network security perimeter rules deny, outbound access denied by PaaS resource rules. | Transition |
| **NspPrivateInboundAllowed** | Private endpoint traffic is allowed. | Transition/Enforced |

> [!NOTE]
> The available access modes for a network security perimeter are **Transition** and **Enforced**. The **Transition** mode was previously named **Learning** mode. You may continue to see references to **Learning** mode in some instances. 

## Logging destination options for access logs  

The destinations for storing diagnostic logs for a network security perimeter include services like Log Analytic workspace, Azure Storage account, and Azure Event Hubs. For the full list and details of supported destinations, see [Supported destinations for diagnostic logs](/azure/azure-monitor/essentials/diagnostic-settings).

## Enable logging through the Azure portal

You can enable diagnostic logging for a network security perimeter by using the Azure portal under Diagnostic settings. When adding a diagnostic setting, you can choose the log categories you want to collect and the destination where you want to deliver the logs.

:::image type="content" source="media/network-security-perimeter-diagnostic-logs/network-security-perimeter-diagnostic-settings.png" alt-text="Screenshot of diagnostic settings options for a network security perimeter.":::

> [!NOTE]
> When using Azure Monitor with a network security perimeter, the Log Analytics workspace to be associated with the network security perimeter needs to be located in one of the Azure Monitor supported regions.

> [!Warning]
> The log destinations must be within the same network security perimeter as the PaaS resource to ensure the proper flow of PaaS resource logs. Configuring/already configured Diagnostic Settings for resources not included in the list of [Onboarded private link resources](/azure/private-link/network-security-perimeter-concepts#onboarded-private-link-resources), will result in the cessation of log flow for those resources.

## Next steps

> [!div class="nextstepaction"]
> [Create a network security perimeter in the Azure portal](./create-network-security-perimeter-portal.md)
