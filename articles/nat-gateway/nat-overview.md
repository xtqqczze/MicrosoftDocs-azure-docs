---

title: What is Azure NAT Gateway?
titlesuffix: Azure NAT Gateway
description: Overview of Azure NAT Gateway features, resources, architecture, and implementation. Learn about what NAT Gateway is and how to use it.
author: alittleton
ms.service: azure-nat-gateway
ms.topic: overview
ms.date: 09/05/2025
ms.author: alittleton
ms.customs: references_regions
#Customer intent: I want to understand what Azure NAT Gateway is and how to use it.
# Customer intent: As a cloud architect, I want to implement Azure NAT Gateway for outbound connectivity, so that I can ensure secure and scalable internet access for private resources without exposing them to unsolicited inbound connections.
---

# What is Azure NAT Gateway?

Azure NAT Gateway is a fully managed and highly available Network Address Translation (NAT) service. Azure NAT Gateway allows all resources in a private subnet to connect outbound to the internet while remaining fully private. Unsolicited inbound connections from the internet aren't allowed through a NAT Gateway. Only response packets to an outbound connection are allowed.

NAT Gateway dynamically allocates SNAT ports to automatically scale outbound connectivity and minimize the risk of SNAT port exhaustion. 

:::image type="content" source="./media/nat-overview/flow-map.png" alt-text="Figure shows a NAT receiving traffic from internal subnets and directing it to a public IP address." lightbox="./media/nat-overview/flow-map.png":::

*Figure: Azure NAT Gateway*

Azure NAT Gateway is available in two SKUs:
* **Standard** SKU NAT Gateway is zonal (deployed to a single availability zone) and provides scalable outbound connectivity for subnets in a single virtual network.
* **StandardV2** SKU NAT Gateway is **zone-redundant** with higher throughput than the Standard SKU and virtual network as well as subnet level association.

## StandardV2 NAT Gateway

StandardV2 NAT Gateway provides all the same functionality of the Standard SKU NAT Gateway, such as dynamic SNAT port allocation and secure outbound connectivity for subnets within a virtual network. Additionally, StandardV2 NAT Gateway is zone-redundant, meaning that it provides outbound connectivity from all zones in a region instead of a single zone like Standard NAT Gateway.   

### Key capabilities of StandardV2 NAT Gateway

* **Zone-redundant** - operates across all availability zones in a region to maintain connectivity during a single zone failure.
* **Higher throughput** - each StandardV2 NAT Gateway can provide up to 100 Gbps of data throughput, compared to 50 Gbps for Standard NAT Gateway.
* **Virtual network level association** - can be associated to an entire virtual network through the source virtual network property. When associated to a virtual network, all subnets within the virtual network use the NAT Gateway for outbound connectivity.

>[!NOTE]
> StandardV2 NAT Gateway now supports IPv6 public IP addresses and prefixes in Public Preview. You can associate up to 16 IPv6 public IP addresses in order to provide outbound connectivity for IPv6 traffic.

To learn more on how to deploy StandardV2 NAT Gateway, see [Create a StandardV2 NAT Gateway](./quickstart-create-nat-gateway-v2.md).

### Key limitations of StandardV2 NAT Gateway
* Requires StandardV2 SKU public IP addresses or prefixes. Standard SKU public IPs aren't supported with StandardV2 NAT Gateway.
* Standard SKU NAT Gateway can't be upgraded to StandardV2 NAT Gateway. You must first create StandardV2 SKU NAT Gateway and replace Standard SKU NAT Gateway on your subnet.
* The following regions don't support StandardV2 NAT Gateway:
    * Canada East
    * Central India
    * Chile Central
    * Indonesia Central
    * Israel Northwest
    * Jio India West
    * Malaysia West
    * Qatar Central
    * Sweden South
    * UAE Central
    * West India

## Standard NAT Gateway

Standard NAT Gateway provides outbound connectivity to the internet and can be associated with subnets within the same virtual network. Standard NAT Gateway operates out of a single availability zone. 

## Azure NAT Gateway benefits

### Simple Setup

Deployments are intentionally made simple with NAT Gateway. Attach NAT Gateway to a subnet and public IP address and start connecting outbound to the internet right away. There's zero maintenance and routing configurations required. More public IPs or subnets can be added later without effect to your existing configuration. 

The following steps are an example of how to set up a NAT Gateway:

1. Create a NAT gateway.

2. Assign a public IP address or public IP prefix.

3. Configure a virtual network subnet to use a NAT gateway.

If necessary, modify Transmission Control Protocol (TCP) idle timeout (optional). Review [timers](/azure/nat-gateway/nat-gateway-resource#idle-timeout-timers) before you change the default. 

### Security

NAT Gateway is built on the Zero Trust network security model and is secure by default. With NAT Gateway, private instances within a subnet don't need public IP addresses to reach the internet. Private resources can reach external sources outside the virtual network by source network address translating (SNAT) to NAT Gateway's static public IP addresses or prefixes. You can provide a contiguous set of IPs for outbound connectivity by using a public IP prefix. Destination firewall rules can be configured based on this predictable IP list.

### Resiliency 

Azure NAT Gateway is a fully managed and distributed service. It doesn't depend on individual compute instances such as virtual machines or a single physical gateway device. A NAT Gateway always has multiple fault domains and can sustain multiple failures without service outage. Software-defined networking makes a NAT Gateway highly resilient. 

Additionally, StandardV2 NAT Gateway provides **zonal resiliency** by operating out of multiple availability zones in a region. When a zone goes down, all new connections flow out of the remaining healthy zones in a region. 

### Scalability

NAT Gateway is scaled out from creation. There isn't a ramp-up or scale-out operation required. Azure manages the operation of NAT Gateway for you. 

Attach NAT Gateway to a subnet to provide outbound connectivity for all private resources in that subnet. All subnets in a virtual network can use the same NAT Gateway resource. Outbound connectivity can be scaled out by adding public IP addresses or a larger public IP prefix size to NAT Gateway. When a NAT Gateway is associated to a public IP prefix, it automatically scales to the number of IP addresses needed for outbound.

### Performance

Azure NAT Gateway is a software-defined networking service. Each Standard NAT Gateway can process up to 50 Gbps of data for both outbound and return traffic. StandardV2 NAT Gateway can process up to 100 Gbps of data.

A NAT Gateway doesn't affect the network bandwidth of your compute resources. Learn more about [NAT Gateway's performance](nat-gateway-resource.md#performance).

## Azure NAT Gateway basics

Azure NAT Gateway provides secure, scalable outbound connectivity for resources in a virtual network. It’s the recommended method for outbound access to the internet. 

To migrate outbound access to a NAT Gateway from default outbound access or Load Balancer outbound rules, see [Migrate outbound access to Azure NAT Gateway](./tutorial-migrate-outbound-nat.md).

>[!NOTE]
>On September 30, 2025, new virtual networks will default to using private subnets, meaning that [default outbound access](/azure/virtual-network/ip-services/default-outbound-access#when-is-default-outbound-access-provided) will no longer be provided by default, and that explicit outbound method must be enabled in order to reach public endpoints on the Internet and within Microsoft. It's recommended to use an explicit form of outbound connectivity instead, like NAT Gateway. 

### Outbound connectivity

* **Default outbound path for a subnet** - NAT Gateway replaces the default internet destination of a subnet to provide outbound connectivity.

* **Protocol support** - NAT Gateway supports TCP and User Datagram Protocol (UDP) protocols only. Internet Control Message Protocol (ICMP) isn't supported.

* **Minimizes risk of SNAT port exhaustion** - NAT Gateway dynamically allocates SNAT ports to minimize the risk of SNAT port exhaustion. To learn more, see [SNAT port allocation](/azure/nat-gateway/nat-gateway-snat#nat-gateway-dynamically-allocates-snat-ports).

* **Service compatibility** - NAT Gateway provides outbound connectivity for multiple Azure services, including: 

    * Azure virtual machines or virtual machine scale sets in a private subnet.

    * [Azure Kubernetes Services (AKS) clusters](/azure/aks/nat-gateway).

    * [Azure Container group](/azure/container-instances/container-instances-nat-gateway).

    * [Azure Function Apps](/azure/azure-functions/functions-how-to-use-nat-gateway).

    * [Azure Firewall subnet](/azure/firewall/integrate-with-nat-gateway).

    * [Azure App Services instances](/azure/app-service/networking/nat-gateway-integration) (web applications, REST APIs, and mobile backends) through [virtual network integration](/azure/app-service/overview-vnet-integration).

    * [Azure Databricks](/azure/databricks/security/network/secure-cluster-connectivity#egress-with-default-managed-vnet) or with [virtual network injection](/azure/databricks/security/network/secure-cluster-connectivity#egress-with-vnet-injection).

    * [Azure HDInsight](/azure/hdinsight/load-balancer-migration-guidelines#new-cluster-creation).

### Traffic routes

* NAT Gateway uses the subnet's [system default route](/azure/virtual-network/virtual-networks-udr-overview#default) for 0.0.0.0/0 to the internet automatically. After NAT Gateway is configured to the subnet, virtual machines in the subnet communicate to the internet using the public IP of the NAT Gateway.

* A UDR that sends 0.0.0.0/0 traffic to a virtual appliance or a virtual network gateway (VPN Gateway and ExpressRoute) as the next hop type instead of the internet bypasses the use of NAT Gateway.

### NAT Gateway configurations

* Standard NAT Gateway can be configured to subnets 

* StandardV2 NAT Gateway can be configured to subnets in the same virtual network or to a virtual network with the source virtual network property.  

* Multiple NAT Gateways can’t be attached to a single subnet.

* A NAT Gateway can’t span multiple virtual networks. However, NAT Gateway can be used to provide outbound connectivity in a hub and spoke model. For more information, see the [NAT Gateway hub and spoke tutorial](/azure/nat-gateway/tutorial-hub-spoke-route-nat).

* A NAT Gateway can’t be deployed in a [gateway subnet](../vpn-gateway/vpn-gateway-about-vpn-gateway-settings.md#gwsub) or subnet containing [SQL Managed Instances](/azure/azure-sql/managed-instance/connectivity-architecture-overview#networking-constraints).

* A Standard NAT Gateway resource can use up to 16 IPv4 IP addresses of either public IP addresses or public IP prefixes or custom IP prefixes (BYOIP). To learn more on custom IP prefixes, see [Custom IP address prefix (BYOIP)](../virtual-network/ip-services/custom-ip-address-prefix.md).

* A StandardV2 NAT Gateway can use up to 16 IPv4 and up to 16 IPv6 IP addresses of either public IP addresses or public IP prefixes. Custom IP prefixes (BYOIP) aren't supported with StandardV2 NAT Gateway.

* NAT Gateway works with any virtual machine network interface or IP configuration. NAT Gateway can SNAT multiple IP configurations on a network interface.

* NAT Gateway can be associated to an Azure Firewall subnet in a hub virtual network and provide outbound connectivity from spoke virtual networks peered to the hub. To learn more, see [Azure Firewall integration with NAT Gateway](../firewall/integrate-with-nat-gateway.md).

### Availability zones

* Standard NAT Gateway can be created in a specific availability zone or placed in **no zone**. After NAT Gateway is deployed, the zone selection can't be changed.

* Standard NAT Gateway is placed in **no zone** by default. A [nonzonal NAT Gateway](./nat-availability-zones.md#nonzonal) is placed in a zone for you by Azure.

* StandardV2 NAT Gateway is a **zone-redundant** service and operates across all availability zones in a region.

### NAT Gateway and basic resources

* Standard NAT Gateway is compatible with Standard public IP addresses or public IP prefixes. StandardV2 NAT Gateway is compatible with StandardV2 public IP addresses or public IP prefixes only.

* NAT Gateway can't be used with subnets where basic resources exist. Basic SKU resources, such as basic Load Balancer or basic public IPs aren't compatible with NAT Gateway. Basic Load Balancer and basic public IP can be upgraded to standard to work with a NAT Gateway.
  
    * For more information about upgrading a Load Balancer from basic to standard, see [Upgrade a public basic Azure Load Balancer](/azure/load-balancer/upgrade-basic-standard-with-powershell).

    * For more information about upgrading a public IP from basic to standard, see [Upgrade a public IP address](../virtual-network/ip-services/public-ip-upgrade-portal.md).

    * For more information about upgrading a basic public IP attached to a virtual machine from basic to standard, see [Upgrade a basic public IP attached to a virtual machine](/azure/virtual-network/ip-services/public-ip-upgrade-vm).  

### Connection timeouts and timers

* NAT Gateway sends a TCP Reset (RST) packet for any connection flow that it doesn't recognize as an existing connection. The connection flow no longer exists if the NAT Gateway idle timeout was reached or the connection was closed earlier. 

* When the sender of traffic on the nonexisting connection flow receives the NAT Gateway TCP RST packet, the connection is no longer usable.

* SNAT ports aren't readily available for reuse to the same destination endpoint after a connection closes. NAT Gateway places SNAT ports in a cool down state before they can be reused to connect to the same destination endpoint. 

* SNAT port reuse (cool down) timer durations vary for TCP traffic depending on how the connection closes. To learn more, see [Port Reuse Timers](./nat-gateway-resource.md#port-reuse-timers).

* A default TCP idle timeout of 4 minutes is used and can be increased to up to 120 minutes. Any activity on a flow can also reset the idle timer, including TCP keepalives. To learn more, see [Idle Timeout Timers](./nat-gateway-resource.md#idle-timeout-timers).

* UDP traffic has an idle timeout timer of 4 minutes that can't be changed.
 
* UDP traffic has a port reuse timer of 65 seconds for which a port is in hold down before it's available for reuse to the same destination endpoint.

## Pricing and Service Level Agreement (SLA)

Standard and StandardV2 NAT Gateway are matched in price and SLA.

For Azure NAT Gateway pricing, see [NAT Gateway pricing](https://azure.microsoft.com/pricing/details/azure-nat-gateway/).

For information on the SLA, see [SLA for Azure NAT Gateway](https://azure.microsoft.com/support/legal/sla/virtual-network-nat/v1_0/).

## Next steps

* For more information about creating and validating a NAT Gateway, see [Quickstart: Create a NAT Gateway using the Azure portal](quickstart-create-nat-gateway-portal.md).

* To view a video on more information about Azure NAT Gateway, see [How to get better outbound connectivity using an Azure NAT Gateway](https://www.youtube.com/watch?v=2Ng_uM0ZaB4).

* For more information about the NAT Gateway resource, see [NAT Gateway resource](./nat-gateway-resource.md).

* Learn more about Azure NAT Gateway in the following module:

   * [Learn module: Introduction to Azure NAT Gateway](/training/modules/intro-to-azure-virtual-network-nat).

* For more information about architecture options for Azure NAT Gateway, see [Azure Well-Architected Framework review of an Azure NAT Gateway](/azure/architecture/networking/guide/well-architected-network-address-translation-gateway).

