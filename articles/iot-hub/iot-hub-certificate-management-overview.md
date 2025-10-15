---
title: What is Certificate Management?
titleSuffix: Azure IoT Hub
description: This article discusses the basic concepts of how Certificate Management in Azure IoT Hub helps users manage device certificates.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: overview
ms.date: 10/20/2025
#Customer intent: As a developer new to IoT, I want to understand what Certificate Management is and how it can help me manage my IoT device certificates.
---

# What is Certificate Management?

Certificate Management is a built-in feature of IoT Hub Gen 2 that enables you to manage device certificates using Microsoft-managed PKI with X.509 certificates. X.509 certificates are the gold standard for IoT security. They are strictly operational certificates that devices use to authenticate with IoT Hub for secure communications after the device onboards with a different credential.

> [!IMPORTANT]
> To use Certificate Management, you need to set up an [Azure Device Registry (ADR) namespace](iot-hub-device-registry-setup.md) and link it to your IoT Hub Gen 2 instance. 

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## What is PKI

PKI uses digital certificates to authenticate and encrypt data between devices and services. PKI certificates secure scenarios like VPN, Wi-Fi, email, web, and device identity. Managing PKI certificates is challenging, costly, and complex, especially for organizations with many devices and users. Use Microsoft Cloud PKI to enhance security and productivity for your devices and users, and accelerate your digital transformation to a fully managed cloud PKI service. Use the Cloud PKI service to reduce workloads for Active Directory Certificate Services (ADCS) or private on-premises certification authorities.

For more information, see [Microsoft PKI](/intune/intune-service/protect/microsoft-cloud-pki-overview).


## Authenticate with IoT Hub using X.509 certificates

To onboard and connect devices to IoT Hub, Certificate Management requires using X.509 certificate-based authentication. Other Azure IoT services like IoT Central authenticate devices using X.509 certificates or SAS (shared access signature) keys. Certificate Management prioritizes X.509 certificates because of their enhanced security.

Certificate-based authentication offers these benefits over less secure methods like symmetric keys or SAS tokens:

- Prevents unauthorized devices from joining the IoT network.
- Lets admins revoke access to compromised devices.
- Reduces the risk of exposing device credentials in transit or at rest.
- Lets admins use different certificates for devices, groups, or scenarios.

For more information, see [Use Certificate-based authentication with Certificate Management](iot-hub-certificate-management-authentication.md).

## How Certificate Management works

When you set up your ADR namespace, you create a credential resource. Creating a credential configures a Microsoft-managed PKI and root CA on behalf of that ADR namespace. Within the namespace, you also configure one or more policies. Each policy coincides with an intermediate certificate authority (ICA) that is signed by the root CA of that namespace. Each ICA can only issue leaf certificates for devices registered within that ADR namespace and with Hubs linked to the namespace. In this policy, you can also define the lifespan for your operational leaf certificates, also known as your device certificates.

1. You create an ADR namespace and configure it with a credential resource and one or more policies.
1. Configure IoT Hub Gen 2 and DPS, and link them to each other and to the ADR namespace.
1. Preconfigure devices with onboarding credentials and share them with DPS.

You manage the resources in ADR, IoT Hub Gen 2, and DPS, while Microsoft manages the PKI infrastructure, including the root CA and ICAs.

When a device connects to DPS for provisioning, it authenticates using its onboarding credentials. Once authenticated, the device is provisioned to the appropriate IoT Hub and registered to the appropriate ADR namespace. As part of this provisioning call, the device also submits a Certificate Signing Request (CSR) to DPS, which it uses to request an X.509 operational certificate that IoT Hub recognizes. The CSR includes information about the device, such as its public key and other identifying information.

:::image type="content" source="media/certificate-management/device-registry-certificate-management.png" alt-text="Diagram showing how Azure Device Registry integrates with IoT Hub and DPS for certificate management." lightbox="media/certificate-management/device-registry-certificate-management.png":::


## Device provisioning with Certificate Management

To use Certificate Management, provision your devices with leaf certificates via [Device Provisioning Service (DPS)](../iot-dps/index.yml). The device needs to onboard and authenticate using one of the supported methods: X.509 certificate (procured from a third-party CA) or symmetric keys. After the device authenticates successfully, it is provisioned to the appropriate IoT Hub and registered to the appropriate ADR namespace. As part of this provisioning call, the device also submits a Certificate Signing Request (CSR) to DPS, which it uses to request an X.509 operational certificate that IoT Hub recognizes.

:::image type="content" source="media/certificate-management/operational-diagram.png" alt-text="Diagram showing how Azure Device Registry integrates with IoT Hub and DPS for certificate management during provisioning." lightbox="media/certificate-management/operational-diagram.png":::

## Supported regions

Certificate Management is supported in these regions:

- East US
- East US 2
- West US
- West US 2
- West Europe
- North Europe

## Limits and quotas

The following table lists the default limits and quotas for Certificate Management:

|Feature|Limit|
|----------------------------------|-------------------------------|
|Number of certificates issued by PKI (by a device DPS instance) during provisioning|500 per minute|
|Number of certificate renewals|500 per minute|
|Number of credential resources per tenant|3|
|Number of credential resources per ADR namespace|1|
|Number of policies per credential resource|3|
