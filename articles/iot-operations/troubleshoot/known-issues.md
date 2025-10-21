---
title: "Known issues: Azure IoT Operations"
description: Known issues for the MQTT broker, connector for OPC UA, OPC PLC simulator, data flows, and operations experience web UI.
author: dominicbetts
ms.author: dobett
ms.topic: troubleshooting-known-issue
ms.custom: sfi-ropc-nochange
ms.date: 10/21/2025
---

# Known issues: Azure IoT Operations

This article lists the current known issues you might encounter when using Azure IoT Operations. The guidance helps you identify these issues and provides workarounds where available.

For general troubleshooting guidance, see [Troubleshoot Azure IoT Operations](troubleshoot.md).

## MQTT broker issues

This section lists current known issues for the MQTT broker.

### MQTT broker resources aren't visible in the Azure portal

---

Issue ID: 4257

---

Log signature: N/A

---

MQTT broker resources created in your cluster using Kubernetes aren't visible in the Azure portal. This result is expected because [managing Azure IoT Operations components using Kubernetes is in preview](../deploy-iot-ops/howto-manage-update-uninstall.md#manage-components-using-kubernetes-deployment-manifests-preview), and synchronizing resources from the edge to the cloud isn't currently supported.

There's currently no workaround for this issue.

## Connector for OPC UA issues

This section lists current known issues for the connector for OPC UA.

### An OPC UA server modeled as a device can only have one inbound endpoint of type "Microsoft.OpcUa"

---

Issue ID: 2411

---

`2025-07-24T13:29:30.280Z aio-opc-supervisor-85b8c78df5-26tn5 - Maintaining the new asset test-opcua-asset | - | 1 is skipped because the endpoint profile test-opcua.opcplc-e2e-anon-000000 is not present`

---

When you create an OPC UA device, you can only have one inbound endpoint of type `Microsoft.OpcUa`. Currently, any other endpoints aren't used.

Workaround: Create multiple devices with a single endpoint each if you want to use namespace assets.

An OPC UA namespaced asset can only have a single dataset. Currently, any other datasets aren't used.

Workaround: Create multiple namespace assets each with a single dataset.

### Application error BadUnexpectedError

---

Issue ID: 9044

---

Log signature: `BadUnexpectedError`

---

In the process control sample application, if you call the `Switch` method on the demo asset `demo-method-call.asset.yaml` then currently you receive a `BadUnexpectedError` application error.

## Connector for media and connector for ONVIF issues

This section lists current known issues for the connector for media and the connector for ONVIF.

### Secret sync conflict

---

Issue ID: 0606

---

Log signature: N/A

---

When using secret sync, ensure that secret names are globally unique. If a local secret with the same name exists, connectors might fail to retrieve the intended secret.

## Data flows issues

This section lists current known issues for data flows.

### Data flow resources aren't visible in the operations experience web UI

---

Issue ID: 8724

---

Log signature: N/A

---

Data flow custom resources created in your cluster using Kubernetes aren't visible in the operations experience web UI. This result is expected because [managing Azure IoT Operations components using Kubernetes is in preview](../deploy-iot-ops/howto-manage-update-uninstall.md#manage-components-using-kubernetes-deployment-manifests-preview), and synchronizing resources from the edge to the cloud isn't currently supported.

There's currently no workaround for this issue.

### A data flow profile can't exceed 70 data flows

---

Issue ID: 1028

---

Log signature:

`exec /bin/main: argument list too long`

---

If you create more than 70 data flows for a single data flow profile, deployments fail with the error `exec /bin/main: argument list too long`.

To work around this issue, create multiple data flow profiles and distribute the data flows across them. Don't exceed 70 data flows per profile.

### The request persistence flag is not set for MQTT sessions created for data flow graphs (WASM)

---

Issue ID: 6415

---

Log signature: N/A

---

When you create a data flow graph using the WASM, the MQTT session doesn't have the request persistence flag set.

To work around this issue, set MQTT broker **Retained messages** mode to `All`. For more information, see [Configure MQTT broker persistence](../manage-mqtt-broker/howto-broker-persistence.md).

### Data flow graphs only support specific endpoint types

---

Issue ID: 5693

---

Log signature: N/A

---

Data flow graphs (WASM) currently only support MQTT, Kafka, and OpenTelemetry (OTel) data flow endpoints. OpenTelemetry endpoints can only be used as destinations in data flow graphs. Other endpoint types like Data Lake, Microsoft Fabric OneLake, Azure Data Explorer, and Local Storage are not supported for data flow graphs.

To work around this issue, use one of the supported endpoint types:
- [MQTT endpoints](../connect-to-cloud/howto-configure-mqtt-endpoint.md) for bi-directional messaging with MQTT brokers
- [Kafka endpoints](../connect-to-cloud/howto-configure-kafka-endpoint.md) for bi-directional messaging with Kafka brokers, including Azure Event Hubs
- [OpenTelemetry endpoints](../connect-to-cloud/howto-configure-opentelemetry-endpoint.md) for sending metrics and logs to observability platforms (destination only)

For more information about data flow graphs, see [Use WebAssembly (WASM) with data flow graphs](../connect-to-cloud/howto-dataflow-graph-wasm.md).

### Complex data might be flattened when enriching data in a data flow

---

Issue ID: 7385

---

Log signature: N/A

---

When enriching data using complex object DSS reference data, the output might be moved to the root level instead of preserving the original structure.

For example, if you have a complex object with properties like:

```json
{
  "complex_property_1": {
      "field1": 12,
      "field2": 13 
  },
  "complex_property_2": {
     "field2": 24
  }
}
```

The output might look like:

```json
{
  "property_1": 2,
  "property_2": 3,
  "field1": 12,
  "field2": 24,
}
```

The complex properties are flattened to the root, and the original structure is lost. If fields with the same name exist in the complex objects or the root, the values might overwrite the root values. In the example, `field2` from `complex_property_2` overwrites the `field2` from `complex_property_1`.


### Can't use the same graph definition multiple times in a chained graph scenario

---

Issue ID: N/A

---

Failed to send config

---

You create a chained graph scenario by using the output of one data flow graph as the input to another data flow graph. However, if you try to use the same graph definition multiple times in this scenario, it currently doesn't work as expected. For example, the following code fails when using the same graph definition (`graph-passthrough:1.3.6`) for both `graph-1` and `graph-2`.

```bicep
      {
          nodeType: 'Graph'
          name: 'graph-1'
          graphSettings: {
            registryEndpointRef: dataflowRegistryEndpoint.name
            artifact: 'graph-passthrough:1.3.6'
            configuration: []
            }
      }
      {
          nodeType: 'Graph'
          name: 'graph-2'
          graphSettings: {
            registryEndpointRef: dataflowRegistryEndpoint.name
            artifact: 'graph-passthrough:1.3.6'
            configuration: graphConfiguration
            }
      }
  nodeConnections: [
      {
          from: {name: 'source'}
          to: {name: 'graph-1'}
      }
      {
          from: {name: 'graph-1'}
          to: {name: 'graph-2'}
      }
      {
          from: {name: 'graph-2'}
          to: {name: 'destination'}
      }
  ]
```

To solve this error, push the graph definition to the ACR as many times as needed with the scenario with a different name or tag each time. For example, in the scenario described, the graph definition need to be pushed twice with either a different name or a different tag, such as `graph-passthrough-one:1.3.6` and `graph-passthrough-two:1.3.6`.

### Can't use the same module within a graph multiple times

---

Issue ID: N/A

---

Failed to send config

---

You create a data flow graph that uses the same module multiple times. For example, the following declared the `"module-passthrough/filter"` operation once, but fails when using it twice in the connections.

```yaml
- operationType: "filter"
  name: "module-passthrough/filter"
  module: "module-passthrough:1.3.6"
- operationType: "synk"
  name: "synk"
connections: 
- from:
    name: "source"
  to:
    name: "module-passthrough/filter"
- from:
    name: "module-passthrough/filter"
  to:
    name: "module-passthrough/filter"
- from:
    name: "module-passthrough/filter"
  to:
    name: "synk"
```

To resolve this issue, declare each operation as a separate instance with a unique name every time it is used. For example, in the scenario described, define the operation twice with distinct names, such as `"module-passthrough-one/filter"` and `"module-passthrough-two/filter"`.

```yaml
- operationType: "filter"
  name: "module-passthrough-one/filter"
  module: "module-passthrough:1.3.6"
- operationType: "filter"
  name: "module-passthrough-two/filter"
  module: "module-passthrough:1.3.6"
```