---
title: Azure Traffic Manager FAQ - Common Questions Answered
description: Find answers to common Azure Traffic Manager questions about DNS routing, endpoints, health monitoring, geographic routing, and nested profiles. Learn how to optimize your traffic management configuration.
services: traffic-manager
author: asudbring
ms.service: azure-traffic-manager
ms.topic: concept-article
ms.date: 12/29/2025
ms.author: allensu
# Customer intent: As a Cloud Architect, I want to understand Azure Traffic Manager functionalities and limitations, so that I can effectively implement it for DNS-based traffic routing and ensure optimal performance of my distributed applications.
---

# Traffic Manager frequently asked questions (FAQ)

## Traffic Manager basics

### What IP address does Traffic Manager use?

As explained in [How Traffic Manager Works](traffic-manager-how-it-works.md), Traffic Manager works at the Domain Name System (DNS) level. It sends DNS responses to direct clients to the appropriate service endpoint. Clients then connect to the service endpoint directly, not through Traffic Manager.

Therefore, Traffic Manager doesn't provide an endpoint or IP address for clients to connect to. If you want a static IP address for your service, configure it in the service, not in Traffic Manager.

### What types of traffic can I route using Traffic Manager?
As explained in [How Traffic Manager Works](traffic-manager-how-it-works.md), a Traffic Manager endpoint can be any internet-facing service hosted inside or outside of Azure. Traffic Manager can route traffic that originates from the public internet to a set of endpoints that are also internet facing. If you have endpoints inside a private network (for example, an internal version of [Azure Load Balancer](../load-balancer/components.md#frontend-ip-configurations)) or users making DNS requests from such internal networks, you can't use Traffic Manager to route this traffic.

### Does Traffic Manager support "sticky" sessions?

As explained in [How Traffic Manager Works](traffic-manager-how-it-works.md), Traffic Manager works at the DNS level. It uses DNS responses to direct clients to the appropriate service endpoint. Clients connect to the service endpoint directly, not through Traffic Manager. Therefore, Traffic Manager doesn't see the HTTP traffic between the client and the server.

Additionally, the source IP address of the DNS query that Traffic Manager receives belongs to the recursive DNS service, not the client. Traffic Manager has no way to track individual clients and can't implement 'sticky' sessions. This limitation is common to all DNS-based traffic management systems and isn't specific to Traffic Manager.

### Why am I seeing an HTTP error when using Traffic Manager?

As explained in [How Traffic Manager Works](traffic-manager-how-it-works.md), Traffic Manager works at the DNS level. It uses DNS responses to direct clients to the appropriate service endpoint. Clients then connect to the service endpoint directly, not through Traffic Manager. Traffic Manager doesn't see HTTP traffic between client and server. Therefore, any HTTP error you see must come from your application. For the client to connect to the application, all DNS resolution steps are complete. That condition includes any interaction that Traffic Manager has on the application traffic flow.

Further investigation should therefore focus on the application.

The HTTP host header that the client's browser sends is the most common source of problems. Make sure the application is configured to accept the correct host header for the domain name you're using. For endpoints that use Azure App Service, see [configuring a custom domain name for a web app in Azure App Service using Traffic Manager](../app-service/configure-domain-traffic-manager.md).

### How can I resolve a 500 (Internal Server Error) problem when using Traffic Manager?

If your client or application receives an HTTP 500 error while using Traffic Manager, stale DNS query might be the cause. To resolve the issue, clear the DNS cache and allow the client to issue a new DNS query.

When a service endpoint becomes unresponsive, clients and applications that use that endpoint don't reset until the DNS cache refreshes. The time-to-live (TTL) of the DNS record determines the duration of the cache. For more information, see [Traffic Manager and the DNS cache](traffic-manager-how-it-works.md#traffic-manager-and-the-dns-cache).

Also see the following related FAQs in this article:
- [What is DNS TTL and how does it impact my users?](#what-is-dns-ttl-and-how-does-it-impact-my-users)
- [How high or low can I set the TTL for Traffic Manager responses?](#how-high-or-low-can-i-set-the-ttl-for-traffic-manager-responses)
- [How can I understand the volume of queries coming to my profile?](#how-can-i-understand-the-volume-of-queries-coming-to-my-profile)  

### What is the performance impact of using Traffic Manager?

As explained in [How Traffic Manager Works](traffic-manager-how-it-works.md), Traffic Manager works at the DNS level. Since clients connect to your service endpoints directly, there's no performance impact when using Traffic Manager once the connection is established.

Since Traffic Manager integrates with applications at the DNS level, it requires an additional DNS lookup in the DNS resolution chain. The impact of Traffic Manager on DNS resolution time is minimal. Traffic Manager uses a global network of name servers and uses [anycast](https://en.wikipedia.org/wiki/Anycast) networking to ensure DNS queries always route to the closest available name server. In addition, caching of DNS responses means the additional DNS latency from using Traffic Manager applies only to a fraction of sessions.

The Performance method routes traffic to the closest available endpoint. The overall performance impact of this method is minimal. Any increase in DNS latency is offset by lower network latency to the endpoint.

### What application protocols can I use with Traffic Manager?

As explained in [How Traffic Manager Works](traffic-manager-how-it-works.md), Traffic Manager works at the DNS level. Once the DNS lookup is complete, clients connect to the application endpoint directly, not through Traffic Manager. The connection can use any application protocol. 
 If you select TCP as the monitoring protocol, Traffic Manager's endpoint health monitoring can be done without using any application protocols. If you choose to have the health verified using an application protocol, the endpoint needs to respond to either HTTP or HTTPS GET requests.

### Can I use Traffic Manager with a "naked" domain name?

Yes. To learn how to create an alias record for your domain name apex to reference an Azure Traffic Manager profile, see [Configure an alias record to support apex domain names with Traffic Manager](../dns/tutorial-alias-tm.md).

### Does Traffic Manager consider the client subnet address when handling DNS queries? 

Yes. In addition to the source IP address of the DNS query (usually the DNS resolver's IP address), Traffic Manager also considers the client subnet address if it's included in the DNS query the DNS resolver sends. The DNS resolver makes the request on behalf of the end user. Traffic Manager uses these IP addresses to optimize geographic, performance, and subnet routing methods. Specifically, [RFC 7871 – Client Subnet in DNS Queries](https://tools.ietf.org/html/rfc7871) provides an [Extension Mechanism for DNS (EDNS0)](https://tools.ietf.org/html/rfc2671) that enables resolvers to pass on the client subnet address.

### What is DNS TTL and how does it impact my users?

When a DNS query reaches Traffic Manager, it sets a value in the response called time-to-live (TTL). This value (in seconds) tells DNS resolvers downstream how long to cache this response. While DNS resolvers aren't required to cache this result, caching it enables them to respond to subsequent queries from the cache instead of going to Traffic Manager DNS servers. This caching affects the responses as follows:

1. A higher TTL reduces the number of queries that reach the Traffic Manager DNS servers. This reduction can lower the cost for a customer since the number of queries served is a billable usage.
1. A higher TTL can potentially reduce the time it takes to do a DNS lookup.
1. A higher TTL also means that your data doesn't reflect the latest health information that Traffic Manager obtains through its probing agents.

### How high or low can I set the TTL for Traffic Manager responses?

You can set the DNS TTL at the profile level to be as low as 0 seconds and as high as 2,147,483,647 seconds. This range is the maximum range compliant with [RFC-1035](https://www.ietf.org/rfc/rfc1035.txt). A TTL of 0 means downstream DNS resolvers don't cache query responses and all queries reach the Traffic Manager DNS servers for resolution.

### How can I understand the volume of queries coming to my profile? 

Traffic Manager provides a metric for the number of queries a profile responds to. You can get this information at a profile level aggregation, or you can split it further to see the volume of queries where specific endpoints were returned. In addition, you can set up alerts to notify you if the query response volume crosses the conditions you set. For more information, see [Traffic Manager metrics and alerts](traffic-manager-metrics-alerts.md).

### When I delete a Traffic Manager profile, how long before the name of the profile is available for reuse?

When you delete a Traffic Manager profile, the associated domain name is reserved for a period of time. Other Traffic Manager profiles in the same tenant can immediately reuse the name. However, a different Azure tenant can't use the same profile name until the reservation expires. This feature enables you to maintain authority over the namespaces you deploy, eliminating concerns that another tenant might take the name.

For example, if your Traffic Manager profile name is **label1**, then **label1.trafficmanager.net** is reserved for your tenant even if you delete the profile. Child namespaces, such as **xyz.label1** or **123.abc.label1**, are also reserved. When the reservation expires, the name becomes available to other tenants. The name associated with a disabled profile is reserved indefinitely. For questions about how long a name is reserved, contact your account representative. 

### What version of TLS does Traffic Manager require?

Microsoft doesn't know of any vulnerabilities in its implementation of older TLS versions. However, TLS 1.2 and later versions provide better security by using features such as perfect forward secrecy and stronger cipher suites. To enhance security and provide best-in-class encryption for your data, Traffic Manager requires securing interactions with services using Transport Layer Security (TLS) 1.2 or later before February 28, 2025. Traffic Manager support for TLS 1.0 and 1.1 ends on this date. This date might differ from the [Azure-wide TLS 1.0 and TLS 1.1 retirement date](https://azure.microsoft.com/updates?id=update-retirement-tls1-0-tls1-1-versions-azure-services).

**Recommended action** 

To avoid service disruptions, resources that interact with Traffic Manager must use TLS 1.2 or later. 

- If resources already exclusively use TLS 1.2 or later, you don't need to take further action. 
- If resources still depend on TLS 1.0 or 1.1, transition them to TLS 1.2 or later by February 28, 2025. 

For information about migrating from TLS 1.0 and 1.1 to TLS 1.2, see [Solving the TLS 1.0 Problem](/security/engineering/solving-tls1-problem).

### What TLS cipher suites does Azure Traffic Manager support?

Azure Traffic Manager supports modern TLS cipher suites for TLS 1.2 and TLS 1.3 to ensure secure communications. The following cipher suites are supported:

**TLS 1.3 Cipher Suites**

These cipher suites work with **Protocol 772** (which corresponds to TLS 1.3):

| Cipher Suite | Protocol |
|--------------|----------|
| TLS_AES_256_GCM_SHA384 | 772 |
| TLS_AES_128_GCM_SHA256 | 772 |

**TLS 1.2 Cipher Suites**

These cipher suites work with **Protocol 771** (TLS 1.2) and/or 65277 (used by some systems as an internal or custom code for TLS 1.2):

| Cipher Suite | Protocols |
|--------------|-----------|
| TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256 | 771, 65277 |
| TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 | 771, 65277 |
| TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 | 771, 65277 |
| TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 | 771, 65277 |
| TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256 | 771, 65277 |
| TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 | 771, 65277 |
| TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384 | 771, 65277 |
| TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384 | 771, 65277 |

These cipher suites provide strong encryption and are compliant with modern security standards. Traffic Manager automatically negotiates the best available cipher suite during the TLS handshake process.

## Traffic Manager Geographic traffic routing method

### What are some use cases where geographic routing is useful?

Use the geographic routing type when you need to distinguish your users based on geographic regions. For example, by using the Geographic traffic routing method, you can give users from specific regions a different user experience than those from other regions. Another example is complying with local data sovereignty mandates that require that users from a specific region are served only by endpoints in that region.

### How do I decide if I should use Performance routing method or Geographic routing method?

The key difference between these two popular routing methods is that in Performance routing method your primary goal is to send traffic to the endpoint that can provide the lowest latency to the caller, whereas, in Geographic routing the primary goal is to enforce a geo fence for your callers so that you can deliberately route them to a specific endpoint. The overlap happens since there's a correlation between geographical closeness and lower latency, although this isn't always true. There might be an endpoint in a different geography that can provide a better latency experience for the caller and in that case Performance routing sends the user to that endpoint but Geographic routing always sends them to the endpoint you've mapped for their geographic region. To further make it clear, consider the following example - with Geographic routing you can make uncommon mappings such as send all traffic from Asia to endpoints in the US and all US traffic to endpoints in Asia. In that case, Geographic routing deliberately does exactly what you have configured it to do and performance optimization isn't a consideration. 

> [!NOTE]
> There might be scenarios where you need both performance and geographic routing capabilities. For these scenarios, nested profiles can be a great choice. For example, you can set up a parent profile with geographic routing where you send all traffic from North America to a nested profile that has endpoints in the US and use performance routing to send that traffic to the best endpoint within that set. 

### What are the regions that are supported by Traffic Manager for geographic routing?

You can find the country and region hierarchy that Traffic Manager uses [here](traffic-manager-geographic-regions.md). While this page is kept up to date with any changes, you can also programmatically retrieve the same information by using the [Azure Traffic Manager REST API](/rest/api/trafficmanager/). 

### How does traffic manager determine where a user is querying from?

Traffic Manager looks at the source IP of the query (this source IP is most likely a local DNS resolver that queries on behalf of the user) and uses an internal IP-to-region map to determine the location. This map is updated on an ongoing basis to account for changes in the internet. 

### Is it guaranteed that Traffic Manager can correctly determine the exact geographic location of the user in every case?

No, Traffic Manager can't guarantee that the geographic region it infers from the source IP address of a DNS query always corresponds to the user's location due to the following reasons:

1. First, as described in the previous FAQ, the source IP that Traffic Manager sees is that of a DNS resolver doing the lookup on behalf of the user. While the geographic location of the DNS resolver is a good proxy for the geographic location of the user, it can also be different depending upon the footprint of the DNS resolver service and the specific DNS resolver service a customer has chosen to use. 
As an example, a customer located in Malaysia could specify in their device's settings use a DNS resolver service whose DNS server in Singapore might get picked to handle the query resolutions for that user/device. In that case, Traffic Manager can only see the resolver's IP that corresponds to the Singapore location. Also, see the earlier FAQ regarding client subnet address support on this page.

1. Second, Traffic Manager uses an internal map to do the IP address to geographic region translation. While this map is validated and updated on an ongoing basis to increase its accuracy and account for the evolving nature of the internet, there's still the possibility that the information isn't an exact representation of the geographic location of all the IP addresses.

###  Does an endpoint need to be physically located in the same region as the one it's configured with for geographic routing?

No, the location of the endpoint imposes no restrictions on which regions you can map to it. For example, an endpoint in the US-Central Azure region can serve all users from India.

### Can I assign geographic regions to endpoints in a profile that isn't configured to do geographic routing?

Yes, if the routing method of a profile isn't geographic, you can use the [Azure Traffic Manager REST API](/rest/api/trafficmanager/) to assign geographic regions to endpoints in that profile. For non-geographic routing type profiles, this configuration is ignored. If you change such a profile to geographic routing type at a later time, Traffic Manager can use those mappings.

### Why am I getting an error when I try to change the routing method of an existing profile to Geographic?

All endpoints under a profile with geographic routing need to have at least one region mapped to them. To convert an existing profile to geographic routing type, first associate geographic regions to all its endpoints using the [Azure Traffic Manager REST API](/rest/api/trafficmanager/) before changing the routing type to geographic. If you're using the portal, first delete the endpoints, change the routing method of the profile to geographic, and then add the endpoints along with their geographic region mapping.

### Why is it strongly recommended that customers create nested profiles instead of endpoints under a profile with geographic routing enabled?

A region can be assigned to only one endpoint within a profile if it's using the geographic routing method. If that endpoint isn't a nested type with a child profile attached to it and goes unhealthy, Traffic Manager continues to send traffic to it since the alternative of not sending any traffic isn't any better. Traffic Manager doesn't fail over to another endpoint, even when the region assigned is a "parent" of the region assigned to the endpoint that went unhealthy (for example, if an endpoint that has region Spain goes unhealthy, Traffic Manager doesn't fail over to another endpoint that has the region Europe assigned to it). This behavior ensures Traffic Manager respects the geographic boundaries a customer sets up in their profile. To get the benefit of failing over to another endpoint when an endpoint goes unhealthy, assign geographic regions to nested profiles with multiple endpoints within them instead of individual endpoints. In this way, if an endpoint in the nested child profile fails, traffic can fail over to another endpoint inside the same nested child profile.

### Are there any restrictions on the API version that supports this routing type?

Yes, only API version 2017-03-01 and newer supports the Geographic routing type. You can't use older API versions to create profiles of Geographic routing type or assign geographic regions to endpoints. If you use an older API version to retrieve profiles from an Azure subscription, any profile of Geographic routing type isn't returned. In addition, when using older API versions, any profile returned that has endpoints with a geographic region assignment doesn't have its geographic region assignment shown.

## Traffic Manager Subnet traffic routing method

### What are some use cases where subnet routing is useful?

Subnet routing allows you to differentiate the experience you deliver for specific sets of users identified by the source IP of their DNS requests IP address. An example is showing different content if users connect to a website from your corporate HQ. Another example is restricting users from certain ISPs to only access endpoints that support only IPv4 connections if those ISPs have subpar performance when IPv6 is used.

Another reason to use Subnet routing method is in conjunction with other profiles in a nested profile set. For example, if you want to use Geographic routing method for geo-fencing your users, but for a specific ISP you want to do a different routing method, you can have a profile with Subnet routing method as the parent profile and override that ISP to use a specific child profile. You can then have the standard Geographic profile for everyone else.

> [!NOTE]
> Azure Traffic Manager supports IPv6 addresses in subnet overrides for subnet profiles. This capability enables more granular control over traffic routing based on the source IP address of DNS queries, including both IPv4 and IPv6 addresses. 

### How does Traffic Manager know the IP address of the end user?

End-user devices typically use a DNS resolver to do the DNS lookup on their behalf. Traffic Manager sees the outgoing IP of such resolvers as the source IP. In addition, Subnet routing method also looks to see if there's EDNS0 Extended Client Subnet (ECS) information the request passes. If ECS information is present, that's the address used to determine the routing. In the absence of ECS information, the source IP of the query is used for routing purposes.

### How can I specify IP addresses when using Subnet routing?

You can specify the IP addresses to associate with an endpoint in two ways. First, use the quad dotted decimal octet notation with a start and end addresses to specify the range (for example, 1.2.3.4-5.6.7.8 or 3.4.5.6-3.4.5.6). Second, use the CIDR notation to specify the range (for example, 1.2.3.0/24). You can specify multiple ranges and can use both notation types in a range set. A few restrictions apply.

1. You can't overlap address ranges since each IP address needs to be mapped to only a single endpoint.
1. The start address can't be more than the end address.
1. For the CIDR notation, the IP address before the '/' should be the network address of that range (for example, 1.2.3.0/24 is valid but 1.2.3.4.4/24 is NOT valid).

### How can I specify a fallback endpoint when using Subnet routing?

In a profile with Subnet routing, if you have an endpoint with no subnets mapped to it, any request that doesn't match other endpoints is directed here. We highly recommend you have such a fallback endpoint in your profile. Traffic Manager returns an NXDOMAIN response if a request comes in and it isn't mapped to any endpoints, or if it's mapped to an endpoint but that endpoint is unhealthy.

### What happens if an endpoint is disabled in a Subnet routing type profile?

In a profile with Subnet routing, if you have an endpoint that is disabled, Traffic Manager behaves as if that endpoint and the subnet mappings it has don't exist. If a query that matches with its IP address mapping is received and the endpoint is disabled, Traffic Manager returns a fallback endpoint (one with no mappings) or if such an endpoint isn't present, returns an NXDOMAIN response.

## Traffic Manager MultiValue traffic routing method

### What are some use cases where MultiValue routing is useful?

MultiValue routing returns multiple healthy endpoints in a single query response. The main advantage of this feature is that if an endpoint is unhealthy, the client has more options to retry without making another DNS call (which might return the same value from an upstream cache). This feature is applicable for availability-sensitive applications that want to minimize the downtime.
Another use for the MultiValue routing method is if an endpoint is "dual-homed" to both IPv4 and IPv6 addresses and you want to give the caller both options to choose from when it initiates a connection to the endpoint.

### How many endpoints are returned when MultiValue routing is used?

You can specify the maximum number of endpoints to return. MultiValue returns no more than that many healthy endpoints when a query is received. The maximum possible value for this configuration is 10.

### Do I get the same set of endpoints when I use MultiValue routing?

The same set of endpoints might not be returned in each query. This behavior is affected by the fact that some of the endpoints might go unhealthy at which point they aren't included in the response.

## Real User Measurements

### What are the benefits of using Real User Measurements?

When you use the performance routing method, Traffic Manager picks the best Azure region for your end user to connect to by inspecting the source IP and EDNS Client Subnet (if passed in) and checking it against the network latency intelligence the service maintains. Real User Measurements enhances this selection for your end-user base by having their experience contribute to this latency table. It also ensures this table adequately spans the end-user networks from where your end users connect to Azure. This enhancement leads to increased accuracy in the routing of your end user.

### Can I use Real User Measurements with non-Azure regions?

Real User Measurements measures and reports on only the latency to reach Azure regions. If you're using performance-based routing with endpoints hosted in non-Azure regions, you can still benefit from this feature by having increased latency information about the representative Azure region you selected to associate with this endpoint.

### Which routing method benefits from Real User Measurements?

The additional information gained through Real User Measurements is applicable only for profiles that use the performance routing method. The Real User Measurements link is available from all the profiles when you view it through the Azure portal.

### Do I need to enable Real User Measurements for each profile separately?

No, you only need to enable it once per subscription. All profiles can access the latency information measured and reported.

### How do I turn off Real User Measurements for my subscription?

You stop accruing charges related to Real User Measurements when you stop collecting and sending back latency measurements from your client application. For example, if you embed measurement JavaScript in web pages, you can stop using this feature by removing the JavaScript or by turning off its invocation when the page is rendered.

You can also turn off Real User Measurements by deleting your key. Once you delete the key, Traffic Manager discards any measurements sent with that key.

### Can I use Real User Measurements with client applications other than web pages?

Yes, Real User Measurements is designed to ingest data collected through different types of end-user clients. This article is updated as new types of client applications get supported.

### How many measurements are made each time my Real User Measurements enabled web page is rendered?

When you use Real User Measurements with the provided measurement JavaScript, each page rendering results in six measurements. The script reports these measurements back to the Traffic Manager service. You're charged for this feature based on the number of measurements reported to Traffic Manager service. For example, if the user navigates away from your webpage while the measurements are being taken but before the report, those measurements aren't considered for billing purposes.

### Is there a delay before Real User Measurements script runs in my webpage?

No, there's no programmed delay before the script is invoked.

### Can I use Real User Measurements with only the Azure regions I want to measure?

No, each time it's invoked, the Real User Measurements script measures a set of six Azure regions as determined by the service. This set changes between different invocations. When many invocations happen, the measurement coverage spans across different Azure regions.

### Can I limit the number of measurements made to a specific number?

You embed the measurement JavaScript within your webpage and you're in complete control over when to start and stop using it. As long as the Traffic Manager service receives a request for a list of Azure regions to measure, it returns a set of regions.

### Can I see the measurements taken by my client application as part of Real User Measurements?

Since your client application runs the measurement logic, you have full control over the process, including access to the latency measurements. Traffic Manager doesn't provide an aggregate view of the measurements received under the key linked to your subscription.

### Can I modify the measurement script provided by Traffic Manager?

While you're in control of what you embed on your web page, don't make any changes to the measurement script. To ensure it measures and reports the latencies correctly, use the script as provided.

### Is it possible for others to see the key I use with Real User Measurements?

When you embed the measurement script on a web page, others can see the script and your Real User Measurements (RUM) key. But this key is different from your subscription ID. Traffic Manager generates the key to be used only for this purpose. Knowing your RUM key doesn't compromise your Azure account safety.

### Can others abuse my RUM key?

While others can use your key to send wrong information to Azure, a few wrong measurements don't change the routing. Routing takes into account all the other measurements it receives. If you need to change your keys, you can regenerate the key. The old key becomes discarded.

### Do I need to put the measurement JavaScript in all my web pages?

Real User Measurements delivers more value as the number of measurements increase. That said, it's your decision whether to put it in all your web pages or a select few. Start by putting it in your most visited page where a user is expected to stay on that page five seconds or more.

### Can Traffic Manager identify information about my end users if I use Real User Measurements?

When you use the provided measurement JavaScript, Traffic Manager has visibility into the client IP address of the end user and the source IP address of the local DNS resolver they use. Traffic Manager uses the client IP address only after truncating it so it can't identify the specific end user who sent the measurements.

### Does the webpage measuring Real User Measurements need to be using Traffic Manager for routing?

No, it doesn't need to use Traffic Manager. The routing side of Traffic Manager operates separately from the Real User Measurement part. Although it's a great idea to have them both in the same web property, they don't need to be.

### Do I need to host any service on Azure regions to use with Real User Measurements?

No, you don't need to host any server-side component on Azure for Real User Measurements to work. Azure hosts and manages the single pixel image that the measurement JavaScript downloads, as well as the service that runs it in different Azure regions. 

### Will my Azure bandwidth usage increase when I use Real User Measurements?

Azure hosts and manages the server-side components of Real User Measurements. This architecture means your Azure bandwidth usage doesn't increase because you use Real User Measurements. This statement doesn't include any bandwidth usage outside of what Azure charges. To minimize the bandwidth used, the measurement only downloads a single pixel image to measure the latency to an Azure region. 

## Traffic View

### What does Traffic View do?

Traffic View is a feature of Traffic Manager that helps you understand more about your users and how their experience is. It uses the queries received by Traffic Manager and the network latency intelligence tables that the service maintains to provide you with the following information:

- The regions where users reside that are connecting to your endpoints in Azure.
- The volume of users connecting from these regions.
- The Azure regions to which they're being routed.
- The users' latency experience routing to these Azure regions.

You can consume this information through geographical map overlay and tabular views in the portal. You can also download the raw data.

### How can I benefit from using Traffic View?

Traffic View gives you the overall view of the traffic your Traffic Manager profiles receive. In particular, it helps you understand where your user base connects from and, equally important, what their average latency experience is. You can then use this information to find areas where you need to focus. For example, expand your Azure footprint to a region that can serve those users with lower latency. Another insight you can derive from using Traffic View is to see the patterns of traffic to different regions, which in turn can help you make decisions on increasing or decreasing investment in those regions.

### How is Traffic View different from the Traffic Manager metrics available through Azure monitor?

You can use Azure Monitor to understand at an aggregate level the traffic your profile and its endpoints receive. It also enables you to track the health status of the endpoints by exposing the health check results. When you need to go beyond these metrics and understand your end user's experience connecting to Azure at a regional level, use Traffic View.

### Does Traffic View use EDNS Client Subnet information?

Azure Traffic Manager considers ECS information in the DNS queries it serves to increase the accuracy of the routing. But when creating the data set that shows where the users are connecting from, Traffic View uses only the IP address of the DNS resolver.

### How many days of data does Traffic View use?

Traffic View creates its output by processing the data from the seven days preceding the day before when you view it. This is a moving window and the latest data is used each time you visit.

### How does Traffic View handle external endpoints?

When you use external endpoints hosted outside Azure regions in a Traffic Manager profile, you can choose to have it mapped to an Azure region, which is a proxy for its latency characteristics. You need this mapping if you use the performance routing method. If the external endpoint has this Azure region mapping, Azure Traffic Manager uses that Azure region's latency metrics when creating the Traffic View output. If you don't specify an Azure region, the latency information is empty in the data for those external endpoints.

### Do I need to enable Traffic View for each profile in my subscription?

During the preview period, enabling Traffic View was at a subscription level. As part of the improvements made before the general availability, you can now enable Traffic View at a profile level, allowing you to have more granular enabling of this feature. By default, Traffic View is disabled for a profile.

>[!NOTE]
>If you enabled Traffic View at a subscription level during the preview time, you now need to re-enable it for each of the profile under that subscription.
 
### How can I turn off Traffic View?

You can turn off Traffic View for any profile by using the portal or REST API. 

### How does Traffic View billing work?

Traffic View pricing is based on the number of data points used to create the output. Currently, the only data type supported is the queries your profile receives. In addition, you only pay for the processing when you have Traffic View enabled. This pricing means that if you enable Traffic View for some time period in a month and turn it off during other times, only the data points processed while you had the feature enabled count towards your bill.

## Traffic Manager endpoints

### Can I use Traffic Manager with endpoints from multiple subscriptions?

You can't use endpoints from multiple subscriptions with Azure Web Apps. Azure Web Apps requires that any custom domain name used with Web Apps is only used within a single subscription. You can't use Web Apps from multiple subscriptions with the same domain name.

For other endpoint types, you can use Traffic Manager with endpoints from more than one subscription. In Resource Manager, you can add endpoints from any subscription to Traffic Manager, as long as you have read access to the endpoint. You can grant these permissions using [Azure role-based access control (Azure RBAC role)](/azure/role-based-access-control/role-assignments-portal). You can add endpoints from other subscriptions using [Azure PowerShell](/powershell/module/az.trafficmanager/new-aztrafficmanagerendpoint) or the [Azure CLI](/cli/azure/network/traffic-manager/endpoint#az-network-traffic-manager-endpoint-create).

### Can I use Traffic Manager with Cloud Service 'Staging' slots?

Yes. You can configure Cloud Service 'staging' slots in Traffic Manager as External endpoints. Health checks are still charged at the Azure Endpoints rate.

### Does Traffic Manager support IPv6 endpoints?

Yes, Traffic Manager fully supports IPv6 endpoints. Traffic Manager provides both IPv4 and IPv6-addressable name servers, so clients can connect seamlessly by using either protocol. IPv6 clients can make DNS requests directly through IPv6-enabled recursive DNS services. Traffic Manager can respond with the DNS name or IP address of the IPv6 endpoint, enabling full compatibility with IPv6 networks. 

### Can I use Traffic Manager with more than one Web App in the same region?

Typically, you use Traffic Manager to direct traffic to applications deployed in different regions. However, you can also use it when an application has more than one deployment in the same region. The Traffic Manager Azure endpoints don't permit more than one Web App endpoint from the same Azure region to be added to the same Traffic Manager profile.

### How do I move my Traffic Manager profile's Azure endpoints to a different resource group or subscription?

Traffic Manager profiles track Azure endpoints using their resource IDs. When you move an Azure resource that's an endpoint (for example, Public IP, Classic Cloud Service, WebApp, or another Traffic Manager profile used in a nested manner) to a different resource group or subscription, its resource ID changes. In this scenario, update the Traffic Manager profile by deleting and then adding back the endpoints to the profile.

For more information, see [To move an endpoint](traffic-manager-manage-endpoints.md#to-move-an-endpoint).

### Can I monitor HTTPS endpoints?

Yes. Traffic Manager supports probing over HTTPS. Configure **HTTPS** as the protocol in the monitoring configuration.

Traffic Manager can't provide any certificate validation, including:

1. Server-side certificates aren't validated
1. SNI server-side certificates aren't validated
1. Client certificates aren't supported

### Do I use an IP address or a DNS name when adding an endpoint?

Traffic Manager supports adding endpoints using three ways to refer to them: 
- As a DNS name 
- As an IPv4 address 
- As an IPv6 address 

If you add an endpoint as an IPv4 or IPv6 address, the query response is of record type A or AAAA, respectively. If you add an endpoint as a DNS name, the query response is of record type CNAME. You can only add endpoints as IPv4 or IPv6 addresses if the endpoint is of type **External**.

All routing methods and monitoring settings support the three endpoint addressing types.

### What types of IP addresses can I use when adding an endpoint?

Traffic Manager accepts IPv4 or IPv6 addresses for endpoints. However, there are some restrictions:

1. You can't use addresses from reserved private IP address spaces. These reserved addresses include those specified in RFC 1918, RFC 6890, RFC 5737, RFC 3068, RFC 2544, and RFC 5771.
1. You can't include port numbers in the IP address. You specify ports in the profile configuration settings.
1. You can't use the same target IP address for two endpoints in the same profile.

### Can I use different endpoint addressing types within a single profile?

No. Traffic Manager doesn't allow you to mix endpoint addressing types within a profile, except for the case of a profile with MultiValue routing type where you can mix IPv4 and IPv6 addressing types.

### What happens when an incoming query's record type is different from the record type associated with the addressing type of the endpoints?

When a query is received against a profile, Traffic Manager first finds the endpoint that needs to be returned as per the routing method specified and the health status of the endpoints. It then looks at the record type requested in the incoming query and the record type associated with the endpoint before returning a response based on the table below.

For profiles with any routing method other than MultiValue:

| Incoming query request | Endpoint type | Response Provided |
|---|---|---|
| ANY | A / AAAA / CNAME | Target Endpoint |
| A | A / CNAME | Target Endpoint |
| A | AAAA | NODATA |
| AAAA | AAAA / CNAME | Target Endpoint |
| AAAA | A | NODATA |
| CNAME | CNAME | Target Endpoint |
| CNAME | A / AAAA | NODATA |

For profiles with routing method set to MultiValue:

| Incoming query request | Endpoint type | Response Provided |
|---|---|---|
| ANY | Mix of A and AAAA | Target Endpoints |
| A | Mix of A and AAAA | Only Target Endpoints of type A |
| AAAA | Mix of A and AAAA | Only Target Endpoints of type AAAA |
| CNAME | Mix of A and AAAA | NODATA |

### What specific responses are required from the endpoint when using TCP monitoring?

When you use TCP monitoring, Traffic Manager starts a three-way TCP handshake by sending a SYN request to the endpoint at the specified port. It then waits for an SYN-ACK response from the endpoint for a period of time (specified in the timeout settings).

1. If an SYN-ACK response is received within the timeout period specified in the monitoring settings, Traffic Manager considers that endpoint healthy. A FIN or FIN-ACK is the expected response from the Traffic Manager when it regularly terminates a socket.
1. If an SYN-ACK response is received after the specified timeout, Traffic Manager responds with an RST to reset the connection.

### How fast does Traffic Manager move my users away from an unhealthy endpoint?

Traffic Manager provides multiple settings you can use to control the failover behavior of your Traffic Manager profile:

1. Set the probing interval to 10 seconds to make Traffic Manager probe the endpoints more frequently. This setting ensures any endpoint going unhealthy is detected as soon as possible.
1. Set how long to wait before a health check request times out (minimum timeout value is 5 seconds).
1. Set how many failures can occur before the endpoint is marked as unhealthy. This value can be as low as 0, in which case the endpoint is marked unhealthy as soon as it fails the first health check. However, using the minimum value of 0 for the tolerated number of failures can lead to endpoints being taken out of rotation due to any transient problems that might occur at the time of probing.
1. Set the time-to-live (TTL) for the DNS response to be as low as 0. By doing this, DNS resolvers can't cache the response and each new query gets a response that incorporates the most up-to-date health information Traffic Manager has.

By using these settings, Traffic Manager can provide failovers in under 10 seconds after an endpoint goes unhealthy and a DNS query is made against the corresponding profile.

### How can I specify different monitoring settings for different endpoints in a profile?

Traffic Manager monitoring settings apply to each profile. If you need to use a different monitoring setting for only one endpoint, create that endpoint as a [nested profile](traffic-manager-nested-profiles.md) whose monitoring settings are different from the parent profile.

### How can I assign HTTP headers to the Traffic Manager health checks to my endpoints?

Traffic Manager allows you to specify custom headers in the HTTP(S) health checks it initiates to your endpoints. If you want to specify a custom header, you can do that at the profile level (applicable to all endpoints) or specify it at the endpoint level. If a header is defined at both levels, the endpoint level header overrides the profile level header.
One common use case for this feature is specifying host headers so Traffic Manager requests route correctly to an endpoint hosted in a multitenant environment. Another use case is to identify Traffic Manager requests from an endpoint's HTTP(S) request logs.

### What are the IP addresses from which the health checks originate?

To learn how to retrieve the lists of IP addresses from which Traffic Manager health checks can originate, see [this article](/azure/virtual-network/service-tags-overview#use-the-service-tag-discovery-api). You can use REST API, Azure CLI, or Azure PowerShell to retrieve the latest list. Review the IPs listed to ensure that incoming connections from these IP addresses are allowed at the endpoints to check its health status.

Example using Azure PowerShell:

```azurepowershell-interactive
$serviceTags = Get-AzNetworkServiceTag -Location eastus
$result = $serviceTags.Values | Where-Object { $_.Name -eq "AzureTrafficManager" }
$result.Properties.AddressPrefixes
```

> [!NOTE]
> Public IP addresses might change without notice. Ensure to retrieve the latest information by using the Service Tag Discovery API or downloadable JSON file.

### How do I set up firewall rules to allow health checks?

Azure Traffic Manager relies on health probes to monitor endpoint availability and performance. For probes to succeed, endpoints must be reachable, and any firewalls or access control lists (ACLs) in the path must allow traffic from all Traffic Manager IP addresses. If you don't allow probe IP addresses, health checks fail. Endpoints marked as unhealthy can cause unexpected traffic rerouting or downtime.

**Option 1: Use service tags (recommended)**
Use the **AzureTrafficManager** service tag in NSGs or Azure Firewall. Service tags automatically include the latest IP ranges and don't require manual updates.

- [Use Service Tags with NSGs](/azure/virtual-network/service-tags-overview#use-service-tags-in-network-security-groups)
- [Use Service Tags with Azure Firewall](/azure/firewall/service-tags)

**Option 2: Manually update firewall rules**
If you can't use service tags (for example, with custom firewall appliances or in non-Azure environments), update ACLs or firewall rules to allow the latest Azure Traffic Manager IPs.

- The full list of IP addresses is published in the [Azure IP Ranges and Service Tags – Public Cloud JSON file](https://www.microsoft.com/download/details.aspx?id=56519).
- Periodically refresh rules to ensure the most up-to-date IP addresses are included.

## Traffic Manager nested profiles

### How do I configure nested profiles?

You can configure nested Traffic Manager profiles by using both Azure Resource Manager and the classic Azure REST APIs. You can also use Azure PowerShell cmdlets and cross-platform Azure CLI commands. The new Azure portal also supports nested profiles.

### How many layers of nesting does Traffic Manager support?

You can nest profiles up to 10 levels deep. 'Loops' aren't permitted.

### Can I mix other endpoint types with nested child profiles, in the same Traffic Manager profile?

Yes. There are no restrictions on how you combine endpoints of different types within a profile.

### How does the billing model apply for nested profiles?

There's no negative pricing impact of using nested profiles.

Traffic Manager billing has two components: endpoint health checks and millions of DNS queries.

1. Endpoint health checks: There's no charge for a child profile when configured as an endpoint in a parent profile. You pay for monitoring the endpoints in the child profile in the usual way.
1. DNS queries: Each query is only counted once. A query against a parent profile that returns an endpoint from a child profile is counted against the parent profile only.

For full details, see the [Traffic Manager pricing page](https://azure.microsoft.com/pricing/details/traffic-manager/).

### Is there a performance impact for nested profiles?

No, there's no performance impact when you use nested profiles.

The Traffic Manager name servers traverse the profile hierarchy internally when processing each DNS query. A DNS query to a parent profile can receive a DNS response with an endpoint from a child profile. A single CNAME record is used whether you're using a single profile or nested profiles. You don't need to create a CNAME record for each profile in the hierarchy.

### How does Traffic Manager compute the health of a nested endpoint in a parent profile?

The parent profile doesn't perform health checks on the child directly. Instead, it uses the health of the child profile's endpoints to calculate the overall health of the child profile. This information propagates up the nested profile hierarchy to determine the health of the nested endpoint. The parent profile uses this aggregated health to determine whether it can direct traffic to the child.

The following table describes the behavior of Traffic Manager health checks for a nested endpoint.

| Child Profile Monitor status | Parent Endpoint Monitor status | Notes |
|---|---|---|
| **Disabled**. The child profile is disabled. | Stopped | The parent endpoint state is `Stopped`, not `Disabled`. The `Disabled` state indicates that you disabled the endpoint in the parent profile. |
| **Degraded**. At least one child profile endpoint is in a `Degraded` state. | **Online**: the number of `Online` endpoints in the child profile is at least the value of `MinChildEndpoints`.<BR>**CheckingEndpoint**: the number of `Online` plus `CheckingEndpoint` endpoints in the child profile is at least the value of `MinChildEndpoints`.<BR>**Degraded**: otherwise. | Traffic is routed to an endpoint of status `CheckingEndpoint`. If `MinChildEndpoints` is set too high, the endpoint is always degraded. |
| **Online**. At least one child profile endpoint is an `Online` state. No endpoint is in the `Degraded` state. | See above. | |
| CheckingEndpoints. At least one child profile endpoint is `CheckingEndpoint`. No endpoints are `Online` or `Degraded` | Same as above. | |
| **Inactive**. All child profile endpoints are either `Disabled` or `Stopped`, or this profile has no endpoints. | Stopped | |

> [!IMPORTANT]
> When you manage child profiles under a parent profile in Azure Traffic Manager, an issue can occur if you simultaneously disable and enable two child profiles. If these actions occur at the same time, there might be a brief period when both endpoints are disabled, leading to the parent profile entering a compromised state.<br><br>
> To avoid this problem, exercise caution when making simultaneous changes to child profiles. Consider staggering these actions slightly to prevent unintended disruptions to your traffic management configuration. 

### Why can't I add Azure Cloud Services Extended Support Endpoints to my Traffic Manager profile? 

To add Azure Cloud Extended endpoints to a Traffic Manager profile, the resource group must be compatible with the Azure Service Management (ASM) API. Profiles located in the older resource group must adhere to ASM API standards, which prohibit the inclusion of public IP address endpoints or endpoints from a different subscription than that of the profile. To resolve this problem, consider moving your Traffic Manager profile and associated resources to a new resource group compatible with the ASM API.

## Next steps

1. Learn more about Traffic Manager [endpoint monitoring and automatic failover](traffic-manager-monitoring.md).
1. Learn more about Traffic Manager [traffic routing methods](traffic-manager-routing-methods.md).
