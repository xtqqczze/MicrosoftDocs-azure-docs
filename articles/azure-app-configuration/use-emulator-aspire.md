### Use local Azure App Configuration emulator

Azure App Configuration provides an official local [emulator](./emulator-overview.md) which is a containerized version of the App Configuration service for local development and testing. You can use the emulator as the App Configuration resource in the Aspire solution by chaining a call `RunAsEmulator` on `builder.AddAzureAppConfiguration("appconfiguration")`.

```c#
var appConfiguration = builder.AddAzureAppConfiguration("appconfiguration")
    .RunAsEmulator();
```

 When you call `RunAsEmulator`, the Aspire will pull the [App Configuration emulator image](https://mcr.microsoft.com/artifact/mar/azure-app-configuration/app-configuration-emulator/about) and runs a container as the App Configuration resource. 

> [!IMPORTANT]
> Aspire runs containers using several OCI-compatible runtimes. Make sure you installed an OCI compliant container runtime, such as [Docker Desktop](https://www.docker.com/products/docker-desktop/).

> [!TIPS]
> You can call `WithDataBindMount` or `WithDataVolume` to configure the emulator resource for persistent container storage.
> ```c#
> var appConfiguration = builder.AddAzureAppConfiguration("appConfiguration")
>     .RunAsEmulator(emulator => {
>         emulator.WithDataBindMount("./aace");
>     });
> ```