---
title: include file
description: include file
author: dominicbetts
ms.topic: include
ms.date: 12/08/2025
ms.author: dobett
---

To test the new connector locally, follow these steps:

1. Create a local endpoint that acts as a REST server for the connector to connect to. In the `explore-iot-operation` repository you cloned previously, run the following commands to build a local REST server for testing:

    <!-- TODO: Make sure this path is correct -->

    ```bash
    cd samples/sample-rest-server
    docker build -t rest-server:latest .
    ```

    You can see the image in Docker Desktop.

1. Run the following command to start the REST server in a local container:

    ```bash
    docker run -d --rm --network aio_akri_network --name restserver rest-server:latest
    ```

1. You can see the container running in Docker Desktop. The REST server is accessible at `http://restserver:3000` for containers running on `aio_akri_network`.

1. In your connector workspace in VS Code, add a file called `rest-server-device-definition.yaml` to the **Devices** folder with the following content. This device resource defines an endpoint connection to the REST server:

    ```yml
    apiVersion: namespaces.deviceregistry.microsoft.com/v1
    kind: Device
    metadata:
      name: my-rest-thermostat-device-name
      namespace: azure-iot-operations
    spec:
      attributes:
        deviceId: my-thermostat
        deviceType: thermostat-device-type
      enabled: true
      endpoints:
        inbound:
          my-rest-thermostat-endpoint-name:
            additionalConfiguration: '{}'
            address: http://restserver:3000
            authentication:
              method: Anonymous
            endpointType: rest-thermostat-endpoint-type
      uuid: 1234-5678-9012-3456
      version: 2
    ```

1. In your connector workspace in VS Code, add a file called `rest-server-asset1-definition.yaml` to the **Assets** folder with the following content. This asset publishes temperature information from the device to an MQTT topic:

    ```yml
    apiVersion: namespaces.deviceregistry.microsoft.com/v1
    kind: Asset
    metadata:
      name: my-rest-thermostat-asset1
      namespace: azure-iot-operations
    spec:
      attributes:
        assetId: my-rest-thermostat-asset1
        assetType: rest-thermostat-asset
      datasets:
        - name: thermostat_status
          dataPoints:
            - dataSource: /api/thermostat/current
              name: currentTemperature
              dataPointConfiguration: |-
               {
                  "HttpRequestMethod": "GET",
               }
            - dataSource: /api/thermostat/desired
              name: desiredTemperature
              dataPointConfiguration: |-
               {
                  "HttpRequestMethod": "GET",
               }
          dataSource: /thermostat
          destinations:
            - configuration:
                topic: mqtt/machine/asset1/status
              target: Mqtt
      deviceRef:
        deviceName: my-rest-thermostat-device-name
        endpointName: my-rest-thermostat-endpoint-name
      version: 1
    ```

1. In your connector workspace in VS Code, add a file called `rest-server-asset2-definition.yaml` to the **Assets** folder with the following content. This asset publishes temperature information from the device to the state store:

    ```yml
    apiVersion: namespaces.deviceregistry.microsoft.com/v1
    kind: Asset
    metadata:
      name: my-rest-thermostat-asset2
      namespace: azure-iot-operations
    spec:
      attributes:
        assetId: my-rest-thermostat-asset2
        assetType: rest-thermostat-asset
      datasets:
        - name: thermostat_status
          dataPoints:
            - dataSource: /api/thermostat/current
              name: currentTemperature
              dataPointConfiguration: |-
               {
                  "HttpRequestMethod": "GET",
               }
            - dataSource: /api/thermostat/desired
              name: desiredTemperature
              dataPointConfiguration: |-
               {
                  "HttpRequestMethod": "GET",
               }
          dataSource: /thermostat
          destinations:
            - configuration:
                key: RestThermostatKey
              target: BrokerStateStore
      deviceRef:
        deviceName: my-rest-thermostat-device-name
        endpointName: my-rest-thermostat-endpoint-name
      version: 1
    ```

1. To test the connector, go to the `Run and Debug` panel in the VS Code workspace and select the `Run an Akri Connector` configuration. This configuration launches a terminal that runs the prelaunch tasks to start the `aio-broker` container and the REST connector you developed in another container called `<connector_name>_release`. This process takes several minutes. You can see the telemetry data flow from the REST server to the MQ broker through the REST connector in the terminal window in VS Code. The container logs are also visible in Docker Desktop.

1. You can stop the execution anytime by using the `Stop` button on the debug command panel. This command cleans up and deletes the running containers `aio-broker` and `<connector_name>_release`.