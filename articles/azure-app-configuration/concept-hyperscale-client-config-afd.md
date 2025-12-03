---
title: Hyperscale Configuration Delivery via Azure Front Door (Preview) 
description: Learn how to leverage hyperscale configuration delivery to your applications via Azure Front Door.
author: avanigupta
ms.author: avgupta
ms.service: azure-app-configuration
ms.topic: concept-article 
ms.date: 12/02/2025
---

## Configuration Management for Client Applications (Preview) 

Client applications have fundamentally different configuration requirements than server applications due to their scale and direct user interaction. They serve millions of users who expect instant app launches and seamless updates. These applications run on diverse devices across unreliable networks worldwide and the system needs to be lightweight on the client side yet powerful enough to apply changes on the fly. Since client applications cannot securely store credentials, they need anonymous access to configuration data. Direct API calls from millions of clients would result in prohibitive costs and require massive backend scaling. For most client scenarios, eventual consistency is acceptable, allowing the use of edge caching strategies. Azure App Configuration integrated with Azure Front Door solves this by combining centralized management with edge delivery, ensuring your configuration reaches users instantly while keeping your applications responsive and current.

## CDN-Accelerated Configuration Delivery with Azure Front Door

App Configuration gives developers a single, consistent place to define configuration settings and feature flags. Until now, this capability was used almost exclusively by server-side applications. By integrating Azure App Configuration with Azure Front Door, your configuration data is centrally managed through Azure App Configuration while being cached and distributed through Azure's content delivery network. This architecture transforms configuration management from a traditional client-server model to a globally distributed system, where configuration data is served from Azure Front Door's edge locations rather than making direct calls to the App Configuration service. This architecture is particularly valuable for client-facing applications including mobile, desktop, and browser-based applications.

## System Architecture

:::image type="content" source="media/concept-afd-architecture.png" alt-text="Architecture diagram for integration of Azure Front Door with Azure App Configuration."

How it works
- The client application calls Azure Front Door anonymously, like any CDN asset.
- Azure Front Door uses managed identity to access Azure App Configuration securely.
- Only selected key-values, feature flags or snapshots are exposed through Azure Front Door.
- No secrets or credentials are shipped to the client.
- Edge caching enables high throughput and low latency configuration delivery.
- This provides a secure and efficient design for client applications and eliminates the need for custom gateway code or proxy services to load configuration from Azure App Configuration.

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

### Failover and Load Balancing with Azure Front Door

Client applications rely on Azure Front Door for failover and load balancing, as they don't connect directly to App Configuration. Configure your App Configuration replicas as origins in the Azure Front Door endpoint to enable automatic failover and geo-redundant configuration delivery. For details on how origin groups improve availability and performance, see [Azure Front Door routing methods](/azure/frontdoor/routing-methods)

### Access scoping through key-value filters

Configure one or more filters to control which requests pass through Azure Front Door. This prevents accidental exposure of sensitive configuration and ensures only the settings your application needs are accessible. Here are some important considerations:

- Configure Azure Front Door filters to precisely match your application's configuration requirements. Only expose the exact key patterns your application uses. For example, if your application loads keys with the "App1:" prefix, configure the Azure Front Door rule to allow only "App1:" keys, not broader patterns like "App". Loose filtering increases security risks by exposing unintended data, bypasses cache optimizations and reduces cache effectiveness, and may cause service throttling due to excessive requests to your App Configuration store.

- If you application loads feature flags, provide ".appconfig.featureflag/{YOUR-FEATURE-FLAG-PREFIX}" filter for the Key with *Starts with* operator.

- If you are using App Configuration provider libraries and your application loads ONLY feature flags, you should add 2 key filters in the Azure Front Door rules - one for ALL keys with no label and second for all keys starting with ".appconfig.featureflag/{YOUR-FEATURE-FLAG-PREFIX}". This is because App Configuration provider libraries load all key-values with no label by default when no key-value selector is specified. 

### Access scoping through multiple endpoints

Create separate Azure Front Door endpoints for applications with different configuration requirements. This approach improves security by isolating each application's configuration access and simplifies filter management. Rather than combining multiple filter rules in a single endpoint - which increases complexity and security risks - each application connects to its dedicated endpoint with precisely scoped filters. This prevents applications from accessing each other's configuration data and makes access control more manageable.

### Access scoping through multiple App Configuration stores

Consider using a dedicated App Configuration store for client-facing configuration delivered through Azure Front Door. This store should contain only non-sensitive settings that are safe for public consumption. This isolation strategy limits potential impact if configuration is inadvertently exposed, ensuring that sensitive data remains protected in separate stores accessible only by server-side applications.

### Cache duration

Configure Azure Front Door cache duration to balance performance and origin load. We recommend a minimum TTL of 10 minutes, but you can choose a value that fits your application. Content loaded from AFD will be eventually consistent. Setting the cache duration too short may increase origin requests and lead to throttling. 

## Next steps

> [!div class="nextstepaction"]
> [Setup Azure Front Door with App Config](./how-to-connect-azure-front-door.md)

> [!div class="nextstepaction"]
> [Load Configuration from Azure Front Door in Client Applications](./howto-configproviders-afd.md)

