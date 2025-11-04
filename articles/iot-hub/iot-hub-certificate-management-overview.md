---
title: What is Certificate Management (Preview)?
titleSuffix: Azure IoT Hub
description: This article discusses the basic concepts of how Certificate Management in Azure IoT Hub helps users manage device certificates.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: overview
ms.date: 11/07/2025
#Customer intent: As a developer new to IoT, I want to understand what Certificate Management is and how it can help me manage my IoT device certificates.
---

# What is Certificate Management (Preview)?

Certificate Management is a built-in feature of Azure Device Registry (ADR) that enables you to issue X.509 certificates for your IoT devices. It configures a dedicated, cloud-based public key infrastructure (PKI) for each of your ADR namespaces, without requiring any on-premises servers, connectors, or hardware. It handles the certificate of issuance and renewal for all IoT devices that have been provisioned to that ADR Namespace. These X.509 certificates can be used for your IoT devices to authenticate with IoT Hub. 

Using Certificate Management requires you to also use IoT Hub, [Azure Device Registry (ADR)](iot-hub-device-registry-setup.md), and [Device Provisioning Service (DPS)](../iot-dps/index.yml). Certificate Management is currently in public preview.

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## Overview of features

The following features are supported with Certificate Management for IoT Hub devices in preview:

| Feature | Description |
|---------|-------------|
| Create multiple certificate authorities (CA) in an ADR Namespace | Create two-tier PKI hierarchy with root and issuing CA in the cloud. |
| Create a unique root certificate authority (CA) per ADR Namespace | Create up to 1 root CA, also known as a credential, in your ADR namespace |
| Create up to one issuing CA per policy | Create up to 1 issuing CA, also known as a policy, in your ADR namespace and customize validity periods for issued certificates. |
| Signing and Encryption algorithms | The issuing CA will sign end-entity certificates using the following key type: ECC NistP384 |
| HSM keys (signing and encryption) | Keys are provisioned using [Azure Managed Hardware Security Module (Azure Managed HSM)](/azure/key-vault/managed-hsm/overview). CAs created within your ADR namespace automatically use HSM signing and encryption keys. No Azure subscription is required for Azure HSM. |
| End-entity certificate issuance and renewal | End-entity certificates, also known as leaf certificates or device certificates, are signed by the issuing CA and delivered to the device. Leaf certificates can also be renewed by the issuing CA.
| At-scale provisioning of leaf certificates | The policies defined in your ADR namespace are directly linked to a Device Provisioning Service enrollment group to be used at the time of certificate provisioning.
| Syncing of CA chains with IoT Hubs | The policies defined in your ADR namespace will be synced to the appropriate IoT Hub. This will enable IoT Hub to trust any devices authenticating with an end-entity certificate. |

## How Certificate Management works

Certificate Management consists of several integrated components that work together to streamline the deployment of public key infrastructure (PKI) across IoT devices. To use Certificate Management with IoT Hub, you must set up both:

- Azure Device Registry (ADR) namespace
- Device Provisioning Service (DPS) instance.

### Azure Device Registry integration

Certificate Management uses [Azure Device Registry (ADR)](iot-hub-device-registry-overview.md) to manage device certificates. ADR is a service that provides secure device identity and authentication for IoT solutions. It integrates with IoT Hub and Device Provisioning Service (DPS) to provide a seamless experience for managing device identities and certificates.

The following image illustrates the X.509 certificate hierarchy used to authenticate IoT devices in Azure IoT Hub through the ADR namespace.

- Each ADR namespace (cloud) has a unique root CA credential managed by Microsoft. This credential acts as the primary certificate authority in the chain.
- Each policy within the ADR namespace defines an issuing CA (ICA) signed by the root CA. Each policy can issue leaf certificates for devices registered within that ADR namespace and with Hubs linked to the namespace. This structure enables scalable identity management and policy enforcement across device groups.
- Each device (field) is authenticated using an X.509 leaf certificate issued and signed by one of the ICAs defined in the policy. The leaf certificate is used for secure communication with IoT Hub.

:::image type="content" source="media/certificate-management/device-registry-certificate-management.png" alt-text="Diagram showing how Azure Device Registry integrates with IoT Hub and DPS for certificate management." lightbox="media/certificate-management/device-registry-certificate-management.png":::

### Device Provisioning Service integration

To use Certificate Management, devices must be provisioned through [Device Provisioning Service (DPS)](../iot-dps/index.yml). You need to configure either individual or group enrollment, which includes:

1. Selecting the specific method for device onboarding authentication. Supported methods are Trusted Platform Module (TPM), symmetric keys, or X.509 certificates.
2. Linking a policy created within your ADR namespace to manage certificate issuance and lifecycle at-scale.

Device Provisioning Service now accepts Certificate Signing Requests (CSR). IoT devices generate a **Certificate Signing Request (CSR)** containing their public key and identity to prove key ownership. The CSR is sent to the PKI, which validates it and forwards it to an **Issuing CA (ICA)** to issue an X.509 certificate. For more information on DPS Certificate Signing Request, check out some the Device DPS SDKs samples.

> [!NOTE]
> While a PKI is configured for each of your ADR Namespaces, it's not exposed as an external Azure resource.

### End-to-end device provisioning with Certificate Management

The following diagram illustrates the end-to-end process of device provisioning with Certificate Management:

1. The IoT device connects to DPS using an onboarding credential and sends a certificate signing request (CSR). The CSR contains information about the device, such as its public key and other identifying details.
2. DPS authenticates the device using its onboarding credentials and assigns it to an IoT Hub based on its enrollment group. The device is also registered in the ADR namespace for certificate lifecycle management.
3. The device identity is created in IoT Hub and linked to the appropriate ADR namespace.
4. DPS requests an X.509 operational certificate from Microsoft PKI using the CSR and the policy defined by the enrollment group.
5. Microsoft PKI returns the signed operational certificate to DPS.
6. DPS sends the operational certificate and IoT Hub connection details back to the device.
7. The device now authenticates with IoT Hub by sending the full issuing certificate chain to IoT Hub.

:::image type="content" source="media/certificate-management/operational-diagram.png" alt-text="Diagram showing how Azure Device Registry integrates with IoT Hub and DPS for certificate management during provisioning." lightbox="media/certificate-management/operational-diagram.png":::

## Renewal of certificates

Certificate renewals are performed using the same mechanism as certificate issuance. When the device detects a need to renew its operational certificate, device initiates another provisioning call to DPS, submitting a new Certificate Signing Request (CSR) signed by its private key. The CSR is sent to the appropriate intermediate certificate authority (ICA) to request a new leaf certificate. Once approved, the new operational certificate is returned to the device for continued secure authentication with IoT Hub. 

Due to the wide variety of IoT devices, each device is responsible for monitoring the expiration date of its operational certificate and determining when renewal is required. The certificate includes its **expiration date**, which the device can track to identify when renewal is needed. 

## Disable a device

Certificate Management doesn't support certificate revocation during public preview. To remove the connection of a device that uses an X.509 operational certificate, you can disable the device in the IoT hub registry. To disable a device, see [Disable or delete a device](create-connect-device.md#disable-or-delete-a-device).

## Limits and quotas

The following table lists the default limits and quotas for Certificate Management:

|Feature|Limit|
|----------------------------------|-------------------------------|
|Number of certificates issued by PKI (by a device DPS instance) during provisioning|500 per minute|
|Number of certificate renewals|500 per minute|
|Number of credential resources per tenant|2|
|Number of credential resources per ADR namespace|1|
|Number of policies per credential resource|1|
