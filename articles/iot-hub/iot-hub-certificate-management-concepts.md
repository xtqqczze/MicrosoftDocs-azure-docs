---
title: Key concepts for certificate management (Preview)
titleSuffix: Azure IoT Hub
description: This article discusses the basic concepts of certificate management in Azure IoT Hub.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: overview
ms.date: 10/20/2025
#Customer intent: As a developer new to IoT, I want to understand the fundamental concepts of certificate management in Azure IoT Hub, so that I can effectively implement secure device authentication in my IoT solutions.
---

# Key concepts for certificate management (Preview)

certificate management in Azure IoT Hub is designed to simplify the management of X.509 certificates for IoT devices. This article introduces the fundamental concepts related to certificate management and certificate-based authentication in IoT Hub. For more information, see [What is certificate management (Preview)?](iot-hub-certificate-management-overview.md).

[!INCLUDE [public-preview-banner](includes/public-preview-banner.md)]

## Public Key Infrastructure (PKI)

PKI is a system that uses digital certificates to authenticate and encrypt data between devices and services. PKI certificates are essential for securing various scenarios, such as VPN, Wi-Fi, email, web, and device identity. In IoT settings, managing PKI certificates can be challenging, costly, and complex, especially for organizations that have a large number of devices and strict security requirements. You can use certificate management to enhance the security of your devices and accelerate your digital transformation to a fully managed cloud PKI service. 

## Microsoft vs third-party PKI

While IoT Hub supports two types of PKI providers for X.509 certificate authentication, certificate management currently only supports Microsoft-managed PKI. For information about using third-party PKI providers, see [Authenticate devices with X.509 CA certificates](authenticate-authorize-x509.md).

| PKI provider | Integration required | ADR required | 
|--------------|----------------------|-------------------|
| Microsoft-managed PKI | No. Configure certificate authorities directly in Azure Device Registry (ADR).| Yes |
| Third-party PKI (DigiCert, GlobalSign, etc.) | Yes. Manual integration required.  | No |

## Authentication vs authorization

*Authentication* is the process of proving that you're who you say you are. Authentication verifies the identity of a user or device to IoT Hub. It's sometimes shortened to *AuthN*. 

*Authorization* is the process of confirming permissions for an authenticated user or device on IoT Hub. It specifies what resources and commands you're allowed to access, and what you can do with those resources and commands. Authorization is sometimes shortened to *AuthZ*.

X.509 certificates are only used for authentication in IoT Hub, not authorization. Unlike with [Microsoft Entra ID](authenticate-authorize-azure-ad.md) and [shared access signatures](authenticate-authorize-sas.md), you can't customize permissions with X.509 certificates.

## X.509 Certificates

To onboard and connect devices to IoT Hub, certificate management requires using X.509 certificate-based authentication.Certificate-based authentication offers these benefits over less secure methods like symmetric keys or SAS tokens:

- Prevents unauthorized devices from joining the IoT network.
- Lets admins revoke access to compromised devices.
- Reduces the risk of exposing device credentials in transit or at rest.
- Lets admins use different certificates for devices, groups, or scenarios.

There are two general categories of X.509 certificates: 

- **CA certificates:** These certificates are issued by a Certificate Authority (CA), and you use them to sign other certificates. CA certificates include root and intermediate certificates. 
    
    - **Root certificates:** A root certificate is a top-level, self-signed certificate from a trusted CA that can be used to sign intermediate CAs. 
    
    - **Intermediate certificates:**  An intermediate certificate is a CA certificate that is signed by a trusted root certificate. You can use intermediate certificates to sign end-entity certificates, such as individual or leaf device certificates. 

    > [!NOTE]
    > It might be helpful to use different intermediate certificates for different sets or groups of devices, such as devices from different manufacturers or different models of devices. The reason to use different certificates is to reduce the total security impact if any particular certificate is compromised. 

- **End-entity certificates:** These certificates, which can be individual or leaf device certificates, are signed by CA certificates and are issued to users, servers, or devices.

## Onboarding vs operational certificates

Today, certificate management only supports issuance and renewal for end-entity operational certificates. 

- **Onboarding Credential:** To use certificate management, devices must be provisioned via Device Provisioning Service. The device must onboard and authenticate using one of the existing supported methods: including X.509 certificates (procured from a third-party CA), symmetric keys, and Trusted Platform Modules (TPM) [Include links to DPS sections for these]. When using certificate management with DPS, we currently only support HTTP, MQTT, and MQTT-Web-Sockets protocols.  

- **Operational Certificate:** An operational certificate is an end-entity certificate issued by an intermediate CA during a device’s provisioning process. Once the device is provisioned, the operational certificate can be used to authenticate directly with IoT Hub. Today, certificate management will issue an the operational certificate to authenticate a device in its daily operations. These certificates are typically short-lived and renewed as needed during device operation. 




