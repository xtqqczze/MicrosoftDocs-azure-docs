---
title: Manage IPAM Pool Recommendations for Virtual Networks
description: Discover how to associate virtual networks to IPAM pools efficiently. Use recommendations to manage address spaces and optimize your network setup.
#customer intent: As a network administrator, I want to understand how to use the Pool Association Recommendation Blade so that I can efficiently associate virtual networks with IPAM pools.
author: mbender-ms
ms.author: mbender
ms.reviewer: mbender
ms.date: 11/05/2025
ms.topic: how-to
---

# Manage IPAM Pool Recommendations for Microsoft Azure Virtual Network (Virtual Network)

The Pool Association Recommendation Blade helps you associate Virtual Networks to IPAM pools. It recommends the best pools for unmanaged Virtual Networks and lets you quickly associate them in bulk.

## Step-by-Step Guide

### 1. Access the Recommendation Blade

- Go to the Microsoft Azure Virtual Network Manager for the scope where you want to find pool recommendations.

- Select the IP Address Management dropdown from the left-hand menu, then select Pool Association Recommendation.

### 2. Review Recommendations

- The page displays a table. Each row is an unmanaged virtual network in the scope of the network manager. The ‘Pool Recommendation’ column contains one of the following options:

  - A single pool recommended to contain the entire address space of the vNet

  - Two pools recommended, one to contain the entire IPv4 space, and the second to contain the entire IPv6 space, of the dual-stack vNet

  - No pools recommended and instead a ‘Create Pool’ link to create a pool which can contain the vNet’s space

### 3. Associate Virtual Network

- You can select up to 100 virtual networks to associate in bulk. Check each unmanaged vNet’s selection box individually or select all recommendations at once by checking the box in the table’s header.

- After selecting your desired virtual network, select **Associate** in the top left hand corner. If the association request doesn't overlap with other concurrent requests, it succeeds and displays a success message in your notifications.

### 4. Observe new associations

- The page automatically refreshes when the batch of associations finishes.

- After the refresh, go to the **IP address pools** page to see your pool's updated IP allocation and available IP addresses.

Capabilities

- To change the pool recommendation for a specific unmanaged virtual nework, use the following steps:

  - Select the current pool recommendation you want to change. A side panel opens with other pool association options. Choose one option for each IP version. Select **Save** to apply your changes.

Single stack Virtual Network edit recommendation view:

:::image type="content" source="media/implement-ip-address-management-association-recommendations/image1.png" alt-text="":::

Dual stack Virtual Network edit recommendation view (note the IPv4 and IPv6 tab):

:::image type="content" source="media/implement-ip-address-management-association-recommendations/image2.png" alt-text="":::

- You can filter the recommendations you see by using one or more of the following criteria:

  - Search for a specific Virtual Network

  - Resource group

  - Subscription ID

  - Location

  - Management group

    - At the parent management group level

  - Recommended pools

    - Use this filter to view only unmanaged Virtual Networks that have valid pool recommendations, or those that don't.

### Example

I have the following pools in my network manager:

:::image type="content" source="media/implement-ip-address-management-association-recommendations/image3.png" alt-text="":::

When I open the Pool Recommendation blade:  
:::image type="content" source="media/implement-ip-address-management-association-recommendations/image4.png" alt-text="":::

I see the following recommendations table:

:::image type="content" source="media/implement-ip-address-management-association-recommendations/image5.png" alt-text="":::

My demoDualStackVnet has two pool recommendations, demoIPv4Pool and demoIPv6 pool. If either of these pools didn't exist, then this Virtual Network wouldn't have a recommendation because I wouldn't be able to cover the entire address space of the Virtual Network.

My demoWestVnet, which has the prefix 192.168.0.0/24, is recommended to my demoPool5, which has the space 192.168.0.0/24. It's not recommended to prodPool, with space 192.168.0.0/16, despite being in the same region and the fact that prodPool has space to contain demoWestVnet. The recommendation logic selects the most specific pool possible, which in this case is demoPool5.

I have two Virtual Networks in the same region of the same space, vnet-eastus2euap and privatelink-vnet, both recommended to demoPool4. The recommendation logic doesn't account for potential overlaps in associations, so when I try to associate both recommendations, one fails, and one succeeds, as shown in the following section.

My Virtual Network, prod-avnmipam-eus2-aks-vnet, with prefix 10.1.0.0/16, has no pool recommendation, so its Recommended Pools column value contains a link to create a pool. Although my pool demoPool6 is in the same region and has address space 10.1.0.0/16, it's not recommended to the Virtual Network because all its space is already allocated to another resource. This situation is evident by the 100% IP Allocation in the ‘IP address pools’ page.

If I select all these recommendations and select ‘Associate’ I receive the following notifications:

:::image type="content" source="media/implement-ip-address-management-association-recommendations/image6.png" alt-text="":::

As anticipated, the second pool requesting association to demoPool4 failed because vnet-eastus2euap was already successfully associated, claiming that space. The request for prod-avnmipam-eu2-aks-vnet was skipped because it had no valid pool recommendation.
