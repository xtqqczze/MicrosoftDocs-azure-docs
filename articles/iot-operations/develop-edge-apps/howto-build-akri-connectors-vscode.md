---
title: Build Akri connectors in VS Code
description: Learn how to build Akri connectors using Visual Studio Code for Azure IoT Operations.
author: dominicbetts 
ms.author: dobett 
ms.topic: how-to
ms.date: 12/05/2025
ms.service: azure-iot-operations

# CustomerIntent: As a developer, I want to understand how to use the VS Code extension to build and deploy custom Akri connectors.
---

# Build Akri connectors in VS Code

This article describes how to build, validate, debug, and publish custom Akri connectors using the Azure IoT Operations Akri connectors VS Code extension.

The extension is supported on the following platforms:

- Linux
- Windows Subsystem for Linux (WSL)
- Windows

The extension enables you to create connectors in the following programming languages:

- .NET
- Rust

## Prerequisites

Software and services:

- Azure IoT Operations
  Currently, the MQTT broker must be configured to use the medium memory profile for the Python modules to work.
- Linux or WSL environment with `kubectl` and `helm` installed
- Docker

> [!TIP] 
> To meet these requirements on Linux, use the [quickstart codespace](../get-started-end-to-end-sample/quickstart-deploy.md) to deploy and Azure IoT Operations instance.

Development environment:

- [Visual Studio Code](https://code.visualstudio.com/)
- [Azure IoT Operations Akri connectors](https://github.com/Azure/azure-iot-operations-preview/releases/tag/akri-v0.2.10) VS Code extension
- [.NET SDK](https://dotnet.microsoft.com/download)
- To debug .NET based connectors - [C# extension](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp)
- To debug Rust based connectors - [C/C++ extension](https://marketplace.visualstudio.com/items?itemName=ms-VS Code.cpptools)
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- [ORAS CLI](https://oras.land/docs/installation/)

Docker configuration:

Images used by the extension must be pulled and tagged locally before using the extension:

```bash
docker pull mqpreview.azurecr.io/devx-runtime:0.1.7
docker tag mqpreview.azurecr.io/devx-runtime:0.1.7 devx-runtime
```

All the containers the extension launches are configured to run on a custom network named `aio_akri_network` for network isolation purpose:

```bash
docker network create aio_akri_network
```

The DevX container uses a custom volume `akri_devx_docker_volume` to store cluster configuration:

```bash
docker volume create akri_devx_docker_volume
```

> [!NOTE]:
> Currently, launching the DevX image as a container from WSL without Docker Desktop installed causes the container to hang forever.

## Author and validate a .NET Akri connector

In this example, you create an HTTP/REST connector using the C# language, build a docker image, and then run the connector application using the VS Code extension:

1. Press `Ctrl+Shift+P` to open the command palette and search for `Azure IoT Operations Akri Connectors: Create a New Akri Connector` command. Create a new folder called `rest-connector` and select it, select `C#` as the language, enter a name for the connector like `rest-connector`, and select `PollingTelemetryConnector` as the connector type.

1. The extension creates a new workspace named using the connector name you chose in the previous step. The workspace includes the scaffolding for a polling telemetry connector in C# language.

1. Create a file called **ThermostatStatus.cs** in the <connector_name> folder in the workspace with the following content. This file models the JSON response. Replace the `<connector_name>` placeholder with the name you chose for the connector:

    ```c#
    using System.Text.Json.Serialization;

    namespace <connector_name>
    {
        internal class ThermostatStatus
        {
            [JsonPropertyName("desiredTemperature")]
            public double? DesiredTemperature { get; set; }

            [JsonPropertyName("currentTemperature")]
            public double? CurrentTemperature { get; set; }
        }
    }    
    ```

1. Create a file called **DataPointConfiguration.cs** in the <connector_name> folder in the workspace with the following content. This file models the JSON response. Replace the `<connector_name>` placeholder with the name you chose for the connector:

    ```c#
    using System.Text.Json.Serialization;

    namespace <connector_name>
    {
        public class DataPointConfiguration
        {
            [JsonPropertyName("HttpRequestMethod")]
            public string? HttpRequestMethod { get; set; }
        }
    }   
    ```

1. Implement the `SampleDatasetAsync` function in the `DatasetSampler` class. The function takes a `Dataset` as a parameter, which contains the data points that the connector should process. Open the file `<connector-name>/DatasetSampler.cs` and implement the function as follows:

> [!TIP]
> To see a complete implementation of this function, refer to [ThermostatStatusDatasetSampler.cs](https://github.com/Azure/iot-operations-sdks/blob/feature/akri/dotnet/samples/Connectors/PollingRestThermostatConnector/ThermostatStatusDatasetSampler.cs) in the Thermostat REST Connector sample.

1. Edit the file _DatasetSampler.cs_.

1. First, add a constructor so we can pass in the data needed for processing the endpoint data:

    > The `HttpClient` and `EndpointProfileCredentials` are used for connecting and authenticated with the asset endpoint.

    ```c#
    private readonly HttpClient _httpClient;
    private readonly string _assetName;
    private readonly EndpointCredentials? _credentials;

    private readonly static JsonSerializerOptions _jsonSerializerOptions = new()
    {
        AllowTrailingCommas = true,
    };

    public DatasetSampler(HttpClient httpClient, string assetName, EndpointCredentials? credentials)
    {
        _httpClient = httpClient;
        _assetName = assetName;
        _credentials = credentials;
    }

    public ValueTask DisposeAsync()
    {
        _httpClient.Dispose();
        return ValueTask.CompletedTask;
    }
    ```

1. To the `SampleDatasetAsync` function, add the following to retrieve each `DataPoint` from the `DataSet` and extract the data source paths, which will be the URL used to fetch the data from the REST endpoint:

    > The  `currentTemperature` and `desiredTemperature` data points were modelled earlier

    ```c#
    AssetDatasetDataPointSchemaElement httpServerDesiredTemperatureDataPoint = dataset.DataPoints!.Where(x => x.Name!.Equals("desiredTemperature"))!.First();
    HttpMethod httpServerDesiredTemperatureHttpMethod = HttpMethod.Parse(JsonSerializer.Deserialize<DataPointConfiguration>(httpServerDesiredTemperatureDataPoint.DataPointConfiguration!, _jsonSerializerOptions)!.HttpRequestMethod);
    string httpServerDesiredTemperatureRequestPath = httpServerDesiredTemperatureDataPoint.DataSource!;

    AssetDatasetDataPointSchemaElement httpServerCurrentTemperatureDataPoint = dataset.DataPoints!.Where(x => x.Name!.Equals("currentTemperature"))!.First();
    HttpMethod httpServerCurrentTemperatureHttpMethod = HttpMethod.Parse(JsonSerializer.Deserialize<DataPointConfiguration>(httpServerDesiredTemperatureDataPoint.DataPointConfiguration!, _jsonSerializerOptions)!.HttpRequestMethod);
    string httpServerCurrentTemperatureRequestPath = httpServerCurrentTemperatureDataPoint.DataSource!;
    ```

1. In the same function, setup authentication with the provided credentials (if authenticated endpoints are being used):

    > This extracts the credentials, and adds them to the authorization header. The `DatasetSampler` implements **basic authentication** with username and password.

    ```c#
    if (_credentials != null && _credentials.Username != null && _credentials.Password != null)
    {
        // Note that this sample uses username + password for authenticating the connection to the asset. In general,
        // x509 authentication should be used instead (if available) as it is more secure.
        string httpServerUsername = _credentials.Username;
        string httpServerPassword = _credentials.Password;
        var byteArray = Encoding.ASCII.GetBytes($"{httpServerUsername}:{httpServerPassword}");
        _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(byteArray));
    }
    ```

1. Follow this with a HTTP request to the endpoint and then deserialize the response:

    > Deserialize the response, and extract both the `CurrentTemperature` and `DesiredTemperature` properties and place them in a `ThermostatStatus` object.

    ```c#
    // In this sample, both the datapoints have the same datasource, so only one HTTP request is needed.
    var currentTemperatureHttpResponse = await _httpClient.GetAsync(httpServerCurrentTemperatureRequestPath);
    var desiredTemperatureHttpResponse = await _httpClient.GetAsync(httpServerDesiredTemperatureRequestPath);

    if (currentTemperatureHttpResponse.StatusCode == System.Net.HttpStatusCode.Unauthorized
        || desiredTemperatureHttpResponse.StatusCode == System.Net.HttpStatusCode.Unauthorized)
    {
        throw new Exception("Failed to authorize request to HTTP server. Check credentials configured in rest-server-device-definition.yaml.");
    }

    currentTemperatureHttpResponse.EnsureSuccessStatusCode();
    desiredTemperatureHttpResponse.EnsureSuccessStatusCode();

    ThermostatStatus thermostatStatus = new()
    {
        CurrentTemperature = (JsonSerializer.Deserialize<ThermostatStatus>(await currentTemperatureHttpResponse.Content.ReadAsStreamAsync(), _jsonSerializerOptions)!).CurrentTemperature,
        DesiredTemperature = (JsonSerializer.Deserialize<ThermostatStatus>(await desiredTemperatureHttpResponse.Content.ReadAsStreamAsync(), _jsonSerializerOptions)!).DesiredTemperature
    };
    ```

1. Next, serialize the status to json and return the response. 

    > In this example, the HTTP response payload already matches the expected message schema, so no translation is required:

    ```c#
    // Serialize the object to JSON and return it as a byte array
    return Encoding.UTF8.GetBytes(JsonSerializer.Serialize(thermostatStatus));
    ```

1. Finally, import the necessary types:

    ```c#
    using Azure.Iot.Operations.Connector.Files;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Text.Json;
    ```

1. The final code will resemble the following *(click to expand)*:

    <details>

    <summary>DatasetSampler.cs</summary>

    ```c#
    // Copyright (c) Microsoft Corporation.
    // Licensed under the MIT License.

    using Azure.Iot.Operations.Connector;
    using Azure.Iot.Operations.Services.AssetAndDeviceRegistry.Models;
    using Azure.Iot.Operations.Connector.Files;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Text.Json;

    namespace <connector_name>
    {
        internal class DatasetSampler : IDatasetSampler
        {
            private readonly HttpClient _httpClient;
            private readonly string _assetName;
            private readonly EndpointCredentials? _credentials;

            private readonly static JsonSerializerOptions _jsonSerializerOptions = new()
            {
                AllowTrailingCommas = true,
            };

            public DatasetSampler(HttpClient httpClient, string assetName, EndpointCredentials? credentials)
            {
                _httpClient = httpClient;
                _assetName = assetName;
                _credentials = credentials;
            }
            public Task<TimeSpan> GetSamplingIntervalAsync(AssetDataset dataset, CancellationToken cancellationToken = default)
            {
                return Task.FromResult(TimeSpan.FromSeconds(3));
            }

            public async Task<byte[]> SampleDatasetAsync(AssetDataset dataset, CancellationToken cancellationToken = default)
            {
                try
                {
                    AssetDatasetDataPointSchemaElement httpServerDesiredTemperatureDataPoint = dataset.DataPoints!.Where(x => x.Name!.Equals("desiredTemperature"))!.First();
                    HttpMethod httpServerDesiredTemperatureHttpMethod = HttpMethod.Parse(JsonSerializer.Deserialize<DataPointConfiguration>(httpServerDesiredTemperatureDataPoint.DataPointConfiguration!, _jsonSerializerOptions)!.HttpRequestMethod);
                    string httpServerDesiredTemperatureRequestPath = httpServerDesiredTemperatureDataPoint.DataSource!;

                    AssetDatasetDataPointSchemaElement httpServerCurrentTemperatureDataPoint = dataset.DataPoints!.Where(x => x.Name!.Equals("currentTemperature"))!.First();
                    HttpMethod httpServerCurrentTemperatureHttpMethod = HttpMethod.Parse(JsonSerializer.Deserialize<DataPointConfiguration>(httpServerDesiredTemperatureDataPoint.DataPointConfiguration!, _jsonSerializerOptions)!.HttpRequestMethod);
                    string httpServerCurrentTemperatureRequestPath = httpServerCurrentTemperatureDataPoint.DataSource!;

                    if (_credentials != null && _credentials.Username != null && _credentials.Password != null)
                    {
                        // Note that this sample uses username + password for authenticating the connection to the asset. In general,
                        // x509 authentication should be used instead (if available) as it is more secure.
                        string httpServerUsername = _credentials.Username;
                        string httpServerPassword = _credentials.Password;
                        var byteArray = Encoding.ASCII.GetBytes($"{httpServerUsername}:{httpServerPassword}");
                        _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(byteArray));
                    }

                    // In this sample, both the datapoints have the same datasource, so only one HTTP request is needed.
                    var currentTemperatureHttpResponse = await _httpClient.GetAsync(httpServerCurrentTemperatureRequestPath);
                    var desiredTemperatureHttpResponse = await _httpClient.GetAsync(httpServerDesiredTemperatureRequestPath);

                    if (currentTemperatureHttpResponse.StatusCode == System.Net.HttpStatusCode.Unauthorized
                        || desiredTemperatureHttpResponse.StatusCode == System.Net.HttpStatusCode.Unauthorized)
                    {
                        throw new Exception("Failed to authorize request to HTTP server. Check credentials configured in rest-server-device-definition.yaml.");
                    }

                    currentTemperatureHttpResponse.EnsureSuccessStatusCode();
                    desiredTemperatureHttpResponse.EnsureSuccessStatusCode();

                    ThermostatStatus thermostatStatus = new()
                    {
                        CurrentTemperature = (JsonSerializer.Deserialize<ThermostatStatus>(await currentTemperatureHttpResponse.Content.ReadAsStreamAsync(), _jsonSerializerOptions)!).CurrentTemperature,
                        DesiredTemperature = (JsonSerializer.Deserialize<ThermostatStatus>(await desiredTemperatureHttpResponse.Content.ReadAsStreamAsync(), _jsonSerializerOptions)!).DesiredTemperature
                    };

                    // The HTTP response payload matches the expected message schema, so return it as-is
                    return Encoding.UTF8.GetBytes(JsonSerializer.Serialize(thermostatStatus));
                }
                catch (Exception ex)
                {
                    throw new InvalidOperationException($"Failed to sample dataset with name {dataset.Name} in asset with name {_assetName}", ex);
                }
            }

            public ValueTask DisposeAsync()
            {
                _httpClient.Dispose();
                return ValueTask.CompletedTask;
            }
        }
    }
    ```

    </details>

> [!TIP] 
> For additional resilience, a try-catch block could be used to process any exceptions that should occur.

1. Implement DatasetSamplerProvider

In this step we will complete the `CreateDatasetSampler` function from the `DatasetSamplerProvider` class. This class will create `DataSetSampler` objects, which will be injected into the application as needed.

> [!TIP]
> To see a complete implementation of this function, refer to [RestThermostatDatasetSamplerProvider.cs](https://github.com/Azure/iot-operations-sdks/blob/feature/akri/dotnet/samples/Connectors/PollingRestThermostatConnector/RestThermostatDatasetSamplerProvider.cs) in the Thermostat Connector sample.

1. Edit the file _DatasetSamplerProvider.cs_.

1. In the `CreateDatasetSampler` function, return a `DatasetSampler` along with the `endpointCredentials`, if the dataset is `thermostat_status` (the one modelled earlier):

    ```c#
    if (dataset.Name.Equals("thermostat_status"))
    {
        if (device.Endpoints != null
            && device.Endpoints.Inbound != null
            && device.Endpoints.Inbound.TryGetValue(inboundEndpointName, out var inboundEndpoint))
        {
            var httpClient = new HttpClient()
            {
                BaseAddress = new Uri(inboundEndpoint.Address),
            };

            return new DatasetSampler(httpClient, assetName, endpointCredentials);
        }
    }

    throw new InvalidOperationException($"Unrecognized dataset with name {dataset.Name} on asset with name {assetName}");
    ```

1. The final code will resemble the following *(click to expand)*:

    <details>

    <summary>DatasetSamplerProvider.cs</summary>

    ```c#
    // Copyright (c) Microsoft Corporation.
    // Licensed under the MIT License.

    using Azure.Iot.Operations.Connector;
    using Azure.Iot.Operations.Connector.Files;
    using Azure.Iot.Operations.Services.AssetAndDeviceRegistry.Models;

    namespace <connector_name>
    {
        public class DatasetSamplerProvider : IDatasetSamplerFactory
        {
            public static Func<IServiceProvider, IDatasetSamplerFactory> Factory = service =>
            {
                return new DatasetSamplerProvider();
            };

            public IDatasetSampler CreateDatasetSampler(string deviceName, Device device, string inboundEndpointName, string assetName, Asset asset, AssetDataset dataset, EndpointCredentials? endpointCredentials)
            {
                if (dataset.Name.Equals("thermostat_status"))
                {
                    if (device.Endpoints != null
                        && device.Endpoints.Inbound != null
                        && device.Endpoints.Inbound.TryGetValue(inboundEndpointName, out var inboundEndpoint))
                    {
                        var httpClient = new HttpClient()
                        {
                            BaseAddress = new Uri(inboundEndpoint.Address),
                        };

                        return new DatasetSampler(httpClient, assetName, endpointCredentials);
                    }
                }

                throw new InvalidOperationException($"Unrecognized dataset with name {dataset.Name} on asset with name {assetName}");
            }
        }
    }
    ```
    </details>

1. Once the .NET Rest Connector is implemented, build the project to confirm there are no errors:
    1. To build the project, use the VS Code command `Azure IoT Operations Akri Connectors: Build an Akri Connector` and choose the `Release` mode. This should show the build progress in the `OUTPUT` console and notify that the build is succeeded. You can then see a new docker image named <connector_name> with tag `release` locally.

1. Test the connector - At this point, we are ready to test the REST connector we implemented. Follow the steps below:
    1. First we need an input endpoint that acts as a REST server that the connector can connect to. Follow the steps [here](sample-rest-server) to build a sample rest server image.
    1. Once the image is built, run the following command to run the rest server as a container:
        ```bash
        docker run -d --rm --network aio_akri_network --name restserver rest-server:latest
        ```
    1. Now the rest server should be up and ready and can be accessible at `http://restserver:3000` for containers running on `aio_akri_network`.
    1. Create a device Custom Resource in the `Devices` folder within your workspace. Refer to [rest-server-device-definition.yaml](rest-server-custom-resources/rest-server-device-definition.yaml)
        > **NOTE:** In the device configuration, the inbound endpoint address reflects the REST server address setup above.
    1. Create an asset Custom Resources in the `Assets` folder within your workspace. Refer to [rest-server-asset1-definition.yaml](rest-server-custom-resources/rest-server-asset1-definition.yaml) and [rest-server-asset2-definition.yaml](rest-server-custom-resources/rest-server-asset2-definition.yaml)
    1. For this REST connector sample, we are using 1 device and 2 asset configurations and they have been placed at appropriate location.
    1. Now, we are ready to test the connector. Go to `Run and Debug` panel on the VS Code workspace and select `Run an Akri Connector` configuration. This should launch a terminal that run pre-launch tasks to bring up the `aio-broker` container and the REST connector we developed as another container named `<connector_name>_release`. This will take 2-3 mins and you should see the telemetry data flow from REST server to MQ broker via the REST connector as logs of the `<connector_name>_release` container.
    1. You can stop the execution anytime using the `Stop` button on the debug panel below. This will cleanup and delete the running containers `aio-broker` and `<connector_name>_release`
    
        ![location](images/debug-panel.png)

## Scenario 2: Debug a .NET Akri Connector

To debug a .NET based Akri connector, make sure you have the `C#` extension installed. We can use the same REST connector we created above.

1. First we need to build our connector in `Debug` mode to install debugger. Use the VS Code command `Azure IoT Operations Akri Connectors: Build an Akri Connector` and select `Debug` mode. This should create a docker image named <connector_name> with tag `debug` locally.
1. Go to `Run and Debug` panel on the VS Code workspace and select `Debug an Akri Connector` configuration. This should launch a terminal that run pre-launch tasks to bring up the `aio-broker` container and the REST connector we developed as another container named `<connector_name>_debug`. This will take 2-3 mins and you should see the telemetry data flow from REST server to MQ broker via the REST connector as logs of the `<connector_name>_debug` container.
1. You can put a breakpoint and the execution should stop when the breakpoint is hit. (try putting one at line 77 on `DatasetSampler.cs`)
1. Use the `Disconnect` button on the debug panel to terminate the execution.

>[!NOTE]: 
The Akri VS Code extension launches the devx image in a Run/Debug scenario and has a timeout period of 3 mins. If the container is still coming up after 3 mins the extension kills it and aborts the execution. This design will be updated based on feedback.

## Scenario 3: Author and Validate Rust Akri Connector
In this scenario, we will create an Akri Connector in Rust language, build a docker image out of the connector and run the connector application using the VS Code extension.

1. On the keyboard, press `ctrl+shift+p` to list the VS Code commands enabled by the Azure IoT Operations Akri Connectors VS Code Extension.
2. Choose `Azure IoT Operations Akri Connectors: Create a New Akri Connector` command, follow the prompts. Make sure to select `Rust` language.
3. Once the command is executed, the extension will create a new workspace named as the <connector_name> chosen with the Rust connector scaffolding as a folder inside named <connector_name>. We can just test with the scaffolding. To see logs from your connector crate, you need to update the tag `sample_connector_scaffolding` to you connector name in the `DEFAULT_LOG_LEVEL` variable (line 62).
4. Now let's add the device CR from [here](rest-server-custom-resources) to `Devices` folder and asset CRs to `Assets` folder.
5. Now let's build the project to confirm there are no errors:
    1. To build the project, use the VS Code command `Azure IoT Operations Akri Connectors: Build an Akri Connector` and choose the `Release` mode. This should show the build progress in the `OUTPUT` console and notify that the build is succeeded. You can then see a new docker image named <connector_name> with tag `release` locally.
6. Now, we are ready to test the connector. Go to `Run and Debug` panel on the VS Code workspace and select `Run an Akri Connector` configuration. This should launch a terminal that run pre-launch tasks to bring up the `aio-broker` container and the Rust connector we developed as another container named `<connector_name>_release`. This will take 2-3 mins and you should see the logs from the Rust connector showing the device and asset status from the `<connector_name>_release` container.
7. You can stop the execution anytime using the `Stop` button on the debug panel below. This will cleanup and delete the running containers `aio-broker` and `<connector_name>_release`

    ![location](images/debug-panel.png)


## Scenario 4: Debug a Rust based Akri Connector

To debug a Rust based Akri connector, make sure you have the `C/C++` extension installed. We can use the same Rust connector we created above in scenario 3.


1. First we need to build our connector in `Debug` mode to install debugger. Use the VS Code command `Azure IoT Operations Akri Connectors: Build an Akri Connector` and select `Debug` mode. This should create a docker image named <connector_name> with tag `debug` locally.
1. Go to `Run and Debug` panel on the VS Code workspace and select `Debug an Akri Connector` configuration. This should launch a terminal that run pre-launch tasks to bring up the `aio-broker` container and the REST connector we developed as another container named `<connector_name>_debug`. This will take 2-3 mins and you should see the logs from the Rust connector application showing the device and asset status in the `<connector_name>_debug` docker container.
1. You can put a breakpoint and the execution should stop when the breakpoint is hit. (try putting one at line 76 of `main.rs`)
1. Use the `Disconnect` button on the debug panel to terminate the execution.

>[!NOTE]: 
The Akri VS Code extension launches the devx image in a Run/Debug scenario and has a timeout period of 3 mins. If the container is still coming up after 3 mins the extension kills it and aborts the execution. This design will be updated based on feedback.

## Scenario 5: Apply Configuration Updates

Once you've created and run an Akri connector and the local environment runtime container has launched, you can leverage the following 4 commands to Apply/Delete Devices and Assets on the cluster and verify connector application picking up these changes.

1. `Azure IoT Operations Akri Connectors: Apply Device YAML on Cluster`
1. `Azure IoT Operations Akri Connectors: Apply Asset YAML on Cluster`
1. `Azure IoT Operations Akri Connectors: Delete Device YAML from Cluster`
1. `Azure IoT Operations Akri Connectors: Delete Asset YAML from Cluster`

>[!NOTE]: 
The config updates that result from the above VS Code commands does not work in Windows for the 2510 release due limitations of CIFS implementation in Linux kernel. Any file change events in mounted folders of host are not propagated to container by Docker for Windows.

1. Check the base logs from your connector application. If you have some Devices/Assets in the workspace folders, the extension will mount these to the connector and you should see logs like below confirming these Device/Asset configs are passed to this connector:

    ![logs](/preview/akri-connectors-extension/images/device_asset_configs_logs.png)

2. Once you have the Device/Asset YAML updated in your workspace, you can use the appropriate VS Code command to apply these changes to the runtime. The connector application should pick this update and respond accordingly. For delete operations, you don't need to delete the YAMl from the workspace. You can use the VS Code command directly and choose a YAML you want to delete from the cluster. This should let the connector stop processing the data from the deleted YAML configuration.


## Scenario 6: Capture Connector State

You can use the `Azure IoT Operations Akri Connectors: Capture Connector State` VS Code command. This should create a new folder in the `Output` folder within the workspace based on timestamp and it should contain the state of Schema Registry, at the time of clicking the command, stored inside. 

It should show any custom schemas created by the connector application based on the current configuration in the `state` folder. 

The state of Schema Registry should also be visible at `Output/ConnectorState` folder since the start of the connector. You should only use the command if you explicitly want to store it for future reference.

## Scenario 7: Publish Connector Image

You can use the `Azure IoT Operations Akri connectors: Publish Akri Connector Image or Metadata` command to publish connector images to an ACR registry. Please make sure you have `az` cli and `oras` installed locally. Also, have the subscriptionID, ACR registry name handy and follow the prompts to publish an Akri Connector Image to your ACR.
## Scenario 8: Author Connector Metadata Configuration - Static Validation

You can use the VS Code workspace created from the `Create an Akri Connector` command to author `connector-metadata.json` file. This can live anywhere within the workspace and the extension provides the static validation capability to the json file named `connector-metadata.json` and shows warnings in the `PROBLEMS` panel if any required properties are missing.
## Scenario 9: Publish Metadata Artifacts

You can use the `Azure IoT Operations Akri connectors: Publish Akri Connector Image or Metadata` command to publish metadata folders to an ACR registry. Please make sure you have `az` cli and `oras` installed locally. Also, have the subscriptionID, ACR registry name handy and follow the prompts to publish Akri Connector Metadata to your ACR. Currently, extension expects files named `connector-metadata.json` and `additionalConfig.json` to be present in any folder you push.