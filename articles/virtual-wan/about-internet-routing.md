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
|Forced Tunnel|Forwarded via **0.0.0.0/0 route learnt** from on-premises, from a Network Virtual Appliance (NVA) or a Virtual WAN static route after inspection. If no 0.0.0.0/0 route is learnt from on-premises, a NVA or a static route on a Virtual Network connection, forward directly to Internet after inspection. |

## Availability

The following table shows the availability status of securing Internet access with **direct access** by configuring Internet routing policy. 

| Security solution |Status|
|--|--|
|Azure Firewall |Generally Available in Azure Public and Azure Government Clouds.|
|Firewall NVA in the Virtual WAN hub| Generally Avaialble in Azure Public Cloud |
| Software-as-a-service in the Virtual WAN Hub| Generally Available in Azure Public Cloud|

The following table shows the availability status of securing Internet access with **forced tunneling** by configuring private routing policy.

 Security solution |Status|
|--|--|
|Azure Firewall |Generally Available in Azure Public and Azure Government Clouds.|
|Firewall NVA in the Virtual WAN hub| Public Preview in Azure Public Cloud |
| Software-as-a-service in the Virtual WAN Hub| Public Preview in Azure Public Cloud|

### Known Limitations

* **Forced Tunnel configuration**:
    * Forced tunnel requires a specific routing intent configuration. Non-routing intent deployments do **not** support forced tunnel internet access.
    * Destination-NAT (DNAT) for security solutions deployed in the Virtual WAN hub is **not supported** for Virtual WAN hubs that are configured with Forced Tunnel internet routing mode. The incoming connection for DNAT traffic originates from the Internet. However, forced tunnel mode forces return traffic via on-premises or a NVA. This routing pattern results in asymmetric routing. 
    * Traffic from on-premises destined for the public IP address of an Azure storage account deployed in the same Azure region as the Virtual WAN hub bypasses security solution in the hub. For more details on this limitation and potential mitigations, see [VIrtual WAN known issues](whats-new.md#knownissues).
    * On-premises **can't** advertise forced tunnel routes more specific that 0.0.0.0/0. Advertising more specifc rotues like 0.0.0.0/1 and 128.0.0.0/1 from on-premises may blackhole in management traffic for Azure Firewall or NVAs integrated in the Virtual Hub.
    * Virtual Network connection **bypass next hop setting** is ignored for deployments using static routes on Virtual Network connections with **propagate static route** enabled. Traffic destined for the Virtual Network connection will be inspected by the security appliance in the hub and  routed directly to the destination IP in the spoke Virtual Network, bypassing the next hop IP configured in the static route.  
* **Direct Access**:
    * Traffic from on-premises destined for the public IP address of an Azure storage account deployed in the same Azure region as the Virtual WAN hub bypasses security solution in the hub. For more details on this limitation and potential mitigations, see [VIrtual WAN known issues](whats-new.md#knownissues).
* **Portal issues**:
  * When a hub is configured in Forced Tunnel mode, Azure Firewall Manager does not properly display Internet Traffic as **secured** for connections. Azure Firewall Manager does not allow you to change the secured status of connections either. To modify the **secured** status, change the **enable internet security** or **propagate default route** setting on the connection.  

### Direct Access

When Virtual WAN is configured to route traffic directly to the Internet, Virtual WAN applies a static default 0.0.0.0/0 route on the security solution with next hop Internet.

:::image type="content" source="./media/about-internet-routing/direct-access.png" alt-text="Screenshot that shows direct access." lightbox="./media/about-internet-routing/direct-access.png":::

This static default route has **higher priority** than any default route learnt from on-premises, from an NVA or configured as a static route on a spoke Virtual Network. However, more specific prefixes advertised from on-premises (0.0.0.0/1 and 128.0.0.0/1) are considered higher priority for Internet traffic due to longest-prefix match.

### Effective routes

If you have private routing policies configured on your Virtual WAN hub, you can view the effective routes on the next hop security solution. For deployments configured with direct access, effective routes on the next hop security solution will contain the  **0.0.0.0/0** route with next hop **Internet**. 

## Forced Tunnel

When Virtual WAN is configured in forced tunnel mode, the highest priority default route selected by the Virtual WAN hub based on [hub routing preference](about-virtual-hub-routing-preference.md) is used by the security solution to forward internet traffic. 

:::image type="content" source="./media/about-internet-routing/force-tunnel.png" alt-text="Screenshot that shows forced tunnel." lightbox="./media/about-internet-routing/force-tunnel.png":::

However, there's an implicit route that allows the security solution to forward traffic directly to the internet. This implicit route is treated with the lowest priority. If there are no default routes learnt dynamically from on-premises or configured as a static route on Virtual Network connections, Internet traffic is routed directly to the Internet via the implicit route. For traffic routed via the implicit route, the source IP address of the internet-bound packet is one of the public IP addresses assigned to your security solution.

### Supported sources of the default route

>[!NOTE]
>  The 0.0.0.0/0 does **not** propagate across Virtual Hubs. This means a local connection must be used for Virtual Hubs configured for Internet access via forced tunnel.

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
| Direct Access| Optional| None required | Required|
| Forced Tunnel| Required | 0.0.0.0/0| No |

### Configuration steps in Routing Intent Portal

>[!NOTE]
> Azure Portal perfoms validations to ensure deployments are either in forced tunnel mode or direct access mode. This means that if forced tunnel mode is enabled, you won't be able to add an Internet policy directly. To migrate from forced tunnel mode to direct access mode,execute the following steps in order:  remove the 0.0.0.0/0 static route from additional prefixes,  enable internet policy and save.

The following section describes how to configure routing intent to configure **forced tunnel** and **direct access** using Virtual WAN routing intent and policies Azure Portal. These steps apply to  Azure Firewall, Network Virtual Appliances or software-as-a-service solutions deployed in the Virtual WAN hub.

1. Navigate to your Virtual Hub that is deployed with a security solution.
1. Under **Routing**, select **Routing Intent and Routing Policies**.

#### Forced tunnel

1. Select your preferred  security solution as the next hop resource for **Private traffic**. Do **not** select anything for **Internet traffic**.
:::image type="content" source="./media/about-internet-routing/routing-intent-select-firewall.png" alt-text="Screenshot that shows how to select firewall." lightbox="./media/about-internet-routing/routing-intent-select-firewall.png":::
1. Add the 0.0.0.0/0 route to **additional prefixes**.
:::image type="content" source="./media/about-internet-routing/routing-intent-add-default-route.png" alt-text="Screenshot that shows how to add default route to additional prefixes." lightbox="./media/about-internet-routing/routing-intent-add-default-route.png":::
1. **Save** your configuration.

#### Direct access

1. Select your preferred  security solution as the next hop resource for **Internet traffic**. Optionally, select your preferred security solution as the next hop resource for **Private traffic**.
:::image type="content" source="./media/about-internet-routing/routing-intent-select-both-policy.png" alt-text="Screenshot that shows how to select both policy." lightbox="./media/about-internet-routing/routing-intent-select-both-policy.png":::
1. **Save** your configuration.

### Configuration steps in Azure Firewall Manager

>[!NOTE]
> Azure Portal perfoms validations to ensure deployments are either in forced tunnel mode or direct access mode. This means that if forced tunnel mode is enabled, you won't be able to add an Internet policy directly. To migrate from forced tunnel mode to direct access mode,execute the following steps in order:  remove the 0.0.0.0/0 static route from additional prefixes, enable internet policy and save.

The following section describes how to configure routing intent to configure **forced tunnel** and **direct access** using Virtual WAN routing intent and policies Azure Portal. These steps apply to Azure Firewall in the Virtual WAN hub. 

1. Navigate to your Virtual WAN hub.
1. Select **Azure Firewall and Firewall Manager** under **Security** and select your Virtual WAN hub.
1. Select **Security configuration** under **Settings**. 

#### Forced tunnel

1. Set **Private Traffic** to **Send via Azure Firewall** and **Inter-hub** to enabled. 
1. Add the 0.0.0.0/0 route to **additional prefixes**.
1. **Save** your configruation.

#### Direct access

1. Set **Internet Traffic** to **Azure Firewall** and **Inter-hub** to enabled. Optionally, set **Private Traffic** to **Send via Azure Firewall** and **Inter-hub** to enabled. 
1. **Save** your configruation.

### Other configuration methodologies (Terraform, CLI, PowerShell, REST, Bicep)

The following JSON configurations represent sample Azure resource manager resource representations of Virtual WAN routing constructs configured for direct access or forced tunnel modes. These JSON configurations can be customized to your specific environment/configuration and be used to derive the correct Terraform, CLI, Powershell or Bicep configuration.

#### Forced tunnel

The following example JSON shows a sample routing intent resource configured with private routing policy.

```json
{
  "name": "<>",
  "id": "/subscriptions/<>/resourceGroups/<>/providers/Microsoft.Network/virtualHubs/<>/routingIntent/<>",
  "properties": {
    "routingPolicies": [
      {
        "name": "PrivateTraffic",
        "destinations": [
          "PrivateTraffic"
        ],
        "nextHop": "<security solution resource URI>"
      }
    ]
  },
  "type": "Microsoft.Network/virtualHubs/routingIntent"
}
```

The following example JSON shows a sample default route table configuration with private routing policy routes and additional prefix (0.0.0.0/0) added in the default route table.

```json
{
  "name": "defaultRouteTable",
  "id": "/subscriptions/<subscriptionID>/resourceGroups/<>/providers/Microsoft.Network/virtualHubs/<>/hubRouteTables/defaultRouteTable",
  "properties": {
    "routes": [
      {
        "name": "_policy_PrivateTraffic",
        "destinationType": "CIDR",
        "destinations": [
          "10.0.0.0/8",
          "172.16.0.0/12",
          "192.168.0.0/16"
        ],
        "nextHopType": "ResourceId",
        "nextHop": "<security solution resource URI>"
      },
      {
        "name": "private_traffic",
        "destinationType": "CIDR",
        "destinations": [
          "0.0.0.0/0"
        ],
        "nextHopType": "ResourceId",
        "nextHop": "<security solution resource URI>"
      }
    ],
    "labels": [
      "default"
    ]
  },
  "type": "Microsoft.Network/virtualHubs/hubRouteTables"
}
```

#### Direct access

The following example JSON shows a sample routing intent resource configured with both internet and private routing policy.

```json
{
  "name": "<>",
  "id": "/subscriptions/<>/resourceGroups/<>/providers/Microsoft.Network/virtualHubs/<>/routingIntent/<>",
  "properties": {
    "routingPolicies": [
      {
        "name": "PrivateTraffic",
        "destinations": [
          "PrivateTraffic"
        ],
        "nextHop": "<security solution resource URI>"
      },
      {
        "name": "PublicTraffic",
        "destinations": [
          "Internet"
        ],
        "nextHop": "<security solution resource URI>"
      }
    ]
  },
  "type": "Microsoft.Network/virtualHubs/routingIntent"
}
```

The following example JSON shows a sample default route table configuration with both private and internet routing policy routes.

```json
{
  "name": "defaultRouteTable",
  "id": "/subscriptions/<subscriptionID>/resourceGroups/<>/providers/Microsoft.Network/virtualHubs/<>/hubRouteTables/defaultRouteTable",
  "properties": {
    "routes": [
      {
        "name": "_policy_PrivateTraffic",
        "destinationType": "CIDR",
        "destinations": [
          "10.0.0.0/8",
          "172.16.0.0/12",
          "192.168.0.0/16"
        ],
        "nextHopType": "ResourceId",
        "nextHop": "<security solution resource URI>"
      },
      {
        "name": "_policy_PublicTraffic",
        "destinationType": "CIDR",
        "destinations": [
          "0.0.0.0/0"
        ],
        "nextHopType": "ResourceId",
        "nextHop": "<security solution resource URI>"
      }
    ],
    "labels": [
      "default"
    ]
  },
  "type": "Microsoft.Network/virtualHubs/hubRouteTables"
}
```


## Ensure connections learn the default route (0.0.0.0/0)

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
    * **SNAT internet traffic to Firewall instance private IP**: turn SNAT **on** for non-private traffic ranges. 

**SaaS solution or Integrated NVAs**:

The following recommendations are generic baseline recommendations. Contact your provider for complete guidance.

* Reference provider documentation to ensure:
    * Internal route table in NVA or SaaS solution has 0.0.0.0/0 properly configured to forward Internet traffic out of the internal interface.
    * Internal route table configuration ensures management traffic and VPN/SDWAN traffic are routed out the external Interace.
    * Configure SNAT appropriately depending on whether or not the original source IP of traffic needs to be preserved.






