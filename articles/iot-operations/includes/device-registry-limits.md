---
author: dominicbetts
ms.author: dobett
ms.service: azure-device-registry
ms.topic: include
ms.date: 11/07/2025
---

The following table lists the limits that apply to the Azure Device Registry resources. Azure Device Registry is used with Azure IoT Hub and Azure IoT Operations.

| Resource type | Limit type | Limit |
|---------------|------------|-------|
| Azure Device Registry namespaces | Count per Azure subscription | 100 |
| Devices | Count per Azure subscription | 100,000 |
| Devices / discovered devices | Count per Kubernetes cluster | 2,000 |
| Devices / discovered devices | Count per Azure Device Registry namespace | 10,000 |
| Devices (IoT Hub) (read) | Operations per minute per Azure subscription | 5,000 |
| Devices (IoT Hub) (create/update) | Operations per minute per Azure subscription | 500 |
| Assets  / discovered assets | Count per Azure Device Registry namespace | 10,000 |
| Assets / discovered assets | Count per Kubernetes cluster | 2,000 |
| Top level-assets | Count per Azure subscription | 10,000 |
| Assets: datasets, event groups, and management groups | Count per asset | 100 |
| Assets: data points, events, and management actions | Count per asset | 1,000 |
| Assets and devices | Azure Resource Manager operations per second per Azure subscription (in both directions) | 600 |
| Schema registries | Count per Azure subscription | 100 |
| Schemas | Read operations per minute per Azure subscription | 600 |
| Schema versions | Read operations per minute per Azure subscription | 600 |
| Schema registries | Read operations per minute per Azure subscription | 600 |
| Policies (preview) | Count per Azure Device Registry namespace | 1 |
| Credentials (preview) | Count per Azure Device Registry namespace | 1 |
| Credentials (preview) | Count per Entra ID tenant | 2 |
