---
title: Key Concepts for Certificate Management (Preview)
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

# Key concepts for certificate management (preview)

Certificate management in Azure IoT Hub is designed to simplify the management of X.509 certificates for IoT devices. This article introduces the fundamental concepts related to certificate management and certificate-based authentication in IoT Hub. For more information, see [What is certificate management (preview)?](iot-hub-certificate-management-overview.md).

[!INCLUDE [public-preview-banner](includes/public-preview-banner.md)]

## Public Key Infrastructure (PKI)

PKI is a system that uses digital certificates to authenticate and encrypt data between devices and services. PKI certificates are essential for securing various scenarios, such as web and device identity. In IoT settings, managing PKI certificates can be challenging, costly, and complex, especially for organizations that have a large number of devices and strict security requirements. You can use certificate management to enhance the security of your devices and accelerate your digital transformation to a fully managed cloud PKI service. 

## Microsoft vs. third-party PKI

While IoT Hub supports two types of PKI providers for X.509 certificate authentication, certificate management currently only supports Microsoft-managed (first-party) PKI. For information about using third-party PKI providers, see [Authenticate devices with X.509 CA certificates](authenticate-authorize-x509.md).

| PKI provider | Integration required | ADR required | DPS required |
|--------------|----------------------|-------------------| --------------|
| Microsoft-managed PKI | No. Configure certificate authorities directly in Azure Device Registry (ADR).| Yes | Yes |
| Third-party PKI (DigiCert, GlobalSign, etc.) | Yes. Manual integration required.  | No | No |

## X.509 Certificates

An X.509 certificate is a digital document to bind a public key to the identity of an entity, such as a device, user, or service. Certificate-based authentication offers these benefits over less secure methods or device authentication:

- Certificates use public/private key cryptography (asymmetric). While the public key is shared freely, the private key never leaves the device and can live inside TPMs or secure element.
- Certificates are issued and validated through a CA hierarchy, allowing millions of devices to be trusted via single CA without managing per-device secrets.
- Devices can authenticate to the cloud and the cloud can authenticate to the device, enabling mutual TLS authentication.
- Certificates can have defined validity periods and can be centrally renewed or revoked.

There are two general categories of X.509 certificates: 

- **CA certificates:** These certificates are issued by a Certificate Authority (CA), and you use them to sign other certificates. CA certificates include root and intermediate certificates. 
    
    - **Root CA:** A root certificate is a top-level, self-signed certificate from a trusted CA that can be used to sign intermediate CAs. 
    
    - **Intermediate or Issuing CA:**  An intermediate certificate is a CA certificate that is signed by a trusted root certificate. You can use intermediate certificates to sign end-entity certificates, such as individual or leaf device certificates, in which case you could call this an issuing CA. 

    > [!NOTE]
    > It might be helpful to use different intermediate certificates for different sets or groups of devices, such as devices from different manufacturers or different models of devices. The reason to use different certificates is to reduce the total security impact if any particular certificate is compromised. 

- **End-entity certificates:** These certificates, which can be individual or leaf device certificates, are signed by CA certificates and are issued to users, servers, or devices. 

## Authentication vs. authorization

*Authentication* is the process of proving that you're who you say you are. Authentication verifies the identity of a user or device to IoT Hub. It's sometimes shortened to *AuthN*. 

*Authorization* is the process of confirming permissions for an authenticated user or device on IoT Hub. It specifies what resources and commands you're allowed to access, and what you can do with those resources and commands. Authorization is sometimes shortened to *AuthZ*.

X.509 certificates are only used for authentication in IoT Hub, not authorization. Unlike with [Microsoft Entra ID](authenticate-authorize-azure-ad.md) and [shared access signatures](authenticate-authorize-sas.md), you can't customize permissions with X.509 certificates.


