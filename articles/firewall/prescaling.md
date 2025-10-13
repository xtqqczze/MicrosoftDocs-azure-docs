---
title: Azure Firewall prescaling
description: You can enable prescaling to proactively set a minimum and maximum number of firewall capacity units (instances) for predictable performance.
author: sujamiya
ms.service: azure-firewall
services: firewall
ms.topic: concept-article
ms.date: 10/13/2025
ms.author: sujamiya
# Customer intent: As a network security administrator, I want to enable Prescaling on my Azure Firewall, so that I can proactively set a minimum and maximum number of firewall capacity units (instances) for predictable performance during high-traffic events.
---

# Azure Firewall prescaling


## Overview

Azure Firewall supports built-in autoscaling to dynamically adjust capacity based on CPU utilization, throughput, and connection volume. However, for mission-critical workloads or predictable traffic spikes (e.g., Black Friday, migrations), administrators may want greater control to ensure consistent performance.

**Prescaling** allows administrators to proactively set a minimum and maximum number of firewall capacity units (instances). This provides predictable performance while still allowing autoscaling to occur within the defined range.

## Key benefits
With Prescaling, administrators can:
- 	**Pre-provision capacity** for high-traffic events or known traffic spikes.
- 	**Maintain consistent performance** by setting a baseline capacity.
- 	**Observe live capacity count** with the Observed Capacity metric.

## How prescaling works
Administrators can define two new fields in the new autoscaleConfiguration property:

| **Property** | **Description** | **Allowed Range** |
| --- | --- | --- |
| **minCapacity** | The minimum number of capacity units always provisioned | 2 to 50 |
| **maxCapacity** | The maximum number of capacity units firewall can scale to | 2 to 50 |

If minCapacity and maxCapacity are set to the same value, the firewall runs at a fixed instance count with no autoscaling.

Note: The minimum and maximum capacity values must be the same, or their difference must be greater than 1. For example, if minCapacity is set to 5, maxCapacity must be at least 7.

## Configuration options
Prescaling can be configured using Azure portal, Azure PowerShell, ARM templates, or Bicep.

### Portal example
If configuring through Azure Portal, navigate to your Azure Firewall resource and select "Scaling options" under the Settings section. Choose "Prescaling" and set your desired minimum and maximum capacity values. 

:::image type="content" source="media/prescaling/prescaling-portal.png" alt-text="Screenshot of Azure portal showing Azure Firewall prescaling minimum and maximum capacity settings." lightbox="media/prescaling/prescaling-portal.png":::

### PowerShell example
```azurepowershell
New-AzFirewall `
  -Name "MyFirewall" `
  -ResourceGroupName "MyResourceGroup" `
  -Location "centralus" `
  -VirtualNetwork (Get-AzVirtualNetwork -Name "MyVNet" -ResourceGroupName "MyResourceGroup") `
  -PublicIpAddress (Get-AzPublicIpAddress -Name "MyFW-PublicIP" -ResourceGroupName "MyResourceGroup") `
  -MinCapacity 4 `
  -MaxCapacity 10
```
### Bicep Example
For reference, here’s an example configuration using a Bicep template where you can see the new autoscaleConfiguration property: [Azure Firewall Bicep template – Microsoft Docs](https://learn.microsoft.com/azure/templates/microsoft.network/azurefirewalls?pivots=deployment-language-bicep)

## Choosing capacity values
To determine the optimal minCapacity and maxCapacity: 
1.	**Set a reasonable minimum to avoid unnecessary scaling:** Start with a minimum capacity that handles your typical peak traffic comfortably so scaling events are rare under normal conditions.   
2.	**Leave headroom with a higher maxCapacity:** Set maxCapacity higher than your expected peak to handle unexpected surges. Azure Firewall autoscaling will kick in to increase capacity up until your maxCapacity value.  
3.	**Monitor the Observed Capacity metric** to see how often scaling occurs and adjust min/max values as needed. If scaling happens frequently, consider raising minCapacity.
4.	**Add alerts** on the Observed Capacity metric to notify you when scaling events occur, so you can evaluate if adjustments are needed.

## Monitoring
Prescaling introduces new observability:

| **Metric** | **Description** |
| --- | --- |
| **Observed Capacity** | Reports the number of firewall capacity units (instances) currently provisioned and scaled over time. Notes: Updates may be delayed by up to 30 minutes during Preview. |
| **Alerts** | Administrators can set an alert for when there is an autoscaling event, using the Observed Capacity metric. |

## Handling performance issues
If experiencing packet drops or connectivity issues:
- 	**Review Observed Capacity** to assess capacity trends.
- 	**Consider increasing minCapacity** to provide additional capacity support or if frequent upward scales occur
- 	**Use key telemetry metrics** such as Latency Probe, Throughput, and Observed Capacity metrics to optimize scaling strategies.
 
## Billing Information
Prescaling introduces a **Capacity Unit Hour** billing meter. You pay based on the number of capacity units provisioned per hour. 

| **SKU** | **Price per Capacity Unit** |
| --- | --- |
| **Azure Firewall Standard** | $0.07 per capacity unit hour |
| **Azure Firewall Premium** | $0.11 per capacity unit hour |

## Limitations
Keep the following considerations in mind when using Prescaling (Preview):

- **No region-level capacity guarantees**: scaling may fail or be delayed if the region lacks capacity.
- **Fixed instance disables autoscaling** when minCapacity = maxCapacity.
- **Retention of prior settings**: When a firewall has existing autoscaleConfiguration values and a new deployment or configuration change is submitted without the autoscaleConfiguration property (for example, through Bicep, ARM, or template-based updates), the firewall will continue using the previously configured values. This design is intended to prevent accidental loss of settings.
- **Configuration resets on resource changes** deleting/re-creating or migrating the firewall may reset capacity values to defaults.
- **Active scaling/maintenance events**: prescaling changes may fail if the firewall is mid-scale or upgrade. Retry after completion.

## Next steps
- 	Monitor and learn about the firewall Observed Capacity metrics in [Logs and metrics](https://learn.microsoft.com/azure/firewall/monitor-firewall-reference)
- 	Review [Azure Firewall Best Practices](https://learn.microsoft.com/azure/firewall/firewall-best-practices) to optimize deployments.

