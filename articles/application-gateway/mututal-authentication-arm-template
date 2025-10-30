---
title: 'Configure mutual authentication with Application Gateway through ARM'
description: Learn how to configure an Application Gateway to have mutual authentication through an ARM template.
services: application-gateway
author: darshilshah
ms.date: 10/29/2025
ms.topic: how-to
ms.service: azure-application-gateway
---

# Configure mutual authentication with Application Gateway through ARM

This article describes how to use an ARM template to configure mutual authentication on your Application Gateway. Mutual authentication means Application Gateway authenticates the client sending the request using the client certificate you upload onto the Application Gateway. 

If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin.

## Before you begin

To configure mutual authentication with an Application Gateway, you need a client certificate to upload to the gateway. The client certificate will be used to validate the certificate the client will present to Application Gateway. For testing purposes, you can use a self-signed certificate. However, this is not advised for production workloads, because they're harder to manage and aren't completely secure. 

To learn more, especially about what kind of client certificates you can upload, see [Overview of mutual authentication with Application Gateway](./mutual-authentication-overview.md#certificates-supported-for-mutual-authentication).

## Create a new Application Gateway

First create a new Application Gateway as you would usually through an ARM template - there are no additional steps needed in the creation to enable mutual authentication. For more information on how to create an Application Gateway using an ARM template, check out our [arm template quickstart tutorial](./quick-create-template.md).

## Review and Customize Parameters ##

Next, edit the following parameters to configure mutual authentication:
   - Edit `mtls.parameters.json`:
     - `addressPrefix` and `subnetPrefix`: Define network ranges.
     - `skuName` and `capacity`: Set gateway size and instance count.
     - `certData` and `certPassword`: Paste SSL certificate and password.

## Deploy Using Azure CLI ##

Use the Azure CLI to deploy the ARM template with mutual authentication settings. Run the following command in your terminal, replacing `<your-resource-group>` with your desired resource group name:
   ```sh
   az deployment group create --resource-group <your-resource-group> --template-file mtlsdeploy_novmss.json --parameters mtls.parameters.json
   ```

## Validate Deployment ##

To validate that mutual authentication is configured correctly:
   - In Azure Portal, check the Application Gateway resource.
   - Confirm that the **mTLS passthrough listener** is enabled.

## Send Client Certificate to backend ##
     - If you need to forward the client certificate to the backend, configure a rewrite rule as described in [https://docs.azure.cn/en-us/application-       gateway/rewrite-http-headers-url#mutual-authentication-server-variables.](https://docs.azure.cn/en-us/application-gateway/rewrite-http-headers-url#server-variables)
       <img width="1024" height="609" alt="image" src="https://github.com/user-attachments/assets/8f65c05f-4e2a-4c10-bd6a-5842797fb0ab" />

     - If the client has sent a certificate, this rewrite ensures the client certificate is included in the request headers for backend processing.
       
## Test Connectivity ##

To test the mutual authentication setup, use a tool like cURL or Postman to send requests to the Application Gateway with and without a client certificate.
   - Connections should be established even if a client certificate is not provided.

## Clean up resources

When you no longer need the resources that you created with the application gateway, delete the resource group. This removes the application gateway and all the related resources.

To delete the resource group, call the `Remove-AzResourceGroup` cmdlet:

```azurepowershell-interactive
Remove-AzResourceGroup -Name <your resource group name>
```

## Next steps

> [!div class="nextstepaction"]
> [Manage web traffic with an application gateway using the Azure CLI](./tutorial-manage-web-traffic-cli.md)
