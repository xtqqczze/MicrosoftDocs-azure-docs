---
title: Create an IoT hub with Certificate Management in Azure Device Registry using a script
description: This article explains how to create an IoT hub with Azure Device Registry and Certificate Management integration using a script.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
ms.topic: include
ms.date: 11/05/2021
---

## Create an IoT hub with ADR integration using a script

You can use the provided PowerShell script to automate the setup of your IoT hub with Azure Device Registry integration. The script performs all the necessary steps to create the required resources and link them together.

## Prerequisites

- Have an active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- A resource group to hold your resources. You can create a new resource group or use an existing one. If you want to create a new resource group, use the [az group create](/cli/azure/group#az-group-create) command:

   ```azurecli
   az group create --name <RESOURCE_GROUP_NAME> --location "<REGION>"
   ```
- A Device Provisioning Service (DPS) instance. If you don't have a DPS instance, use the [az iot dps create](/cli/azure/iot/dps#az-iot-dps-create) command to create one:

   ```azurecli
   az iot dps create --name <DPS_NAME> --resource-group <RESOURCE_GROUP_NAME> --location "<REGION>"
   ```

## Prepare Your Environment

1. Navigate to the [GitHub repository](https://github.com/Azure/hubgen2-certmgmt/tree/main/Scripts) and download the entire folder, Scripts, which contains the script file (.ps1) and the role template (.json).
1. Place the script, role template, and the .whl files in your working folder and confirm they are accessible. Your working folder is the directory that holds all of your files.

## Customize the script variables

Set values for the following variables in the variables section

- `TenantId`: Your tenant ID. You can find this value by running `az account show` in your terminal.
- `SubscriptionId`: Your subscription ID. You can find this value by running `az account show` in your terminal.
- `ResourceGroup`: The name of your resource group.
- `Location`: The Azure region where you want to create your resources. Check out the available locations in the [Supported regions](iot-hub-device-registry-overview.md#supported-regions) section.
- `NamespaceName`: Your namespace name may only contain lowercase letters and hyphens ('-') in the middle of the name, but not at the beginning or end. For example, "msft-namespace" is a valid name.
- `HubName`: Your hub name can only contain lowercase letters and numerals.
- `DpsName`: The name of your Device Provisioning Service.
- `UserIdentity`: The user-assigned managed identity for your resources.
- `WorkingFolder`: The local folder where your scripts and templates are located.

[!INCLUDE [iot-hub-pii-note-naming-hub](iot-hub-pii-note-naming-hub.md)]

## Run the script interactively

1. Run the script in **PowerShell 7+** by navigating to the folder and running `.\cmsSetupCli.ps1`.
1. If you run into an execution policy issue, try running `powershell -ExecutionPolicy Bypass -File .\cmsSetupCli.ps1`.
1. Follow the guided prompts:

    - Press `Enter` to proceed with a step
    - Press `s` or `S` to skip a step
    - Press `Ctrl` + `C` to abort

> [!NOTE]
> The creation of your ADR Namespace, IoT Hub, DPS, and other resources may take up to 5 minutes each.

## Monitor execution and validate the resources

1. The script continues execution when warnings are encountered and only stops if a command returns a non-zero exit code. Monitor the console for red **ERROR** messages, which indicate issues that require attention.
1. Once the script completes, validate the creation of your resources:

    - IoT Hub
    - DPS
    - ADR Namespace
    - User-Assigned Managed Identity (UAMI)
    - ADR Role Assignments
