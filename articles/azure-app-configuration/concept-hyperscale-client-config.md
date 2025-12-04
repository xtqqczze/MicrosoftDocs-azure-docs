---
title: Hyperscale Configuration Delivery via Azure Front Door (Preview) 
description: Learn how to use hyperscale configuration delivery to your applications via Azure Front Door.
author: avanigupta
ms.author: avgupta
ms.service: azure-app-configuration
ms.topic: concept-article 
ms.date: 12/02/2025
---

# Configuration Management for Client Applications (Preview) 

Client applications have fundamentally different configuration requirements than server applications due to their scale and direct user interaction. They serve millions of users who expect instant app launches and seamless updates. These applications run on diverse devices across unreliable networks worldwide and the system needs to be lightweight on the client side yet powerful enough to apply changes on the fly. Since client applications can't securely store credentials, they need anonymous access to configuration data. For most client scenarios, eventual consistency is acceptable, allowing the use of edge caching strategies. The integration of Azure App Configuration with Azure Front Door combines centralized configuration management with edge-based content delivery, providing unified control and instant global access of your configuration.

## CDN-Accelerated Configuration Delivery with Azure Front Door

App Configuration gives developers a single, consistent place to define configuration settings and feature flags. Until now, this capability was used almost exclusively by server-side applications. By integrating Azure App Configuration with Azure Front Door, your configuration data is centrally managed through Azure App Configuration while being cached and distributed through Azure's content delivery network. This architecture is valuable for client-facing applications including mobile, desktop, and browser-based applications.

## System Architecture

:::image type="content" source="media/hyperscale-config-architecture.png" alt-text="Architecture diagram for integration of Azure Front Door with Azure App Configuration."

How it works
- The client application calls Azure Front Door anonymously, so no secrets or credentials are shipped to the client.
- Azure Front Door uses Managed Identity to access Azure App Configuration securely.
- Only selected key-values, feature flags, or snapshots are exposed through Azure Front Door.
- Edge caching enables high throughput and low latency configuration delivery.

This architecture eliminates the need for custom proxies or gateways while providing secure, efficient configuration delivery to client applications.

## Developer Scenarios

CDN-delivered configuration unlocks a range of rich client application scenarios:

- Client-side feature rollouts for UI components
- A/B testing or targeted experiences using feature flags
- Control AI/LLM model parameters and UI behaviors through configuration
- Dynamically control client-side agent behavior, safety modes, and guardrail settings through configuration
- Consistent behavior for clients using snapshot-based configuration

These scenarios previously required custom proxies. Now, they work out-of-the-box with Azure App Configuration and Azure Front Door integration.

> [!NOTE]
> This feature is only available in the Azure public cloud.

## Recommendations and Considerations

### Security

Configuration exposed through Azure Front Door is publicly accessible without authentication, making proper security controls essential. Implement the following strategies to protect your configuration data from unintended exposure.

##### Use separate App Configuration store

Consider using a dedicated App Configuration store for client-facing configuration delivered through Azure Front Door. This store should contain only nonsensitive settings that are safe for public consumption. This isolation strategy limits potential impact if configuration is inadvertently exposed, ensuring that sensitive data remains protected in separate stores.

##### Role Based Access Control using Managed Identity

Azure Front Door accesses App Configuration data using either its system-assigned managed identity or a user-assigned managed identity. The selected identity requires the `App Configuration Data Reader` role to retrieve configuration data. When you create the Azure Front Door endpoint through the App Configuration portal, this role assignment occurs automatically. The portal displays a warning if the role assignment encounters any issues. Restrict the managed identity to the `App Configuration Data Reader` role only and avoid assigning any roles with write permissions.

### Request Scoping

Configure one or more filters to control which requests are allowed to pass through Azure Front Door.This prevents anonymous clients from bypassing the CDN cache through excessive or malformed requests that could overwhelm App Configuration and trigger service throttling.

##### Request scoping through key-value filters

- Configure Azure Front Door filters to precisely match your application's configuration requirements. Only expose the exact key patterns your application uses. For example, if your application loads keys with the `"App1:"` prefix, configure the Azure Front Door rule to allow only `"App1:"` keys, not broader patterns like `"App"`.

- If your application loads feature flags, provide `".appconfig.featureflag/{YOUR-FEATURE-FLAG-PREFIX}"` filter for the Key with *Starts with* operator.

- If you're using App Configuration provider libraries and your application loads ONLY feature flags, you should add two key filters in the Azure Front Door rules - one for `ALL` keys with no label and second for all keys starting with `".appconfig.featureflag/{YOUR-FEATURE-FLAG-PREFIX}"`. This is because App Configuration provider libraries load all key-values with no label by default when no key-value selector is specified. 

##### Request scoping through multiple Azure Front Door endpoints

Create separate Azure Front Door endpoints for applications with different configuration requirements. Rather than combining multiple filter rules in a single endpoint, each application connects to its dedicated endpoint with precisely scoped filters. This approach prevents applications from accessing each other's configuration data and simplifies filter management.

### Failover and Load Balancing

Client applications rely on Azure Front Door for failover and load balancing, as they don't connect directly to App Configuration. To enable automatic failover and geo-redundant configuration delivery, configure your App Configuration replicas as origins in the Azure Front Door endpoint. For details on how origin groups improve availability and performance, see [Azure Front Door routing methods](/azure/frontdoor/routing-methods)

### Caching

Configure Azure Front Door cache duration to balance performance and origin load. We recommend a minimum TTL of 10 minutes, but you can choose a value that fits your application. Content loaded from AFD is eventually consistent. Setting the cache duration too short might increase origin requests and lead to throttling. 

## Next steps

> [!div class="nextstepaction"]
> [Setup Azure Front Door with App Config](./how-to-connect-azure-front-door.md)

> [!div class="nextstepaction"]
> [Load Configuration from Azure Front Door in Client Applications](./how-to-load-azure-front-door-configprovider.md)

