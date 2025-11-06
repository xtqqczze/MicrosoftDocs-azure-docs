---
title: JSON Web Token (JWT) validation in Azure Application Gateway
titleSuffix: Azure Application Gateway
description: Learn how to configure JSON Web Token (JWT) validation in Azure Application Gateway to enforce authentication and authorization policies.
author: rnautiyal
ms.author: rnautiyal
ms.service: application-gateway
ms.topic: conceptual
ms.date: 10/22/2025
---

# JSON Web Token (JWT) validation in Azure Application Gateway (Preview)

## Overview
Azure Application Gateway provides built-in JSON Web Token (JWT) validation at the gateway routing layer. This capability verifies the integrity and validity of tokens in incoming requests and makes an allow-or-deny decision before forwarding traffic to backend services. Upon successful validation, the gateway adds the `x-msft-entra-identity` header and passes it to the backend.

By performing token validation at the edge, Application Gateway helps simplify application architecture and enhance overall security posture. JWT validation in Application Gateway is stateless—each request must include a valid token for access to be granted. No session or cookie-based state is maintained, ensuring consistent token checks and compliance with Zero Trust principles.

With JWT validation, Application Gateway can:
- Verify token integrity using a trusted issuer and signing keys.
- Validate claims such as audience, issuer, and expiration.
- Block requests with invalid or missing tokens before they reach your backend.

## Why use JWT validation?

- **Zero Trust alignment:** Ensure only authenticated traffic reaches your application.
- **Simplified architecture:** Offload token validation from backend services.
- **Improved security:** Reduce attack surface and prevent unauthorized access.

## Supported scenarios

- Validate JWT tokens in the `Authorization` header.
- Provide an allow-or-deny decision based on token validity.
- Integrate with Web Application Firewall (WAF) policies for layered security.



## Configure JWT validation

### Step 1: Register an application in Microsoft Entra ID
1. Go to [Azure Portal → App registrations](https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade).
2. Select **New registration**.
3. Enter:
   - **Name:** `appgw-jwt-demo`
   - **Supported account types:** *Accounts in this organizational directory only*.
4. Select **Register**.
5. Copy:
   - **Application (client) ID** → `CLIENT_ID`
   - **Directory (tenant) ID** → `TENANT_ID`.

### Step 2: Configure JWT validation in Application Gateway
1. Open the preview configuration portal:  
   [App Gateway JWT Config Portal](https://ms.portal.azure.com/?feature.canmodifystamps=true&amp;Microsoft_Azure_HybridNetworking=flight23&amp;feature.applicationgatewayjwtvalidation=true).
2. Select **JWT validation configuration**.
3. Provide the following details:

| Field                    | Example                        | Description                                                              |
| ------------------------ | ------------------------------ | ------------------------------------------------------------------------ |
| **Name**                 | `jwt-validation-demo`          | Friendly name for the validation configuration                           |
| **Unauthorized Request** | Deny                           | Reject requests with missing or invalid JWTs                             |
| **Tenant ID**            | `<your-tenant-id>`             | Must be a valid GUID or one of `common`, `organizations`, or `consumers` |
| **Client ID**            | `<your-client-id>`             | GUID of the app registered in Entra                                      |
| **Audiences**            | (Optional) `api://<client-id>` | Expected audience claim matching scope                                   |

4. Associate the configuration with a **Routing rule** (see next section).



### Step 3: Create an HTTPS routing rule
1. Go to **Application Gateway → Rules → Add Routing rule**.
2. Configure:
   - **Listener:** Protocol `HTTPS`, assign certificate or Key Vault secret.
   - **Backend target:** Select or create a backend pool.
   - **Backend settings:** Use appropriate HTTP/HTTPS port.
   - **Rule name:** e.g., `jwt-route-rule`.
3. Link this rule to your JWT validation configuration.

Your JWT validation configuration is now attached to a secure HTTPS listener and routing rule.

### Step 4: Retrieve an access token using Azure CLI

```bash
az login --tenant "<TENANT_ID>"

CLIENT_ID="<your-client-id>"
TENANT_ID="<your-tenant-id>"

TOKEN=$(az account get-access-token \
    --scope "https://management.azure.com/.default" \
    --query accessToken -o tsv)
```

### Step 5: Test connectivity

Use `curl` to send a request to the Application Gateway with the retrieved token:

```bash

curl -H "Authorization: Bearer $TOKEN" https://appgwFrontendIpOrDns:configuredPort/pathToListenerWithRoute

```

Expected behavior:

You should receive a 401 Unauthorized response if:

No token is provided.
The token is invalid.

The backend target should receive the request with an additional header:
x-msft-entra-identity

### Next steps

To learn more about JWT validation and related identity features in Azure:

https://learn.microsoft.com/azure/active-directory/develop/jwt
https://learn.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis
https://learn.microsoft.com/azure/application-gateway/
https://learn.microsoft.com/security/zero-trust/overview