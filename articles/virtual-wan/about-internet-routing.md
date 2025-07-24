---
title: 'Securing Internet access with routing intent'
titleSuffix: Azure Virtual WAN
description: Learn how to secure internet traffic with routing intent.
author: wtnlee
ms.service: azure-virtual-wan
ms.topic: how-to
ms.date: 03/26/2025
ms.author: wellee
---

# Securing Internet access with routing intent

The following document describes different routing patterns you can use with Virtual WAN routing intent to inspect Internet-bound traffic.

## Background

Virtual WAN routing intent allows you to send Private and Internet traffic to security solutions deployed in the Virtual WAN hub.

The following table summarizes the two different modes that define how Virtual WAN inspects and routes internet-bound traffic:

|Mode| Internet traffic |
|--|--|
|Direct Access|Forwarded **directly** to the Internet after inspection. |
|Forced Tunnel|Forwarded via **0.0.0.0/0 route learnt** from on-premises, from a Network Virtual Appliance (NVA) or a Virtual WAN static route after inspection. If no 0.0.0.0/0 route exists, forward directly to Internet after inspection. |

### Known Limitations

* Destination-NAT (DNAT) for security solutions deployed in the Virtual WAN hub is **not supported** for Virtual WAN hubs that are configured with Forced Tunnel internet routing mode. The incoming connection for DNAT traffic originates from the Internet and forced tunnel mode forces return traffic via on-premises or a NVA. This routing pattern results in asymmetric routing. 
* Traffic from on-premises destined for the public IP address of an Azure storage account deployed in the same Azure region as the Virtual WAN hub bypasses security solution in the hub. For more details on this limitation and potential mitigations, see [VIrtual WAN known issues](whats-new.md#known-issues). 

### Direct Access

When Virtual WAN is configured to route traffic directly to the Internet, Virtual WAN applies a static default 0.0.0.0/0 route on the security solution. 

:::image type="content" source="./media/about-internet-routing/direct-access.png" alt-text="Screenshot that shows direct access." lightbox="./media/about-internet-routing/direct-access.png":::

This static default route has **higher priority** than any default route learnt from on-premises, from an NVA or configured as a static route on a spoke Virtual Network. However, more specific prefixes advertised from on-premises (0.0.0.0/1 and 128.0.0.0/1) are considered higher priority for Internet traffic due to longest-prefix match.

### Effective routes

If you have private routing policies configured on your Virtual WAN hub, you can view the effective routes on the next hop security solution. For deployments configured with direct access, effective routes on the next hop security solution will contain the  **0.0.0.0/0** route with next hop **Internet**. 

## Forced Tunnel

When Virtual WAN is configured in forced tunnel mode, the highest priority default route selected by the Virtual WAN hub based on [hub routing preference](about-virtual-hub-routing-preference.md) is used by the security solution to forward internet traffic. 

:::image type="content" source="./media/about-internet-routing/force-tunnel.png" alt-text="Screenshot that shows forced tunnel." lightbox="./media/about-internet-routing/force-tunnel.png":::

However, there's an implicit route that allows the security solution to forward traffic directly to the internet. This implicit route is treated with the lowest priority.

If there are no default routes learnt dynamically from on-premises or configured as a static route on Virtual Network connections, Internet traffic is routed directly to the Internet.

### Supported sources of the default route

>[!NOTE]
>  The 0.0.0.0/0 does **not** propagate across Virtual Hubs. This means a local connection must be used for forced tunnel.

The default route can be learnt from the following sources.

* ExpressRoute
* Site-to-site VPN (dynamic or static)
* NVA in the hub
* NVA in the spoke
* Static route on a Virtual Network connection (with propagate static route set to **ON**)

The default route **can't be configured** in the following way:
* Static route in the defaultRouteTable with next hop Virtual Network connection 

### Effective Routes

For deployments configured with forced tunnel, effective routes on the next hop security solution will contain the  **0.0.0.0/0** route with the next hop as the selected default route learnt from on-premises or configured as a static route on a Virtual Network connection.

## Configurations
The following sections describe the necessary configurations to route internet traffic in direct access or forced tunnel mode.

## Virtual WAN routing configuration

>[!NOTE]
> Forced tunnel Internet traffic routing mode is available **only** for Virtual WAN hubs utilizing routing intent with private routing policies. Hubs that do **not** use routing intent or use internet routing policies can only utilize direct access mode.

The following table summarizes the configuration needed to route traffic using the two different  Internet traffic routing modes.

|Mode| Private Routing Policy| Additional Prefixes| Internet Routing Policy |
|--|--|--|--|
| Direct Access| Optional| None required | Yes|
| Forced Tunnel| Yes| 0.0.0.0/0| No|

##  Connection-level configurations

For connections that need Internet access via Virtual WAN, ensure the **Enable internet security** or **propagate default route** is set to **true**. This configuration instructs Virtual WAN to advertise the default route to that connection.

## Security solution configurations

The following section describes the differences in security solution configuration for direct access and forced tunnel routing modes.

### Direct Access

The following section describes configuration considerations needed to ensure security solutions **in the Virtual WAN hub** can forward packets to the Internet directly.

**Azure Firewall**:
* Ensure [Source-NAT (SNAT)](../firewall/snat-private-range.md) is  **on** for all non-private network traffic configurations.
* Avoid SNAT port exhaustion by ensuring sufficient Public IP addresses are allocated to your Azure Firewall deployment.

**SaaS solution or Integrated NVAs**:

The following recommendations are generic baseline recommendations. Contact your provider for complete guidance.

* Reference provider documentation to ensure:
    * Internal route table in NVA or SaaS solution has 0.0.0.0/0 properly configured to forward internet traffic out of the external interface.
    * SNAT is configured for the NVA or SaaS solutions for all non-prvate network traffic configurations.
*  Ensure sufficient Public IP addresses are allocated to your [NVA](how-to-network-virtual-appliance-add-ip-configurations.md) or SaaS deployment to avoid SNAT port exhaustion.

### Forced tunnel

The following section describe configuration considerations needed to ensure security solutions **in the Virtual WAN hub**  can forward internet-bound packets to on-premises or an NVA that is advertising the 0.0.0.0/0 route to Virtual WAN.

**Azure Firewall**:
* Configure [Source-NAT (SNAT)](../firewall/snat-private-range.md). 
    * **Preserve original source IP of Internet traffic**: turn SNAT  **off** for all traffic configurations. 
    * **SNAT to Firewall instance private IP**: turn SNAT **on** for non-private traffic ranges. 

**SaaS solution or Integrated NVAs**:

The following recommendations are generic baseline recommendations. Contact your provider for complete guidance.

* Reference provider documentation to ensure:
    * Internal route table in NVA or SaaS solution has 0.0.0.0/0 properly configured to forward Internet traffic out of the internal interface.
    * Internal route table configuration ensures management traffic and VPN/SDWAN traffic are routed out the external Interace.
    * Configure SNAT appropriately depending on whether or not the original source IP of traffic needs to be preserved.






