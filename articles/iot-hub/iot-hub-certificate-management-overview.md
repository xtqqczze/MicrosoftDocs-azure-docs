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

**Applies to:** ![IoT Hub checkmark](media/iot-hub-version/yes-icon.png) IoT Hub Gen 2

Certificate Management is a built-in feature of IoT Hub Gen 2 that enables you to manage device certificates using Microsoft-managed PKI with X.509 certificates. X.509 certificates are the gold standard for IoT security. They are strictly operational certificates that devices use to authenticate with IoT Hub for secure communications after the device onboards with a different credential.

> [!IMPORTANT]
> To use Certificate Management, you need to set up an [Azure Device Registry (ADR) namespace](iot-hub-device-registry-setup.md) and link it to your IoT Hub Gen 2 instance. 

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## Authentication and authorization

*Authentication* is the process of proving that you're who you say you are. Authentication verifies the identity of a user or device to IoT Hub. It's sometimes shortened to *AuthN*. 

*Authorization* is the process of confirming permissions for an authenticated user or device on IoT Hub. It specifies what resources and commands you're allowed to access, and what you can do with those resources and commands. Authorization is sometimes shortened to *AuthZ*.

X.509 certificates are only used for authentication in IoT Hub, not authorization. Unlike with [Microsoft Entra ID](authenticate-authorize-azure-ad.md) and [shared access signatures](authenticate-authorize-sas.md), you can't customize permissions with X.509 certificates.

## Microsoft vs third-party PKI

Public key infrastructure (PKI) uses digital certificates to authenticate and encrypt data between devices and services. PKI certificates secure scenarios like VPN, Wi-Fi, email, web, and device identity. Managing PKI certificates is challenging, costly, and complex, especially for organizations with many devices and users.

IoT Hub supports two types of PKI providers for X.509 certificate authentication:

| PKI provider | Integration required | IoT Hub generation | 
|--------------|----------------------|-------------------|
| Microsoft-managed PKI | No. Configure certificate authorities directly in Azure Device Registry (ADR).| IoT Hub Gen 2  |
| Third-party PKI (DigiCert, GlobalSign, etc.) | Yes. Manual integration required.  | IoT Hub Gen 1 |

This article focuses on Microsoft-managed PKI with Certificate Management. For information about using third-party PKI providers, see [Authenticate devices with X.509 CA certificates](authenticate-authorize-x509.md).

## Authenticate with IoT Hub using X.509 certificates

To onboard and connect devices to IoT Hub, Certificate Management requires using X.509 certificate-based authentication. Other Azure IoT services like IoT Central authenticate devices using X.509 certificates or SAS (shared access signature) keys. Certificate Management prioritizes X.509 certificates because of their enhanced security.

Certificate-based authentication offers these benefits over less secure methods like symmetric keys or SAS tokens:

- Prevents unauthorized devices from joining the IoT network.
- Lets admins revoke access to compromised devices.
- Reduces the risk of exposing device credentials in transit or at rest.
- Lets admins use different certificates for devices, groups, or scenarios.

## How Certificate Management works

Certificate Management uses [Azure Device Registry (ADR)](iot-hub-device-registry-overview.md) to manage device certificates. ADR is a service that provides secure device identity and authentication for IoT solutions. It integrates with IoT Hub Gen 2 and Device Provisioning Service (DPS) to provide a seamless experience for managing device identities and certificates.

When you set up your [ADR namespace](iot-hub-device-registry-setup.md#set-up-an-adr-namespace), you create a credential resource that configures a Microsoft-managed PKI and root CA on behalf of that ADR namespace. 

The following image illustrates the X.509 certificate hierarchy used to authenticate IoT devices in Azure IoT Hub through the Azure Device Registry (ADR). 

- Each ADR namespace (cloud) has a unique root CA credential managed by Microsoft. This credential acts as the primary certificate authority. 
- Each policy within the ADR namespace defines an intermediate CA (ICA) signed by the root CA. Each ICA can issue leaf certificates for devices registered within that ADR namespace and with Hubs linked to the namespace. This structure enables scalable identity management and policy enforcement across device groups.
- Each device (field) is authenticated using an X.509 leaf certificate issued and signed by one of the ICAs defined in the ADR namespace. The leaf certificate is used for secure communication with IoT Hub.

:::image type="content" source="media/certificate-management/device-registry-certificate-management.png" alt-text="Diagram showing how Azure Device Registry integrates with IoT Hub and DPS for certificate management." lightbox="media/certificate-management/device-registry-certificate-management.png":::

For more information, see [Use certificate-based authentication with Certificate Management](iot-hub-certificate-management-authentication.md).

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
