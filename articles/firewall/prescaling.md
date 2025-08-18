---
title: Azure Firewall Prescaling (Preview)
description: You can enable Prescaling (Preview) to proactively set a minimum and maximum number of firewall capacity units (instances) for predictable performance.
author: sujamiya
ms.service: azure-firewall
services: firewall
ms.topic: concept-article
ms.date: 08/18/2025
ms.author: sujamiya
# Customer intent: As a network security administrator, I want to enable Prescaling (Preview) on my Azure Firewall, so that I can proactively set a minimum and maximum number of firewall capacity units (instances) for predictable performance during high-traffic events.
---

# Azure Firewall Prescaling (Preview)

> [!IMPORTANT]
> Prescaling is in Preview and subject to change.

## Overview

Azure Firewall supports built-in autoscaling to dynamically adjust capacity based on CPU utilization, throughput, and connection volume. However, for mission-critical workloads or predictable traffic spikes (e.g., Black Friday, migrations), administrators may want greater control to ensure consistent performance.

**Prescaling (Preview)** allows administrators to proactively set a minimum and maximum number of firewall capacity units (instances). This provides predictable performance while still allowing autoscaling to occur within the defined range.

## Key benefits
With Prescaling, administrators can:
- 	**Pre-provision capacity** for high-traffic events or known traffic spikes.
- 	**Maintain consistent performance** by setting a baseline capacity.
- 	**Observe live capacity count** with the Observed Capacity metric.

## How prescaling works
Administrators can define two new properties for the firewall:

| **Property** | **Description** | **Allowed Range** |
| --- | --- | --- |
| **minCapacity** | The minimum number of capacity units always provisioned | 2 to 50 |
| **maxCapacity** | The maximum number of capacity units firewall can scale to | 2 to 50 |

If minCapacity and maxCapacity are set to the same value, the firewall runs at a fixed instance count with no autoscaling.

## Configuration options
Prescaling can be configured using Azure portal, Azure PowerShell, ARM templates, or Bicep.

### Portal example

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

## Choosing capacity values
To determine the optimal minCapacity and maxCapacity: 
1.	**Review usage trends** via the new Observed Capacity metric (historical and real-time instance counts).  
2.	**Set minCapacity near peak demand** to avoid under-provisioning. 
3.	**Set alerts on the Observed Capacity metric** to monitor when scaling occurs. 
4.	**Allow headroom**: choose a higher maxCapacity if future surges are expected. 

## Monitoring
Prescaling introduces new observability:

| **Metric** | **Description** |
| --- | --- |
| **Observed Capacity (Preview)** | Reports the number of firewall capacity units (instances) currently provisioned and scaled over time. Notes: Updates may be delayed by up to 30 minutes during Preview. |
| **Alerts** | Administrators can set an alert for when there is an autoscaling event, using the Observed Capacity metric. |
| **Resource Health Capacity Limit Reached Metric** | In Resource Health, administrators can get alerted if their firewall is reaching their maximum capacity and needs to scale further. |


## Handling performance issues
If experiencing packet drops or connectivity issues:
- 	**Review Observed Capacity** to assess capacity trends.
- 	**Each additional capacity unit** adds roughly 1.6 Gbps (approximate)
- 	**Consider increasing minCapacity** to provide additional capacity support or if frequent upward scales occur
- 	**Use key telemetry metrics** such as Latency Probe, Throughput, and Observed Capacity metrics to optimize scaling strategies.

## Limitations
Keep the following considerations in mind when using Prescaling (Preview):

- **No region-level capacity guarantees**: scaling may fail or be delayed if the region lacks capacity.
- **Fixed instance disables autoscaling** when minCapacity = maxCapacity.
- **Retention of prior settings**: When a firewall has existing autoscaleConfiguration values and a new deployment or configuration change is submitted without the autoscaleConfiguration property (for example, through Bicep, ARM, or template-based updates), the firewall will continue using the previously configured values. This design is intended to prevent accidental loss of settings.
- **Configuration resets on resource changes** deleting/re-creating or migrating the firewall may reset capacity values to defaults.
- **Active scaling/maintenance events**: prescaling changes may fail if the firewall is mid-scale or upgrade. Retry after completion.

## Next steps
- 	Monitor firewall health in [Logs and metrics](https://learn.microsoft.com/en-us/azure/firewall/monitor-firewall-reference)
- 	Review [Azure Firewall Best Practices](https://learn.microsoft.com/en-us/azure/firewall/firewall-best-practices) to optimize deployments.

