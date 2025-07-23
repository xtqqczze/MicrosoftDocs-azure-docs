---
title: Client IP preservation with Layer 4 proxy
description: This article explains the details of Client IP preservation with Azure Application Gateway's TLS/TCP proxy.
services: application-gateway
author: mbender-ms
ms.service: azure-application-gateway
ms.topic: concept-article
ms.date: 07/23/2025
ms.author: mbender
---

# Client IP preservation on Layer 4 Application Gateway 

When using TLS/TCP proxy of Application Gateway, the originating client IP is not preserved by default because Application Gateway performs an SNAT (Source Network Address Translation) of the ip address. In other words, the backend server always sees the source IP as the address of the fronting application gateway resource. In some cases, the original client IP address is required as it provides critical context and control for how the traffic is processed and handled by backend systems. Without it, the backend application might not operate due to incomplete or misleading data. The use-case of knowing the client IP could be many, some of which are listed below. 

* Application logic – the backend server application needs to be source IP aware for session management, access control or applying a business process like personalized response.
* Security and Auditing – Need IP info for traceability or maintain logs for audit purposes.
* Legal or Compliance requirements - Some regulations (like GDPR or HIPAA) may require logging of client IPs for data access tracking or incident response.
* Analytics and Monitoring – To gain traffic pattern insights 

## Details of client IP preservation with Layer 4 proxy  

The client IP preservation for Layer 7 proxy (HTTP/S protocols) is supported by default wherein Application Gateway includes the [x-forwarded-for header](how-application-gateway-works.md#modifications-to-the-request), having the original client IP information, in all requests that are proxied to the backend servers. 

In contrast, the Layer 4 proxy feature of Application Gateway doesn’t preserve any client IP by default. As a result, the backend server will either see the public IP address of the application gateway or the private IP address of one of the serving instances. To preserve the client IP with Layer 4 proxy, Application Gateway uses Proxy protocol header V1. This header-based protocol carries the essential metadata of the incoming frontend connection (source IP, destination IP and the ports) and is sent during the backend TCP connection. The Proxy protocol header must be specifically enabled in the Backend Settings for TLS or TCP protocol. 

When enabled, your Application Gateway resource sends a Proxy protocol header to the backend server. This header is sent immediately after the TCP handshake is complete, and before the TCP data stream begins. In case of TLS protocol Backend Settings, the Proxy protocol header precedes the TLS handshake process.

**TCP protocol:** 
`TCP handshake --> Proxy protocol header --> Data stream`

**TLS protocol:** 
`TCP handshake --> Proxy protocol header --> TLS handshake --> Data stream`

> [!TIPS]
> * Client IP preservation works with both IPv4 and IPv6 client addresses.
> * Application Gateway does not parse Proxy protocol headers on listeners. When another proxy is positioned in front of the application gateway resource, the incoming proxy header is forwarded to the backend servers as part of the data stream. Application Gateway neither drops nor modifies the incoming proxy protocol header, so the backend servers may receive multiple proxy protocol headers in these situations.

## Configurations 

The following configurations are supported for Proxy protocol headers in Application Gateway. 

**Backend Settings** – You can enable Client IP Preservation in the backend setting with TLS or TCP protocol. This sends the proxy protocol header to the backends during the live traffic originating from the clients. 

**Health probes** – The probes of the application gateway also support Proxy protocol header. When proxy protocol setting is enabled in the Backend Settings, the default health probes send this header to the backend servers. With custom probes, you can configure this setting specifically for that probe. You may also use a different port for that probe, if necessary.

---
### [REST API](#tab/restapi)

| Property Name | Parent property name | Value |
| ---------- | ---------- | ---------- |
| EnableClientIpPreservation | ApplicationGatewayBackendSettings | Boolean |
| EnableProbeProxyProtocolHeader | ApplicationGatewayProbe | Boolean |



## Format of Proxy Protocol header 

The Proxy protocol header V1 in Application Gateway is a single line of user-readable text structured in the following format:

**Live traffic**

`PROXY TCP4  <client-ip> <backend-server-ip> <client-port> <backend-server-port> \r\n `

* Protocol version: A string showing the protocol version.
* IPv4 or IPv6 protocol: TCP over IPv4 or TCP over IPv6. Accordingly, its value can be TCP4, TCP6, or UNKNOWN when metadata is not available.
* Source IP: The original client IP’s address.
* Destination IP: This is the IP address of the
* Source port: The original client’s port number.
* Destination port: The listener port number on which the connection was received.
* \r\n indicating end of line 

**Probe traffic**

`PROXY UNKNOWN\r\n `
When the client ip is unknown, as in the case of application gateway probes, the backends see the proxy protocol header as unknown. 



## Next steps

