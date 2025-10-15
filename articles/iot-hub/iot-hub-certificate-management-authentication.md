---
title: Use Certificate-based Authentication with Certificate Management
titleSuffix: Azure IoT Hub
description: This article 
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: overview
ms.date: 10/20/2025
#Customer intent: As a developer new to IoT, I want to understand what Certificate Management is and how it can help me manage my IoT device certificates.
---

# Use certificate-based authentication with Certificate Management

**Applies to:** ![IoT Hub checkmark](media/iot-hub-version/yes-icon.png) IoT Hub Gen 2

Certificate Management is a built-in feature of IoT Hub Gen 2 that enables you to manage device certificates using Microsoft-managed PKI with X.509 certificates.

For more information, see [What is Certificate Management?](iot-hub-certificate-management-overview.md).

> [!IMPORTANT]
> To use Certificate Management, you need to set up an [Azure Device Registry (ADR) namespace](iot-hub-device-registry-setup.md) and link it to your IoT Hub Gen 2 instance. 

## Types of X.509 device certificates

To use certificate-based authentication for Certificate Management, you need to generate and manage certificates for your devices. There are two general categories of X.509 certificates:

- **CA certificates**: These certificates are issued by a Certificate Authority (CA), and you use them to sign other certificates. CA certificates include root and intermediate certificates.

    - **Root certificates**: A root certificate is a top-level, self-signed certificate from a trusted CA that can be used to sign intermediate CAs.
    - **Intermediate certificates**: An intermediate certificate is a CA certificate that is signed by a trusted root certificate. You can use intermediate certificates to sign end-entity certificates, such as individual or leaf device certificates. You can also use intermediate certificates to sign other intermediate certificates and create a chain of intermediates. In a chain of intermediate certificates, you can use the last intermediate certificate to sign end-entity certificates, including device certificates.

    > [!TIP]
    > It can be helpful to use different intermediate certificates for different sets or groups of devices, such as devices from different manufacturers or different models of devices. The reason to use different certificates is to reduce the total security impact if any particular certificate is compromised.

- **End-entity certificates**: These certificates, which can be individual or leaf device certificates, are signed by CA certificates and are issued to users, servers, or devices.

## Device onboarding and operational certificates

Every device that onboards and connects to Certificate Management, uses two end-entity certificates: one for device onboarding, and another for device operations. 

### Device onboarding certificate

An onboarding certificate is an end-entity or leaf certificate issued by an intermediate CA, and created when a device is manufactured. These are typically long-lived certificates that don’t expire between the time the device is manufactured and onboarded. Long-lived certificates are useful because, for example, devices might sit in a warehouse powered down until they are onboarded. For a device to onboard through Certificate Management, a device onboarding certificate is required to be installed. Certificate Management uses this certificate to authenticate a device for onboarding into its environment and role. The onboarding process provisions the device with the software and configuration needed to operate it. After onboarding, you should replace the original onboarding certificate with a new onboarding certificate. This step is necessary to handle tasks such as factory reset, or onboarding the device again.

> [!IMPORTANT]
> Certificate Management **doesn't provide** onboarding certificate services. You must use a trusted CA to generate and manage device onboarding certificates, and the intermediate and root certificates used for signing the onboarding certificates. 

In dev/test environments, you can use self-signed certificates. For production, Certificate Management requires you to use certificates from a trusted CA within a device manufacturing process to generate and manage your certificates.

Certificate Management only accepts X.509 certificates that use either the Rivest-Shamir-Adleman (RSA) algorithm or the Elliptic Curve Cryptography (ECC) algorithm for encryption. ECC and RSA provide equivalent levels of encryption strength, but ECC uses a shorter key length.

If you use ECC methods to generate X.509 certificates for device attestation, we recommend the following elliptic curves:

- nistP256
- nistP384
- nistP521

### Device operational certificate

An operational certificate is an end-entity certificate issued by an intermediate CA during a device’s onboarding process. Certificate Management uses the operational certificate to authenticate a device in its daily operations. These certificates are typically short-lived and renewed as needed during device operation.

In some cases, the device onboarding certificate can be used as the operational certificate as well. This is less secure because a compromise of the certificate enables access to both onboarding and operational services.






