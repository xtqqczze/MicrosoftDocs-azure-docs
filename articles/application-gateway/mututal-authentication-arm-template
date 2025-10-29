                              # mTLS Passthrough Listener Deployment on Azure Application Gateway

## Overview

This repository provides step-by-step guidance and ARM templates for deploying an Azure Application Gateway with **mutual TLS (mTLS) passthrough listener** using the latest Azure API (version `2025-03-01`). In mTLS passthrough mode, the Application Gateway requests a client certificate but does **not** enforce verification at the gateway. The backend is responsible for certificate validation and policy enforcement.

## Note

This deployment is intended **for testing purposes only**.  
**Do not use with production workloads.**

## Key Features

- **No client CA certificate required** for mTLS passthrough listener.
- New property: `verifyClientCertMode` (supports `Strict` and `Passthrough`).
- Automated deployment using Azure CLI and ARM templates.
- Backend receives client certificate for custom validation.

## Prerequisites

- Azure subscription and resource group
- Admin access to Azure CLI
- Application Gateway with valid backend and SSL certificate for the https listener
- API version: `2025-03-01`
- Post creation updates need to be performed via ARM template using API version `2025-03-01`

## Deployment Steps

1. **Review and Customize Parameters**
   - Edit `mtls.parameters.json`:
     - `addressPrefix` and `subnetPrefix`: Define network ranges.
     - `skuName` and `capacity`: Set gateway size and instance count.
     - `certData` and `certPassword`: Paste SSL certificate and password.

2. **Deploy Using Azure CLI**
   ```sh
   az deployment group create --resource-group <your-resource-group> --template-file mtlsdeploy_novmss.json --parameters mtls.parameters.json
   ```

3. **Validate Deployment**
   - In Azure Portal, check the Application Gateway resource.
   - Confirm that the **mTLS passthrough listener** is enabled.

4. **Send Client Certificate to backend**
     - If you need to forward the client certificate to the backend, configure a rewrite rule as described in [https://docs.azure.cn/en-us/application-       gateway/rewrite-http-headers-url#mutual-authentication-server-variables.](https://docs.azure.cn/en-us/application-gateway/rewrite-http-headers-url#server-variables)
       <img width="1024" height="609" alt="image" src="https://github.com/user-attachments/assets/8f65c05f-4e2a-4c10-bd6a-5842797fb0ab" />

     - If the client has sent a certificate, this rewrite ensures the client certificate is included in the request headers for backend processing.
       
5.  **Test Connectivity**
   - Connections should be established even if a client certificate is not provided.

## mTLS Passthrough Parameters

| Name                    | Type   | Description                                                                 |
|-------------------------|--------|-----------------------------------------------------------------------------|
| verifyClientCertIssuerDN| boolean| Verify client certificate issuer name on the gateway                        |
| verifyClientRevocation  | options| Verify client certificate revocation                                        |
| VerifyClientAuthMode    | options| Set client certificate mode (`Strict` or `Passthrough`)                     |

**Passthrough Mode:** Gateway requests a client certificate but does not enforce it. Backend validates certificate and enforces policy.

## Security Notice

This solution is classified as **Microsoft Confidential**. Please ensure you follow your organization’s security and data handling best practices when deploying and managing this solution.

