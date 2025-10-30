---
title: What is Certificate Management (Preview?
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

# What is Certificate Management (Preview)?

Certificate Management is a built-in feature of IoT Hub that enables you to manage device certificates using Microsoft-managed PKI with X.509 certificates. The X.509 certificates are operational certificates that devices use to authenticate with IoT Hub for secure communications after the device onboards with a different credential.

If you want to use Certificate Management, you need to set up an [Azure Device Registry (ADR) namespace](iot-hub-device-registry-setup.md) and link it to your IoT hub instance.

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
| Third-party PKI (DigiCert, GlobalSign, etc.) | Yes. Manual integration required.  | IoT Hub Gen 1 and|

This article focuses on Microsoft-managed PKI with Certificate Management. For information about using third-party PKI providers, see [Authenticate devices with X.509 CA certificates](authenticate-authorize-x509.md).

## Authenticate with IoT Hub using X.509 certificates

To onboard and connect devices to IoT Hub, Certificate Management requires using X.509 certificate-based authentication. Other Azure IoT services like IoT Central authenticate devices using X.509 certificates or SAS (shared access signature) keys. Certificate Management prioritizes X.509 certificates because of their enhanced security.

Certificate-based authentication offers these benefits over less secure methods like symmetric keys or SAS tokens:

- Prevents unauthorized devices from joining the IoT network.
- Lets admins revoke access to compromised devices.
- Reduces the risk of exposing device credentials in transit or at rest.
- Lets admins use different certificates for devices, groups, or scenarios.

## How Certificate Management works

Certificate Management uses [Azure Device Registry (ADR)](iot-hub-device-registry-overview.md) to manage device certificates. ADR is a service that provides secure device identity and authentication for IoT solutions. It integrates with IoT Hub and Device Provisioning Service (DPS) to provide a seamless experience for managing device identities and certificates.

When you set up your [ADR namespace](iot-hub-device-registry-namespaces.md#create-a-new-namespace), you can create a credential resource that configures a Microsoft-managed PKI and root CA on behalf of that ADR namespace. Within the namespace, you also configure one or more policies. Each policy coincides with an intermediate certificate authority (ICA) that is signed by the root CA of that namespace. Each ICA can only issue leaf certificates for devices registered within that ADR namespace and with Hubs linked to the namespace. In this policy, you can also define the lifespan for your operational leaf certificates, also known as your device certificates.

For more information about how to create namespaces, policies, and credentials, see [Create and manage namespaces](iot-hub-device-registry-namespaces.md).

The ADR namespace and its credential resource are then linked to your IoT Hub instance and DPS. This linkage enables IoT Hub to trust the device certificates issued by the ICAs configured in the ADR namespace.

The following image illustrates the X.509 certificate hierarchy used to authenticate IoT devices in Azure IoT Hub through the Azure Device Registry (ADR). 

- Each ADR namespace (cloud) has a unique root CA credential managed by Microsoft. This credential acts as the primary certificate authority. 
- Each policy within the ADR namespace defines an intermediate CA (ICA) signed by the root CA. Each ICA can issue leaf certificates for devices registered within that ADR namespace and with Hubs linked to the namespace. This structure enables scalable identity management and policy enforcement across device groups.
- Each device (field) is authenticated using an X.509 leaf certificate issued and signed by one of the ICAs defined in the ADR namespace. The leaf certificate is used for secure communication with IoT Hub.

:::image type="content" source="media/certificate-management/device-registry-certificate-management.png" alt-text="Diagram showing how Azure Device Registry integrates with IoT Hub and DPS for certificate management." lightbox="media/certificate-management/device-registry-certificate-management.png":::

### Device provisioning with Certificate Management

Similarly to IoT Hub Gen 1, in order to use certificate management, devices must be provisioned via [Device Provisioning Service (DPS)](../iot-dps/index.yml) with Certificate Management. When a device connects to DPS for provisioning, it authenticates using its onboarding credentials. Once authenticated, the device is provisioned to the appropriate IoT Hub and registered to the appropriate ADR namespace. As part of this provisioning call, the device also submits a Certificate Signing Request (CSR) to DPS, which it uses to request an X.509 operational certificate that IoT Hub recognizes. The CSR includes information about the device, such as its public key and other identifying information.

With Certificate Management, you control your resources in ADR, IoT Hub Gen 2, and DPS, while Microsoft manages the PKI infrastructure, including the root CA and ICAs.

The following diagram illustrates the end-to-end process of device provisioning with Certificate Management:

1. The IoT device connects to DPS using an onboarding credential and sends a certificate signing request (CSR). The CSR contains information about the device, such as its public key and other identifying details.
1. DPS authenticates the device using its onboarding credentials and assigns it to an IoT Hub based on its enrollment group. The device is also registered in the ADR namespace for certificate lifecycle management.
1. The device identity is created in IoT Hub and linked to the appropriate ADR namespace.
1. DPS requests an X.509 operational certificate from Microsoft PKI using the CSR and the policy defined by the enrollment group.
1. Microsoft PKI returns the signed operational certificate to DPS.
1. DPS sends the operational certificate and IoT Hub connection details back to the device.
1. The device now authenticates with IoT Hub using the newly issued X.509 client certificate.

:::image type="content" source="media/certificate-management/operational-diagram.png" alt-text="Diagram showing how Azure Device Registry integrates with IoT Hub and DPS for certificate management during provisioning." lightbox="media/certificate-management/operational-diagram.png":::

## Renewal of certificates

Due to the wide variety of IoT devices, each device is responsible for monitoring the expiration date of its operational certificate and determining when renewal is required. The certificate includes its **expiration date**, which the device can track to identify when rotation is needed. 

When renewal is necessary, the device initiates another provisioning call to DPS, submitting a new Certificate Signing Request (CSR) signed by its private key. The CSR is sent to the appropriate intermediate certificate authority (ICA) to request a new leaf certificate. Once approved, the new operational certificate is returned to the device for continued secure authentication with IoT Hub.

## Disable a device

Certificate Management doesn't support certificate revocation during public preview. To remove the connection of a device that uses an X.509 operational certificate, you can disable the device in the IoT hub registry. To disable a device, see [Disable or delete a device](create-connect-device.md#disable-or-delete-a-device).

## Limits and quotas

The following table lists the default limits and quotas for Certificate Management:

|Feature|Limit|
|----------------------------------|-------------------------------|
|Number of certificates issued by PKI (by a device DPS instance) during provisioning|1000 per minute|
|Number of certificate renewals|500 per minute|
|Number of credential resources per tenant|2|
|Number of credential resources per ADR namespace|1|
|Number of policies per credential resource|2|
