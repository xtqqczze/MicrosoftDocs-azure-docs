---
title: Azure Storage Mover Private Networking Requirements
description: Learn about the prerequisites for using Azure Storage Mover with private networking.
author: stevenmatthew
ms.author: shaas
ms.service: azure-storage-mover
ms.topic: conceptual
ms.date: 10/08/2025
---

# Storage Mover Private Networking Requirements

Azure Storage Mover is a service designed to facilitate seamless data migration to Azure Storage accounts. For organizations prioritizing security and compliance, integrating Storage Mover with Azure Private Networking ensures that sensitive data and credentials remain protected throughout the migration process. 

Azure Storage Mover communicates over HTTPS, and in addition to operating over the public internet, it supports Azure-recommended private network configurations. These configurations typically begin with the creation of an Azure virtual network, which serves as the foundation for secure connectivity. For more information about Azure virtual networks, see [What is an Azure virtual network?](../virtual-network/virtual-networks-overview.md).

To link on-premises infrastructure to Azure, organizations need to enable hybrid connectivity. This hybrid link can be created using a Site-to-Site VPN via Azure VPN Gateway, Azure ExpressRoute, or an Azure Virtual WAN. Each option establishes private tunnels that enable secure access to Azure resources. For more information about Azure VPN Gateway, ExpressRoute, or Virtual WAN, see [What is an Azure VPN Gateway?](../vpn-gateway/vpn-gateway-about-vpngateways.md), [What is Azure ExpressRoute?](../expressroute/expressroute-introduction.md), or [What is Azure Virtual WAN?](../virtual-wan/virtual-wan-about.md).

Private Endpoints also play a critical role in this approach, allowing services such as Azure Storage Accounts and Azure Key Vaults to be accessed privately. These endpoints reside within a subnet of the virtual network and require domain name system (DNS) records to correctly resolve private IP addresses. During setup, users can configure a Private DNS Zone to manage these records. For more information about Private Endpoints, see [What is an Azure Private Endpoint?](../private-link/private-endpoint-overview.md).

This article outlines the key requirements and configuration steps necessary to deploy Azure Storage Mover in a private network environment.

## Required Components for Private Networking

Within the Storage Mover hierarchy, a storage mover resource is the top-level service resource that you deploy in your Azure subscription. All aspects of the service and of your migration are controlled from this resource. However, Storage Mover Agents perform most of the migration's work. Storage Mover agents are virtual machines within your network that are used to facilitate migrations by performing the data transfer. 

To ensure that a Storage Mover Agent connects privately to Azure resources, the following components are required:

- **Azure Virtual Network:**<br>
An Azure virtual network is an isolated network within Azure that provides the foundation for private connectivity. It allows you to define subnets, configure routing, and set up network security groups (NSGs) to control traffic flow. The virtual network serves as the backbone for connecting your on-premises infrastructure to Azure resources securely.
- **VPN Gateway or ExpressRoute:**<br>
You can use a VPN gateway or Azure ExpressRoute to link your on-premises network to your Azure virtual network. A VPN Gateway is used for Site-to-Site VPN connections between networks, while ExpressRoute provides a dedicated private connection. Both options enable secure communication between on-premises infrastructure and Azure resources. 
- **Private Endpoints:**<br>
Azure Private Endpoints securely connect Azure services using a private IP from your virtual network. Each resource, such as a Storage Account or Key Vault, is assigned as a private endpoint.
- **DNS Configuration:**<br>
Proper DNS configuration is necessary to resolve the private endpoint IP addresses of your resource endpoints. Because you can create a Private DNS Zone and link it to your virtual network during Private Endpoint creation, this configuration can be accomplished during setup.

All services that support Private Endpoints can also be accessed as public endpoints, though some resources can be configured to either reject or allow public connections.

The following diagram illustrates an example of a resource topology for enabling private connectivity to all endpoints that support it. 

> [!NOTE]
> This configuration is one of many possible setups for a private network and doesn't encompass all components involved in network configuration, such as DNS, proxies, and virtual network peering.

:::image type="content" source="media/private-networking-prerequisites/private-networking-topology.png" alt-text="A diagram illustrating an example of a resource topology for enabling private connectivity to all endpoints that support it.":::

<sup>*1</sup> Arc Private Link Scopes provide access to three Arc services as shown in the image. One of the Arc services, Extensions, isn't used by the Storage Mover Agent, and is shown as disabled to avoid confusion.<br>
<sup>*2</sup> Arc Private Link Scopes and the three Arc services to which they connect can both be accessed directly over public endpoints. The Arc Private Link Scope can be configured to enable or disable public network access.<br>
<sup>*</sup> The recommended best practice is to use multiple Azure Virtual Networks. Use the Azure VPN Gateway to connect to the "hub" Virtual Network. Use a second "spoke" virtual network, connected to the "hub" using virtual network peering, to contain the resources. For detailed guidance, see [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/landing-zone/).

## Public Endpoint Dependencies

Despite the emphasis on private networking, certain required Storage Mover services are only accessible via public endpoints, as shown in the preceding diagram. These services can be accessed securely over public endpoints using ExpressRoute Microsoft Peering, which provides a private tunnel to Azure services. For more information, see [Microsoft Peering](../expressroute/expressroute-circuit-peerings.md).

The following list outlines these dependencies:

- **MCR (mcr.microsoft.com)** for automated agent updates.
- **The Storage Mover Service** for agent heartbeats and job coordination.
- **Event Hub** for publishing copy logs.
- **AAD/Entra ID and ARM** for registration and identity management.

The following table provides a summary of the required services, their endpoint types, and whether private access is supported:

| Service                               | Endpoint Type  | Needed For           | Private Access |
|---------------------------------------|--------------- |----------------------|----------------|
| **MCR (mcr.microsoft.com)**           | Public         | Agent updates        | &#10060;       |
| **The Storage Mover Service**         | Public         | Agent heartbeats     | &#10060;       |
| **Event Hub**                         | Public         | Publishing copy logs | &#10060;       |
| **Azure Arc**                         | Public/Private | Registration         | &#9989; (via Arc Private Link Scope) |
| **AAD / Entra ID**                    | Public         | Registration         | &#10060;       |
| **ARM**                               | Public         | Registration         | &#10060;       |
| **Storage Account (Blob, DFS, File)** | Private        | Job targets          | &#9989;        |
| **Key Vault**                         | Private        | SMB credentials      | &#9989;        |

Your network settings must allow the Storage Mover Agent to connect over HTTPS to the following endpoints for proper functionality:

| Service                | Public Cloud FQDN                               | Fairfax FQDN                                         |
|------------------------|-------------------------------------------------|------------------------------------------------------|
| MCR                    | mcr.microsoft.com                               | mcr.microsoft.com                                    |
| Storage Mover Service  | <region>.agentgateway.prd.azsm.azure.com        | <region>.agentgateway.ff.azsm.azure.us               |
| Event Hubs             | evhns-sm-ur-prd-<region>.servicebus.windows.net | evhns-sm-ur-ff-<region>.servicebus.usgovcloudapi.net |
| ARC                    | *.his.arc.azure.com                             | *.his.arc.azure.us                                   |
| ARC                    | *.guestconfiguration.azure.com                  | *.guestconfiguration.azure.us                        |
| Entra ID               | login.microsoftonline.com                       | login.microsoftonline.us                             |
| Entra ID               | pas.windows.net                                 | pasff.usgovcloudapi.net                              |
| Azure Resource Manager | management.azure.com                            | management.usgovcloudapi.net                         |
| Storage Account (Blob) | *.blob.core.windows.net                         | *.blob.core.usgovcloudapi.net                        |
| Storage Account (DFS)  | *.dfs.core.windows.net                          | *.dfs.core.usgovcloudapi.net                         |
| Storage Account (File) | *.file.core.windows.net                         | *.file.core.usgovcloudapi.net                        |
| Key Vault              | *.vault.azure.net                               | *.vault.usgovcloudapi.net                            |

## Arc-Enabled Server Considerations

The Storage Mover Agent is an Arc-enabled server and requires connectivity to Azure Arc services. While some Arc services support private access, they don't directly support Azure Private Endpoint resources. Instead, users must configure an Arc Private Link Scope to enable private connectivity. Unlike data-plane services, Arc services reside in the control-plane, which means public access doesn't expose sensitive data.

> [!NOTE]
> Azure Arc Private Link Scopes aren't required for Storage Accounts or Key Vaults.

## Additional Networking Considerations

Beyond the core components, there are networking considerations that can be configured to enhance the security and functionality of the Storage Mover Agent. However, these configurations are optional, depend on your specific network requirements, and might affect networking performance - especially if misconfigured.

### Proxy Support

The Storage Mover Agent supports external HTTP and HTTPS proxies. Configuration is done via the agent's shell within the **Network Configuration** section's **Update network configuration** menu. When prompted, select **Proxy** and enter the Fully Qualified Domain Name (FQDN) or IP address of the proxy. Include the port number if necessary. The following example illustrates the configuration steps:

:::image type="content" source="media/private-networking-prerequisites/proxy-configuration.png" alt-text="A screenshot showing the proxy configuration screen in the Storage Mover Agent.":::

### SSL Inspection
If your network performs SSL interception, the agent might fail to recognize modified certificates. Currently, adding custom certificates to the agent isn't supported. To avoid issues, allowlist required endpoints to bypass SSL inspection.
