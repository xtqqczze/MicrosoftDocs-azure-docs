---
title: Migrate Amazon API Gateway to Azure API Management
description: Step-by-step migration guide for Amazon API Gateway to Azure API Management. Includes assessment, preparation, evaluation, process, and iterative optimization.
#customer intent: As the administrator of an Amazon API Gateway service, I want to migrate to Azure API Management and need detailed guidance
author: dlepow
ms.author: danlep
ms.reviewer: 
ms.service: azure-api-management
ms.date: 10/28/2025
ms.topic: upgrade-and-migration-article
ms.collection:
  - migration
  - aws-to-azure
---

# Migrate Amazon API Gateway to Azure API Management

If you use Amazon API Gateway and want to migrate your workload to Azure, this guide helps you understand feature mappings, best practices, and the migration process. On Azure, [Azure API Management](api-management-key-concepts.md) provides API gateway capabilities including API request and response routing, authorization and access control, monitoring and governance, and API version management.

You'll learn how to:

- Assess your current Amazon API Gateway deployment
- Plan and prepare the migration
- Execute the transition while maintaining API availability and performance

## What you'll accomplish

By following this guide, you'll:

- Map Amazon API Gateway to Azure API Management capabilities
- Prepare your Amazon and Azure environments for a successful migration
- Plan and execute a migration with minimal downtime
- Validate that your migrated workload meets performance and reliability requirements
- Learn to iterate on the architecture for future enhancements

## Example scenario: Multi-backend health records system

A health services organization uses Amazon API Gateway to access a multi-backend health records system. This example scenario features a common configuration of Amazon API Gateway in an Amazon Web Services (AWS) environment. It shows typical integrations with related Amazon services and several common API backends, including proxied Lambda functions and HTTP or REST APIs.  
  
:::image type="complex" source="media/migrate-amazon-api-gateway-to-api-management/example-api-gateway-architecture.png" alt-text="Amazon API Gateway architecture where a user request flows through Cognito, WAF, and API Gateway to VPC endpoints hosting Lambda, EC2, and EKS." lightbox="media/migrate-amazon-api-gateway-to-api-management/example-api-gateway-architecture.png":::
  The diagram shows an Amazon API Gateway architecture integrated with multiple AWS services. On the far left, a user sends a request with a JWT and authenticates through Cognito. The flow moves right into Amazon WAF, then to API Gateway, which connects upward to a custom domain and downward to Certificate Manager for storing certificates and CloudWatch for monitoring. From API Gateway, three VPC endpoints branch out to the right, each leading into a VPC box containing private subnets. The top subnet hosts a Lambda function, the middle subnet contains an Application Load Balancer connected to an EC2 instance, and the bottom subnet has another Application Load Balancer connected to an EKS cluster. Arrows indicate sequential flow from the user through authentication and API Gateway to these backend components inside the VPC.
:::image-end:::  

This architecture includes:
  
- **User authentication** via Amazon Cognito with JWT tokens.

- **Security filtering** of requests through Amazon Web Application Firewall (WAF) before reaching Amazon API Gateway.

- **Amazon API Gateway** configured with a custom domain using a certificate stored in Certificate Manager.

- **Monitoring** using Amazon CloudWatch.

- **Private connectivity** through Virtual Private Cloud (VPC) endpoints to three private subnets.

- **Backend services** including Lambda to trigger patient record updates, Amazon Compute Cloud (EC2) hosting legacy services behind Application Load Balancer, and Amazon Elastic Kubernetes Service (EKS) behind Application Load Balancer for data processing via microservices.

Here's an example architecture of the workload migrated to Azure. In this scenario, Azure API Management is deployed in the Premium tier.  
  
:::image type="complex" source="media/migrate-amazon-api-gateway-to-api-management/example-migrated-api-management-architecture.png" alt-text="Azure API Management architecture where a user request flows through Microsoft Entra ID, Application Gateway, and API Management to Azure Functions, Azure Kubernetes Service, and Azure AI Foundry backends." lightbox="media/migrate-amazon-api-gateway-to-api-management/example-migrated-api-management-architecture.png":::
  The diagram illustrates an Azure API Management architecture within a virtual network. On the far left, a user sends a request with a JWT and authenticates through Microsoft Entra ID. The flow enters an Application Gateway with WAF, which forwards traffic to API Management integrated with Entra ID. API Management validates the JWT and interacts with several components: it uses Redis cache for caching, stores certificates in Azure Key Vault, and monitors via Azure Monitor. Above API Management, a custom domain is linked to Azure DNS Zone, and Entra ID is shown as part of authentication. To the right, API Management connects to a Function App, which includes a function key, and also routes traffic through an Internal Load Balancer to a Kubernetes cluster. Additionally, Azure AI Foundry is shown as a connected service. Dashed arrows indicate relationships such as validation, monitoring, and certificate storage, while solid arrows represent the main request flow from the user through Application Gateway and API Management to backend services.
:::image-end:::

This architecture includes:

- **Secure entry** via Application Gateway with WAF, forwarding requests with a JWT added for authentication.

- **Azure API Management** configured inside a virtual network, validating JWTs with **Microsoft Entra ID**.

- **Internal Load Balancer** routing traffic to **Azure Kubernetes Service (AKS)** for microservices-based backends.

- Secure connections via private endpoints to **Azure Function apps** and **Azure AI Foundry** backends.

- **Monitoring** handled by **Azure Monitor**.

- **Certificates and domain** managed via **Azure Key Vault** and **Azure DNS Zone**. Certificate is also configured on Application Gateway for TLS termination.

### Architectural overview

This architecture example showcases common features in Amazon API Gateway and Azure API Management, including network isolation, traffic management and routing to various backend APIs, authorization and access control, and monitoring.

Both architectures provide comparable functionality, including:

- **High availability deployment** - Resources are distributed across multiple availability zones in a region for fault tolerance, with option for higher availability by deployment to multiple regions.

- **Custom domains and certificates** - The platforms support custom domain names with TLS/SSL termination for secure API communication. 

- **Network isolation** – Traffic to backend APIs is isolated in a virtual network.

- **Traffic filtering** – A web application firewall at the edge filters and protects inbound traffic.

- **API workload support** – Gateways proxy requests to diverse backend systems including cloud compute services, Kubernetes-based microservices, and custom backends.

- **API monitoring** - Built-in platform services log API activity and expose service metrics.

- **API modulation** – Services support response caching, request quotas and rate limits, CORS configuration, and request/response transformations.

- **API authentication and authorization** – Gateways support multiple access methods including keys, OAuth token-based access, and API-based policies.


## Step 1: Assessment

Before you migrate from Amazon API Gateway to Azure API Management, assess the existing infrastructure features, API workloads, and API configurations and identify capabilities to map or replace. This assessment helps ensure a smooth migration and maintains your applications' functionality.  
  
> [!NOTE]
> Amazon API Gateway capabilities can vary depending on whether you expose your APIs as a REST API or an HTTP API product type. In Azure API Management, capabilities vary by service tier, not by API type designation.

### Assessment - Infrastructure capabilities

| **Amazon API Gateway capability** | **Azure API Management equivalent** | **Migration approach** |
|---|---|---|
| [Private VPC endpoints](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-private-api-create.html) | [Deploy Azure API Management instance to internal VNet](api-management-using-with-internal-vnet.md)<br><br>[Integrate API Management with a private virtual network for outbound connections](integrate-vnet-outbound.md) | Configure dedicated subnets for backends in a virtual network where the Azure API Management service is injected or integrated, or reach backends through Private Link. |
| [AWS Web Application Firewall](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-control-access-aws-waf.html) | [Azure Web Application Firewall](/azure/web-application-firewall/overview), for example, in Azure Application Gateway (a regional service) or Azure Front Door (a global service).  | Map WAF rules applied at API stages in Amazon API Gateway to service-level rules in Azure WAF. |
| [Custom domains](https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-custom-domains.html) | [Custom domains](configure-custom-domain.md?tabs=custom) configured in Azure API Management and upstream entry point such as Application Gateway or Front Door. | Utilize the same domain names and existing certificates with an external DNS cutover. If the migration uses different domain names, you need to obtain new certificates. |
| [Edge-optimized endpoints](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-endpoint-types.html) | [Multi-region deployment](api-management-howto-deploy-multi-region.md) | Configure Azure API Management gateways in multiple regions depending on requirements for client access. This topology is typically paired with Azure Front Door's global point of presence. |
| [Availability zones by default](https://docs.aws.amazon.com/apigateway/latest/developerguide/disaster-recovery-resiliency.html) | [Availability zones by default](enable-availability-zone-support.md) (Premium tier) | Deploy Azure API Management instance in the Premium tier in a region that supports availability zones. Use the default automatic configuration of availability zones. |
| [CloudWatch metrics](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-metrics-and-dimensions.html) | [Azure Monitor metrics](monitor-api-management.md) | Configure gateway request metrics to support comparison of Azure API Management performance against baseline in Amazon API Gateway. |
| [CloudWatch logs](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html) and [CloudTrail logs](https://docs.aws.amazon.com/apigateway/latest/developerguide/cloudtrail.html) | [Azure Monitor logs](monitor-api-management.md) | Configure diagnostic settings to send Azure API Management logs to a Log Analytics workspace for built-in analytics and custom analysis. Consider deploying Application Insights or other [observability tools](observability.md) for added operational monitoring. |

> [!NOTE]
> Establish baseline metrics from Amazon API Gateway before migration. Use these baselines to compare Azure API Management performance after migration and confirm it meets or exceeds expectations.

#### Capability mismatches and strategies

- **WAF integration** in Amazon API Gateway doesn't have a direct match in Azure API Management. In Amazon API Gateway, WAF rules are directly applied on REST API stages. In Azure API Management, configuration of WAF rules typically requires deployment of an upstream Application Gateway service and traffic forwarding and TLS termination through the application gateway. Alternatively, for active-active, multiregion scenarios, use Azure Front Door in front of Azure API Management.
- **Custom domains** are supported on Azure API Management, but if you use Application Gateway WAF in front, you must also configure the custom domain and TLS certificate at the Application Gateway layer.
- **Edge-optimized endpoints** in Amazon API Gateway support geographically distributed clients. Similar capability in Azure API Management requires deployment of extra regional gateways at extra cost.

### Assessment – API workload comparison

As part of the assessment, consider whether to retain or replace existing services. Evaluate if the migration is an opportunity to modernize or consolidate services.

| **Amazon API Gateway workload** | **Azure API Management equivalent** | **Migration approach** |
|---|---|---|
| [Lambda proxy integration](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-lambda.html)<br><br>[Lambda non-proxy (custom) integration](https://docs.aws.amazon.com/apigateway/latest/developerguide/getting-started-lambda-non-proxy-integration.html)<br><br>[Invoking Lambda using an Amazon API Gateway endpoint](https://docs.aws.amazon.com/lambda/latest/dg/services-apigateway.html) | [Azure Function app API type](import-function-app-as-api.md) | Consider whether to retain or replace existing Lambdas (for example, with Azure Functions or containers). |
| [REST APIs](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-rest-api.html)<br><br>[HTTP APIs](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html) | [Import an OpenAPI specification](import-api-from-oas.md?tabs=portal) | [Export a REST API from Amazon API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-export-api.html) and import in Azure API Management, or manually access API configuration in Amazon API Gateway and recreate in Azure API Management. |
| [WebSocket APIs](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-overview.html) | [WebSocket API type](websocket-api.md?tabs=portal) | Manually access API configuration in Amazon API Gateway and recreate in Azure API Management |


#### Capability mismatches and strategies

- **Lambda backends** are supported natively in Amazon API Gateway as HTTP APIs. Azure API Management doesn't provide native integration with the comparable Azure Function apps. Azure API Management must call function apps over HTTP with a function key or managed identity.
- **OpenAPI specifications** exported from an Amazon API Gateway REST API contain details specific to the front-end implementation in Amazon API Gateway, not the backend service. You need to remove AWS-specific tags and configure details in the specification such as the backend service URL before import to Azure API Management or during the migration process. 
- **Kubernetes microservices** backends such as gRPC APIs are handled differently.
  - Amazon API gateway connects to Application Load Balancer in a VPC, which in turn provides ingress to AWS EKS.
  - Azure API Management supports gRPC APIs on Kubernetes clusters accessed only through the self-hosted gateway.
  - Use of gRPC prevents use of Application Gateway as a WAF. 

### Assessment – API configuration comparison

The migration approach for API configurations must consider the *scope* of the configuration in Amazon API Gateway. At a high level, API scopes map as follows from Amazon API Gateway to Azure API Management:

| **Amazon API Gateway API scope** | **Azure API Management equivalent** |
|----|----|
| API resource | API |
| API stage | API version |
| API method | API operation |
| Usage plan | Product |

The following table assesses API configurations in Amazon API Gateway and equivalent configurations in Azure API Management.

| **Amazon API Gateway API configuration** | **Azure API Management equivalent** | **Migration approach** |
|---|---|---|
| [Stage variables](https://docs.aws.amazon.com/apigateway/latest/developerguide/stage-variables.html) | [Named values](api-management-howto-properties.md?tabs=azure-portal) | Configure named values (name-value pairs) at service level in Azure API Management |
| [Response caching](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-caching.html) | [Response caching](caching-overview.md) | Configure caching policies at the mapped scope (see preceding table). Optionally configure an external Redis-compatible cache for greater control and reliability.|
| [Usage plans and API keys](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-usage-plans.html) | [Products](api-management-howto-add-products.md?tabs=azure-portal&pivots=interactive) and [Subscriptions](api-management-subscriptions.md) | Document Amazon API Gateway configurations and recreate in Azure API Management |
| [Throttling and quotas](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-request-throttling.html) | [Rate limiting and quota policies](api-management-policies.md#rate-limiting-and-quotas) | Configure rate limiting and quota policies at the mapped scope (see preceding table) |
| [CORS](https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-cors-console.html) | [CORS policy](cors-policy.md) | Configure CORS policy with allowed headers and origins at the mapped scope (see preceding table) |
| [Resource policies](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-resource-policies.html)<br><br>[VPC endpoint policies](https://docs.aws.amazon.com/apigateway/latest/developerguide/rest-api-mutual-tls.html)<br><br>[Cognito user pools](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-integrate-with-cognito.html)<br><br>[mTLS authentication](https://docs.aws.amazon.com/apigateway/latest/developerguide/rest-api-mutual-tls.html) | [Authentication and authorization policies](api-management-policies.md#authentication-and-authorization)<br/><br/>[Credential manager](credentials-overview.md) | Manual mapping. Consider using AI assistance with tools such as [Microsoft Copilot in Azure](/azure/copilot/author-api-management-policies). |
| [Mapping templates](https://docs.aws.amazon.com/apigateway/latest/developerguide/models-mappings.html) | [Transformation policies](api-management-policies.md#transformation) | Manual mapping. Consider using AI assistance with tools such as [Microsoft Copilot in Azure](/azure/copilot/author-api-management-policies). |
| [API stages](https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-deploy-api.html) | [API versions](api-management-versions.md) | Create API versions in Azure API Management. |

#### Capability mismatches and strategies

- **Quota and throttling limits** are imposed by Amazon API Gateway per AWS account. In Azure API Management, the highest scope is the "all APIs" scope per instance.

- **API authentication and authorization methods** in Amazon API Gateway such as [IAM permissions](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html) and [Lambda authorizers](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html) don't map directly to Azure API Management. Customers can evaluate alternative authentication and authorization methods such as using Microsoft Entra ID or an external identity provider.

- **Cache-related metrics** in Amazon API Gateway don't map directly to Azure API Management metrics. Cache hits and misses can be counted in trace logs in Azure API Management.

### Assessment – Useful resources for migration

- [Azure API Management landing zone](/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator)

- [Architecture best practices for Azure API Management](/azure/well-architected/service-guides/azure-api-management)

- [API authentication and authorization in Azure API Management](authentication-authorization-overview.md)

- [Azure for AWS professionals](/azure/architecture/aws-professional/)

- [Microsoft Copilot in Azure](/azure/copilot/author-api-management-policies) for API Management policy generation

- [AWS documentation MCP server](https://awslabs.github.io/mcp/servers/aws-documentation-mcp-server) and [Microsoft Learn MCP server](/training/support/mcp)

Also, for API workloads:  
  
- [Migrate AWS Lambda Workloads to Azure Functions](/azure/azure-functions/migration/migrate-aws-lambda-to-azure-functions)

- [Migrate from Amazon Elastic Kubernetes Service to Azure Kubernetes Service](/azure/architecture/aws-professional/eks-to-aks/migrate)

## Step 2: Preparation

In the preparation phase, plan your Azure infrastructure, select appropriate API Management tiers for test and production, and thoroughly document your source APIs and integrated services. Export relevant AWS configurations and design a phased migration strategy to ensure a smooth transition.

### Plan for infrastructure setup
    
Plan for ingress and egress, firewalls, network isolation, and integration with network traffic entry points like Application Gateway, Azure Front Door, or Traffic Manager. Understand the implications of private versus public exposure of the target Azure API Management system, especially around DNS and traceability.

Review the guidance in the [Azure API Management landing zone](/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator) and evaluate scenarios that might be suitable for your migration and API backends. Consider when the workloads are isolated enough to benefit from them.

A basic scenario that you can use for initial migration and build-out in Azure is [Secure baseline with a sample workload](/azure/architecture/example-scenario/integration/app-gateway-internal-api-management-function).
  
### Plan for test and production API Management instances

Choose appropriate Azure API Management service tiers for test and production environments. 

- For customers requiring network isolation of both inbound and outbound traffic and traffic entry through Azure Front Door or Application Gateway, the Azure API Management Premium tier is currently recommended. If the Premium tier is selected, the Developer tier (not supported with SLA) can be used for proof of concept migrations since it supports networking capabilities also available in the Premium tier. The Developer tier shouldn't be used for production.

- Depending on your requirements for availability, performance, and network isolation, the Standard v2 tier can be considered because it supports integration to network-isolated backends. 

- Currently, the Premium v2 tier with capabilities to isolate both inbound traffic is in preview. You can consider using it for migrations depending on your implementation timelines in relation to the available information about Premium v2's release and migration paths.

### Understand and document the source APIs under management

Capture API configurations including authentication and authorization flows, transformation, and caching mechanisms.

Identify all services integrated with Amazon API Gateway (such as Lambdas, Application Load Balancers, Network Load Balancers, Kubernetes workloads).

For cataloging APIs under management, consider using [Azure API Center](/azure/api-center/overview) and [synchronizing](../api-center/synchronize-aws-gateway-apis.md) APIs from Amazon API Gateway.

Use discovery tools such as [AWS Resource Explorer](https://docs.aws.amazon.com/resource-explorer/latest/userguide/welcome.html) where possible, but expect to rely heavily on manually collected information and internal documentation and checklists.

Document data flows, network topology, and architectural diagrams, even if approximate.

### Export AWS configurations where possible

Export configurations such as:

- OpenAPI specifications from backend APIs, for example using the AWS console or AWS CLI. If the APIs were defined via OpenAPI originally, you might already have those specs.

- SSL/TLS certificates stored in [AWS Certificate Manager](https://docs.aws.amazon.com/acm/latest/userguide/export-public-certificate.html).

- WAF rules, by exporting to CloudFormation.
  
Capture artifacts including [CloudFormation templates](https://docs.aws.amazon.com/cloudformation/) which might be exported to Terraform using external tools, facilitating mapping to Azure [Bicep/ARM template/Terraform templates](/azure/templates/microsoft.apimanagement/allversions).

### Plan phasing strategy 
    
Planning for **phased migration** (API by API or domain by domain) is recommended: update one set of domains or API endpoints to Azure API Management while others remain on AWS, then gradually move the rest. This might require your client applications to handle mixed endpoints or using a routing layer.


## Step 3: Evaluation

The migration is considered successful when the migrated system meets validation criteria and when all production traffic is served by Azure API Management with no significant regression in functionality or performance.

Validation criteria include:

- **Validate infrastructure**: Network infrastructure is documented and accessible only as intended (for example, if it's injected in an internal virtual network, confirm that no public IPs are exposing it).
        
  The Azure API Management instance is able to reach any required networks or dependencies for operations.

- **Validate API functionality for all endpoints**: All API endpoints perform as expected with real-world scenarios, including valid and invalid requests and payloads. Ensure that any request or response transformations in configured policies take place.

  - Confirm all required authentication and authorization configurations (subscription keys, OAuth tokens, certificates) for each API.

  - Clients are able to use APIs as before with no changes (except possibly the endpoint URL, if the domain name was changed)

  - Rate limits and quotas are configured at the appropriate scope.

- **Validate operational metrics**: Monitor performance using dashboards or other observability tools under production load. Review metrics such as average latency and throughput and compare to historical data from Amazon API Gateway. Review capacity metrics to ensure that Azure API Management instance is properly scaled.

## Step 4: Process

Migration is expected to be a multiweek to multimonth process, depending on the complexity of the service infrastructure and the number and complexity of the APIs to migrate.

### Foundational setup

If not already in place, build the Azure tenant and core infrastructure (core networking, ingress, security) before migrating Amazon API Gateway and APIs. You can set up the environment using an Azure landing zone architecture suitable for your migration.

If suitable for your migration, implement an Azure API Management infrastructure-as-code [landing zone accelerator](/azure/architecture/example-scenario/integration/app-gateway-internal-api-management-function?toc=%2Fazure%2Fapi-management%2Ftoc.json&bc=%2Fazure%2Fapi-management%2Fbreadcrumb%2Ftoc.json) for your base Azure API Management deployment, including Application Gateway and internal virtual networking in Azure API Management. Although the landing zone accelerator uses the Premium tier of Azure API Management, we recommend adapting the templates to use the Developer tier for proof of concept migration.

Create and assign Azure RBAC roles so that only authorized administrators can manage the Azure API Management instance and the APIs.
    
### Configure Azure API Management platform settings

In the new Azure API Management instance, set up global configurations similar to those in Amazon API Gateway:

- **Custom hostname**: Add your custom domain to Azure API Management, upload the SSL certificate (or use Key Vault references), and perform validation. This can be done now or just before production cutover. When using Application Gateway (recommended), configure a listener with the custom domain and certificate, and point it to Azure API Management's internal endpoint. Configuring the listener simplifies configuration because it doesn't require domain validation.

- **Networking and security**: Make sure Application Gateway (or other Azure entry point) is configured to forward requests to Azure API Management. Set up NSG rules or firewall rules so that Azure API Management can reach backend services such as your Azure backends or even the source AWS backends if initially pointing to them.

- Enable **managed identity** on Azure API Management to call Azure services securely (like Key Vault for certificates or function apps).

By the end of this phase, you should have a working shell of Azure API Management in Azure with connectivity and the basic framework ready to start importing APIs.

### Import and recreate APIs in Azure API Management

With the infrastructure ready, begin migrating the API definitions and configurations:

- **Start with a simple, low-risk API:** Use a representative API to validate basic gateway functionality in Azure API Management before recreating APIs from Amazon API Gateway.
  
- **Import into Azure API Management:** Use Azure portal or scripts to import OpenAPI definitions from Amazon API Gateway or backends as new APIs in Azure API Management. During import, Azure API Management automatically creates the structure of APIs and operations. If you have multiple API stages in Amazon API Gateway, create multiple API versions in Azure API Management.

  Initially, set the backend URL for each API to point to the current backend (which for now could still be an AWS endpoint or public endpoint). For example, if the Amazon API Gateway forwarded to a Lambda, you might set the Azure API Management backend to the equivalent API in Amazon API Gateway (you'll change this later if you migrate the Lambda to Azure) or to an equivalent Azure function app if already migrated. If the backend was an AWS ALB or endpoint, Azure API Management can call it over internet.

  If you have a large number of APIs, you can use Azure API Center to catalog the APIs that are migrated to Azure API Management over time and the ones that remain in Amazon API Gateway.

  Consider migrating or refactoring backend services (for example, as Azure function apps or AKS workloads) after validating infrastructure. See guidance in the [Azure Migration Hub](/azure/migration).
    

### Set up authentication and authorization

- **Subscriptions and products**: If your APIs required API keys in Amazon API Gateway (via `x-api-key` header), decide how to handle that in Azure API Management. One approach is to make those APIs only accessible to users with a subscription to a product. Create initial products in Azure API Management, either corresponding one-to-one with AWS usage plans or reorganized logically.

- **Create user groups** in Azure API Management to mirror how you share APIs with developers.

- **Named values**: Import any configuration values (like API keys for backend services, endpoints, and so on) that were in Amazon API Gateway stage variables into Azure API Management named values. For sensitive values, use Azure Key Vault integration.

- **Token retrieval and validation** - For JWT validation of API requests, configure validation policies in Azure API Management that authorize API access. You can initially use your existing identity provider (such as AWS Cognito) and consider migration over time to Microsoft Entra ID.

  Configure credential manager in Azure API Management for managing tokens to OAuth backends, or set up token retrieval logic using policies (see [Policy snippets repo](https://github.com/Azure/api-management-policy-snippets)). 

- **Configure backends in Azure API Management** to register each backend service (with its URL, credentials, etc.). This provides a central place to update if the backend URL changes. For example, if you initially point to an AWS endpoint but later switch to an Azure backend, you can simply update the Azure API Management backend configuration.

- **Feature parity checks:** Go through the list of features used by each API and ensure they're addressed.

  For example, test APIs that deal with binary payloads (images, files) or large payloads. Ensure the Azure API Management is configured with adequate timeout, size, or content validation settings for those scenarios.
  
  Azure API Management treats all imported APIs fairly uniformly, so that Amazon API Gateway "HTTP APIs" (the newer lightweight type) versus "REST APIs" (the classic) are managed consistently in Azure API Management. Differences like the lack of usage plans in HTTP APIs are moot once in Azure API Management, but ensure any Amazon API Gateway-specific constraints are addressed.

### Transformation and policy mapping

Replicate existing API configurations as Azure API Management policies where applicable, especially for authorization and backward compatibility.

Map CORS configuration in Amazon API Gateway to CORS policy in Azure API Management.

Handle transformations (such as schema mapping, enrichment) case-by-case.

AI tools such as Microsoft Copilot in Azure in the Azure portal, and MCP servers for AWS and Microsoft documentation, can assist with configuration mapping or other transformation. However, expect to perform manual policy configuration and debugging in Azure API Management.

### Set up observability

For initial monitoring, configure Azure Monitor to collect API metrics and logs. More monitoring or observability solutions such as Application Insights can be layered in later.

### Perform testing

With the APIs configured in Azure API Management, thorough testing is critical. This phase is expected to be iterative.

- **Functional testing:** For each API, call the new Azure API Management endpoint (via the Azure portal's test console or client tools) and compare responses to the Amazon API Gateway endpoint. Check for expected status codes, headers, and body. If differences are found, adjust Azure API Management policies or configuration accordingly.

> [!NOTE]
> If the API Management instance is in an internal virtual network configuration, the test console won't work. You can test APIs with other client tools deployed in the network, or using the API Management developer portal, if you enable it for your instance.

- **Security testing:** Validate that API authentication and authorization are working. For instance, present a valid JWT or subscription key to Azure API Management and ensure it accepts the request, and that invalid credentials are rejected with proper error codes. Clients that pass tokens for JWT validation might need to authorize with a different identity provider if one was configured during migration. If using subscription keys, test with and without the key.

- **Performance baseline:** Use a tool to simulate load on the Azure API Management endpoints and see that they can handle the expected throughput. Compare latency of calls via Azure API Management to latency via Amazon API Gateway. Azure API Management in the Developer tier is less performant than the Premium tier and single-instance, so heavy performance testing might wait until you have a Premium-tier Azure API Management instance deployed.

### Begin production rollout

Upgrade to Premium tier or other production-ready tier of Azure API Management in the production environment and repeat or migrate the API import and configuration settings created in preproduction environments. ApiOps processes can be used to publish APIs and manage API configurations across environments.

Rehearse cutover in a lower environment (or with a subset of traffic). For instance, select one noncritical API and have one client application switch to using the Azure endpoint. This can reveal any client-side issues or help validate your DNS change process. If your API consumers are internal, you can simulate a change by editing hosts files or using a test DNS zone to point the domain to Azure API Management temporarily.

- **DNS switch:** The most common approach is to switch the DNS entry of your custom Amazon API Gateway domain to point to the new Azure endpoint. For example, if your domain api.example.com was mapped to Amazon API Gateway, you would update its CNAME or A record to point to the Azure API Management hostname or to the front-end (like Application Gateway) domain.  

- **TTL considerations**: Lower the DNS TTL beforehand so that clients pick up changes quickly. When ready, change the DNS. It can take minutes to hours to propagate, during which time some traffic might still go to AWS and some to Azure. If an immediate cut is needed, you can use an alternate method such as a reverse-proxy approach.

- **Alternative cutover methods**: Sometimes, instead of DNS, organizations use a reverse proxy/gateway flip – for example, keep the public DNS the same but initially have Application Gateway forward requests to Amazon API Gateway (via its URL), and when flipping, point it to Azure API Management internally. This approach, while more complex, can achieve an instantaneous switch. Another method if using Azure Front Door or Traffic Manager is to reweight traffic from one backend (AWS) to another (Azure) gradually.

- **Monitoring during cutover**: As soon as the switch happens, closely monitor requests to both the Azure API Management instance and the Amazon API Gateway. Monitor Azure API Management metrics (requests, latency, CPU, capacity memory) in real-time via Azure portal or whatever dashboard you set up. Also use Azure Monitor to watch for spikes in errors such as 4XX/5XX responses.

- **Rollback plan**: Decide on what triggers a rollback. For example, if error rate exceeds X% or a critical functionality is broken, you might revert within 30 minutes. A rollback means undoing whatever switch you did; for example, if DNS, revert the DNS record to point back to Amazon API Gateway. Because of DNS propagation, rollback might take some time (hence the importance of low TTL and possibly keeping both systems running). If you used a reverse proxy, flip it back to AWS.

### Decommission Amazon API Gateway

Decommission Amazon API Gateway after a period when it receives zero traffic and the Azure API Management instance meets the validation criteria. Typically, you'll run both in parallel (with Azure taking all traffic) through at least one full business cycle or peak traffic period to ensure the new system handles it.

## Iterative optimization

After migration, focus on optimizing the API Management configuration iteratively by closing feature gaps and implementing best practices. This iterative improvement process ensures that the migrated workload meets all success criteria established during the assessment step and follows the [Architecture best practices for API Management](/azure/well-architected/service-guides/azure-api-management).

### Iterate on feature gaps

Some Amazon API Gateway features don't have a one-to-one mapping in Azure API Management and require workarounds (see capability mismatches in the [Assessment](#step-1-assessment) section). For example:

- **Web Application Firewall (WAF)**: Azure API Management doesn't automatically block bad payloads that AWS WAF would have. If you set up Azure WAF, make sure Azure API Management is only accessible through the WAF and that WAF rules replicate AWS WAF restrictions.
    
- **Event streams**: If CloudWatch alarms or events were tied to Amazon API Gateway (for example, on certain error patterns), set up equivalent alerts in Azure Monitor for Azure API Management (for example, an alert on Azure API Management 5XX rate).
    
- **Automation**: If you have CI/CD pipelines, integrate Azure API Management into them. For example, you might store your Azure API Management configurations (APIs and policies) in source control using infrastructure as code approaches like ARM/Bicep/Terraform templates or an [APIOps methodology](/azure/architecture/example-scenario/devops/automated-api-deployments-apiops). This ensures that future changes to the APIs can be deployed consistently and version-controlled.

### Implement best practices

Iteratively implement best practices including cost optimization, security hardening, and operational improvements. Review and implement architecture best practices for Azure API Management along the pillars of reliability, security, operational excellence, cost management, and performance. Address Azure Advisor recommendations for your Azure API Management instance.

Over time, layer in more capabilities such as external caching, monitoring capabilities beyond Azure Monitor such as Application Insights or non-Microsoft solutions such as Datadog, or policies in Azure API Management that aren't available in Amazon API Gateway.

## Key takeaways

Migrating Amazon API Gateway to Azure requires careful planning and systematic execution to obtain equivalent functionality or alternative approaches. The key success factors include:

- **Thorough assessment**: Conduct a detailed assessment of the existing Amazon API Gateway setup, including all APIs, service integrations, and dependencies. Identify gaps or differences in capabilities between Amazon API Gateway and Azure API Management.

- **Opportunities for modernization**: Use the migration as an opportunity to modernize or migrate backend services or improve API design.

- **Comprehensive preparation**: Prepare the Azure environment, including networking, security, and infrastructure setup. Document all configurations and plan for any necessary changes to backend services.

- **Incremental migration**: Plan for an incremental migration approach, starting with less critical APIs or services. This allows for testing and validation of the new setup before fully committing to the switch.

- **Validation and testing**: Implement comprehensive testing and validation processes to ensure that the Azure API Management instance meets all functional and performance requirements. This includes load testing, security testing, and user acceptance testing.

- **Monitoring and observability**: Set up robust monitoring and observability for the new Azure API Management instance to quickly identify and address any issues that arise during or after migration.

- **Iterative optimization**: Post-migration, continuously optimize the Azure API Management setup by addressing feature gaps and implementing best practices.
