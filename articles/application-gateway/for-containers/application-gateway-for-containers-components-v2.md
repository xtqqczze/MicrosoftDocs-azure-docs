---
title: Application Gateway for Containers components - Concept
description: This article provides information about how Application Gateway for Containers accepts incoming requests and routes them to a backend target.
services: application-gateway
author: mbender-ms
ms.service: azure-appgw-for-containers
ms.topic: concept-article
ms.date: 12/05/2025
ms.author: mbender
# Customer intent: "As a cloud architect, I want to understand the components of Application Gateway for Containers, so that I can effectively configure and manage traffic routing to backend services in my cloud deployment."
---

# Application Gateway for Containers components

This article describes the components of Application Gateway for Containers and explains how it processes incoming requests and routes them to backend targets. For a general overview, see [What is Application Gateway for Containers](overview.md).

## Architecture overview

Application Gateway for Containers uses a parent-child resource model:

- **Parent resource**: The main Application Gateway for Containers resource deploys and manages the control plane.
- **Child resources**: Associations and frontends that belong exclusively to their parent resource.

The control plane orchestrates proxy configuration based on your requirements.

## Component descriptions

### Frontends

A frontend defines where client traffic enters your Application Gateway for Containers.

**Key features:**
- Provides a unique Azure-managed FQDN that you can use directly or reference with a CNAME record
- Belongs to exactly one Application Gateway for Containers instance
- Supports multiple frontends per Application Gateway for Containers
- Currently doesn't support private IP addresses

### Associations

An association connects Application Gateway for Containers to your virtual network.

**Key features:**
- Creates a 1:1 mapping between an association resource and a delegated Azure subnet
- Currently limited to 1 association per Application Gateway for Containers
- Provisions the data plane during creation and connects it to the specified subnet
- Must be in the same region as the parent Application Gateway for Containers

**Subnet requirements:**
- Minimum of 256 available IP addresses at provisioning time
- Use a /24 subnet mask for deployments in subnets without existing resources
- For multiple Application Gateway for Containers sharing a subnet, calculate required addresses as: *n* × 256 (where *n* = number of instances)

### ALB Controller

The ALB Controller is a Kubernetes deployment that manages Application Gateway for Containers configuration.

**Components:**
- **alb-controller**: Translates Kubernetes resources (Ingress, Gateway, ApplicationLoadBalancer) into Application Gateway for Containers configuration
- **alb-controller-bootstrap**: Manages Custom Resource Definitions (CRDs)

**Deployment:**
- Install using Helm
- Uses ARM and Application Gateway for Containers APIs to apply configuration changes

### Security policies

Security policies define security configurations for your Application Gateway for Containers.

**Key features:**
- Multiple security policies can reference a single Application Gateway for Containers
- Currently supports `waf` type for Web Application Firewall capabilities
- Each `waf` security policy maps 1:1 to a Web Application Firewall policy resource
- A single WAF policy can be referenced by multiple security policies

## Azure concepts

### Subnet delegation

**Microsoft.ServiceNetworking/trafficControllers** is the namespace for Application Gateway for Containers subnet delegation.

**Behavior:**
- Delegating a subnet doesn't automatically create Application Gateway for Containers resources
- Multiple subnets can use the same or different delegation settings
- After delegation, only the specified service can provision resources in that subnet

### User-assigned managed identity

Managed identities eliminate the need for credential management in your code.

**Requirements:**
- Each ALB Controller requires a user-assigned managed identity
- Assign the built-in **AppGw for Containers Configuration Manager** role to the identity

 > [!NOTE]
 > The **AppGw for Containers Configuration Manager** role includes [data action permissions](../../role-based-access-control/role-definitions.md#control-and-data-actions) that Owner and Contributor roles don't have. Proper role assignment is critical for ALB Controller to function correctly.

## Request processing

### How requests are accepted

1. **DNS resolution**: Clients resolve either:
   - A CNAME record pointing to the frontend's Azure-managed FQDN, or
   - The frontend's FQDN directly

2. **Request routing**: The DNS name becomes the host header in requests to Application Gateway for Containers

3. **Backend selection**: Routing rules evaluate the hostname to determine the appropriate backend target

### Protocol support

**Client to frontend:**
- Supports both HTTP/2 and HTTP/1.1
- HTTP/2 is always enabled (clients can negotiate HTTP/1.1 if preferred)

**Frontend to backend:**
- Uses HTTP/1.1 for standard traffic
- Uses HTTP/2 for gRPC traffic

### Request headers

Application Gateway for Containers adds these headers to backend requests:

| Header | Description | Example |
|--------|-------------|---------|
| **x-forwarded-for** | Chain of client and proxy IP addresses | `1.2.3.4,5.6.7.8` (client IP: 1.2.3.4, proxy IP: 5.6.7.8) |
| **x-forwarded-proto** | Protocol used by the client | `http` or `https` |
| **x-request-id** | Unique identifier for request correlation | `aaaa0000-bb11-2222-33cc-444444dddddd` |

### Timeout configuration

| Timeout type | Duration | Purpose |
|--------------|----------|---------|
| Request Timeout | 60 seconds | Maximum time to wait for backend response |
| HTTP Idle Timeout | 5 minutes | Time before closing idle HTTP connections |
| Stream Idle Timeout | 5 minutes | Time before closing idle HTTP streams |
| Upstream Connect Timeout | 5 seconds | Time allowed to establish backend connections |

> [!NOTE]
> The Request Timeout enforces completion within the specified time, regardless of whether data is streaming or the connection is idle. For large file downloads that exceed 60 seconds due to size or transfer speed, increase the timeout value or set it to 0 (unlimited).

## Related content

- [What is Application Gateway for Containers](overview.md)
- [Deploy Application Gateway for Containers](quickstart-deploy-application-gateway-for-containers-alb-controller.md)