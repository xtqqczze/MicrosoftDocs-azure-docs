---
title: Azure Route Server Capacity
titleSuffix: Azure Route Server
description: Learn how to configure capacity for your Azure Route Server based on the number of VMs deployed
author: siddomala
ms.author: siddomala
ms.service: azure-route-server
ms.topic: concept-article
ms.date: 10/31/2025

#CustomerIntent: As an Azure administrator, I want to understand how to configure Route Server's capacity based on the number of VMs I have deployed. 
---

# <a name="capacity"></a>Virtual hub capacity

By default, a Route Server is deployed with a capacity of 2 routing infrastructure units. This supports 4,000 connected VMs deployed in Route Server's virtual network and all peered virtual networks. 

You can specify additional routing infrastructure units to increase Route Server's capacity in increments of 1,000 VMs. This feature gives you the ability to secure upfront capacity without having to wait for the Route Server to scale out when more VMs are needed. The scale unit on which the Route Server is created becomes the minimum capacity. 


When increasing Route Server's capacity, Route Server will continue to support the number of VMs at its current capacity until the scale out is complete. It may take up to 25 minutes for Route Server to scale out to additional routing infrastructure units. 

> [!NOTE]
> Regardless of the virtual hub's capacity, the hub can only accept a maximum of 10,000 routes from its connected resources (virtual networks, branches, other virtual hubs, etc).
>

## Edit Route Server capacity

Adjust Route Server's capacity when you need to support additional virtual machines.

To add additional Route Server capacity, go to the **Configuration** blade under Azure portal, and adjust the number of Routing infrastructure units using the dropdown, then **Save**.

## Autoscaling
The virtual hub router supports autoscaling based on spoke VM utilization. See [Azure Route Server Monitoring](monitor-route-server.md) for how to monitor your Route Server's routing infrastructure units and spoke VM utilization. 

As the spoke VM utilization changes over time, the autoscaling algorithm dynamically adjusts the number of routing infrastructure units. It ensures the Route Server can handle the number of deployed VMs by selecting the greater value between the minimum routing infrastructure units you specify and the units required to support the current number of VMs.

Autoscaling is not instantaneous. For improved infrastructure availability and performance, ensure that your minimum provisioned routing infrastructure units (RIUs) match the requirements of your workloads. Autoscaling won't reduce the provisioned RIUs below this minimum.

### Routing infrastructure unit table

For pricing information, see [Azure Virtual WAN pricing](https://azure.microsoft.com/pricing/details/virtual-wan/).

| Routing infrastructure unit | Number of VMs |
|----------------------------|---------------|
| 2                          | 2,000         |
| 3                          | 3,000         |
| 4                          |  4,000        |
| 5                          |  5,000         |
| 6                          |  6,000         |
| 7                          |  7,000         |
| 8                          | 8,000         |
| 9                          |  9,000         |
| 10                         |  10,000        |
| 11                         | 11                          | 11,000        |
| 12                         | 12                          | 12,000        |
| 13                         | 13                          | 13,000        |
| 14                         | 14                          | 14,000        |
| 15                         | 15                          | 15,000        |
| 16                         | 16                          | 16,000        |
| 17                         | 17                          | 17,000        |
| 18                         | 18                          | 18,000        |
| 19                         | 19                          | 19,000        |
| 20                         | 20                          | 20,000        |
| 21                         | 21                          | 21,000        |
| 22                         | 22                          | 22,000        |
| 23                         | 23                          | 23,000        |
| 24                         | 24                          | 24,000        |
| 25                         | 25                          | 25,000        |
| 26                         | 26                          | 26,000        |
| 27                         | 27                          | 27,000        |
| 28                         | 28                          | 28,000        |
| 29                         | 29                          | 29,000        |
| 30                         | 30                          | 30,000        |
| 31                         | 31                          | 31,000        |
| 32                         | 32                          | 32,000        |
| 33                         | 33                          | 33,000        |
| 34                         | 34                          | 34,000        |
| 35                         | 35                          | 35,000        |
| 36                         | 36                          | 36,000        |
| 37                         | 37                          | 37,000        |
| 38                         | 38                          | 38,000        |
| 39                         | 39                          | 39,000        |
| 40                         | 40                          | 40,000        |
| 41                         | 41                          | 41,000        |
| 42                         | 42                          | 42,000        |
| 43                         | 43                          | 43,000        |
| 44                         | 44                          | 44,000        |
| 45                         | 45                          | 45,000        |
| 46                         | 46                          | 46,000        |
| 47                         | 47                          | 47,000        |
| 48                         | 48                          | 48,000        |
| 49                         | 49                          | 49,000        |
| 50                         | 50                          | 50,000        |


## Next steps

- [Configure routing preference in Azure Route Server](configure-route-server.md#configure-routing-preference)
- [Learn about Azure Route Server support for ExpressRoute and VPN](expressroute-vpn-support.md)
- [Monitor Azure Route Server](monitor-route-server.md)
