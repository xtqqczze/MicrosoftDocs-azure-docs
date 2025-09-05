---

title: NAT Gateway SKUs
description: Overview of available NAT Gateway SKUs and their differences.
ms.date: 09/05/2025
ms.topic: article
ms.service: virtual-network
author: alittleton
ms.author: alittleton

---

# Azure NAT Gateway SKUs

## SKU Comparison
Azure NAT Gateway has two stock-keeping units (SKUs) - Standard and StandardV2. To compare and understand the differences between Standard and StandardV2 SKU, see the following table.

| Category | Feature | StandardV2 | Standard |
|----------|---------|------------|----------|
| Reliability | Availability Zones | Supported | Not Supported |
| Functionality | Source Network Address Translation (SNAT) | Supported | Supported |
| | Dynamic port allocation | Supported | Supported |
| | Idle timeout timer | Supported | Supported |
| | Port reuse timer | Supported | Supported |
| | Protocols | TCP, UDP | TCP, UDP |
| | Public IP version| IPv4, IPv6 - in public preview | IPv4 |
| | Attach point | Subnet, virtual network (all subnets) | Subnet |
| Scalability | Public IP Addresses | 16 IPv4 addresses, 16 IPv6 addresses - in public preview | 16 IPv4 addresses |
| | Public IP Prefixes | /28 IPv4 Prefix, /28 IPv6 Prefix - in public preview | /28 IPv4 Prefix |
| | Virtual networks | 1 | 1 |
| | Subnets | 800 - attached at subnet level, 3,000 attached at virtual network level | 800 |
| Monitoring | Metrics | Supported | Supported |
| Limits | Bandwidth | 100 Gbps per NAT Gateway, 1 Gbps per connection | 50 Gbps per NAT Gateway |
| | Packets per second | 10 million packets per second, 100,000 packets per second per connection | 5 million packets per second |
| | Connections per IP per destination | 50,000 | 50,000 |
| | Total connections | 2 million | 2 million | 

## Pricing and Service Level Agreement
Standard and StandardV2 NAT Gateway are the same price. For more information, see NAT Gateway pricing. 

For Azure NAT Gateway pricing, see [NAT Gateway pricing](https://azure.microsoft.com/pricing/details/azure-nat-gateway/).

For information on the Service Level Agreement (SLA), see [SLA for Azure NAT Gateway](https://azure.microsoft.com/support/legal/sla/virtual-network-nat/v1_0/).

## StandardV2 NAT Gateway Features

### Zone-redundant 

StandardV2 SKU NAT Gateway is **zone-redundant** by default. It automatically spans across multiple availability zones in a region, ensuring continued outbound connectivity even if one zone becomes unavailable. 

For more information, see [Availability zones](./nat-availability-zones.md).      

### Performance 

StandardV2 NAT Gateway supports up to 100 Gbps of bandwidth and can process up to 10 million packets per second.  On a per connection basis, StandardV2 NAT Gateway supports 1 Gbps per connection and 100,000 packets per second (PPS) per connection.  

### Virtual Network attachment 

StandardV2 NAT Gateway supports subnet level attachment and also has the added capability of associating on a virtual network level. Use the source virtual network property to attach StandardV2 NAT Gateway to a virtual network. When attached at the virtual network level, all subnets within the virtual network use the NAT Gateway for outbound connectivity.

### IPv6 support

StandardV2 SKU NAT Gateway support for IPv6 public IPs is currently in **public preview**. StandardV2 NAT Gateway can be attached to 16 IPv6 public IPs and 16 IPv4 public IPs simultaneously in order to provide highly scalable dual-stack outbound connectivity to the internet.  

> [!IMPORTANT]
> IPv6 support for StandardV2 NAT Gateway is now in public preview in select Azure regions. Refer to [known limitations](#known-limitations) to see the regions StandardV2 NAT Gateway isn't available in.

## Known limitations 

* Requires StandardV2 SKU Public IP addresses and prefixes. Standard SKU public IPs aren’t supported. 

* Standard SKU NAT Gateway can’t be upgraded to StandardV2 SKU NAT Gateway. You must deploy StandardV2 SKU NAT Gateway and replace Standard SKU NAT Gateway. 

* Custom IP prefixes (BYOIP public IPs) aren't supported with StandardV2 NAT Gateway. Only StandardV2 SKU Azure public IPs are supported. 

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

* StandardV2 NAT Gateway can’t be deployed as a managed NAT Gateway for Azure Kubernetes Service (AKS) workloads. It's only supported when configured as a user-assigned NAT Gateway. For more information, see [Create NAT Gateway for your AKS cluster](/azure/aks/nat-gateway).

* Terraform and CLI doesn't yet support StandardV2 NAT Gateway and StandardV2 Public IP deployments. 

## Known Issues 

* StandardV2 NAT Gateway disrupts outbound connections made with Load balancer outbound rules for IPv6 traffic only. Before attaching StandardV2 NAT Gateway to a subnet, make sure there isn't IPv6 outbound traffic using Load balancer outbound rules. 

* StandardV2 NAT Gateway associated with a source virtual network disrupts Azure Bastion connectivity. If you're using Azure Bastion to access your virtual machines, attach StandardV2 NAT Gateway directly to subnets instead. 

## Standard NAT Gateway Features

Standard SKU is a zonal resource. It's deployed into a specific availability zone and is resilient within that zone. 

Standard NAT Gateway can be attached to individual subnets within the same virtual network in order to provide scalable outbound connectivity to the internet. 

## Next steps 

* [Deploy StandardV2 NAT Gateway](./quickstart-create-nat-gateway-v2.md) to provide a zone-resilient network architecture. 

* [Deploy Standard NAT Gateway](./quickstart-create-nat-gateway.md) for single zone deployments. 
