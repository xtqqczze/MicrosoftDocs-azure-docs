---
title: Create a Zone-Redundant Container App
description: Learn how to create a zone-redundant container app in Azure Container Apps to improve availability and ensure regional fault tolerance.
services: container-apps
author: craigshoemaker
ms.author: cshoe
ms.service: azure-container-apps
ms.topic: how-to
ms.date: 10/13/2025
---

# Create a zone-redundant container app

In this article, learn how to create a zone-redundant container app inside a virtual network. You create an Azure Container Apps environment, enable zone redundancy, and configure it with a new or preexisting virtual network that includes an infrastructure subnet.

For more information about how Container Apps supports zone redundancy, see [Reliability in Container Apps](../reliability/reliability-container-apps.md).

## Prerequisites

Zone redundancy is available in all regions that support Container Apps and availability zones.

To see which regions support availability zones, see [Azure regions that have availability zone support](../reliability/regions-list.md).

To see which regions support Container Apps, see [Product availability by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table).

## Create a zone-redundant container app

Use the Azure portal, the Azure CLI, or Azure PowerShell to create a zone-redundant container app.

# [The Azure portal](#tab/portal)

1. Go to [the Azure portal](https://portal.azure.com/).

1. Search for **Container Apps** in the top search box.

1. Select **Container Apps**.

1. Select **Create** and then select **Container App**.

1. In the **Basics** tab, enter the following information:

   - **Subscription:** Select your Azure subscription.

   - **Resource group:** Select an existing resource group or create a new one.

   - **Container app name:** Enter a name for your container app.
   
   - **Optimize for Azure Functions:** Check the box for **Optimize for Azure Functions** if necessary.
   
   - **Deployment source:** Select **Container image**. 

1. In the **Container Apps Environment** section, select the box **Show environments in all regions** if you need to include existing container environments for deployment. In the **Region** field, enter the environment name.

   Zone redundancy requires a virtual network that has an infrastructure subnet. You can choose an existing virtual network or create a new virtual network. When you create a new virtual network, you can accept the values provided for you or customize the settings.

1. Select the **Networking** tab in the environment creation page.

1. Select **Yes** next to *Use your own virtual network*.

1. Next to the *Virtual network* field, select **Create new** to create a custom virtual network, or select an existing one from the dropdown.

1. Next to the *Infrastructure subnet* field, select **Create new** to create a custom infrastructure subnet, or select an existing one from the dropdown.
   
1. Under *Virtual IP*, select **External** for an external environment, or **Internal** for an internal environment.

1. Select **Create** to create the Container Apps environment.

1. Select the **Container** tab to configure your container settings.

1. Select **Review + create** to review your configuration.

1. Review your settings and select **Create** to deploy your zone-redundant container app.

:::image type="content" source="../container-apps/media/screen-shot-vnet-configuration.png" alt-text="Screenshot of the Networking tab on the Create Container Apps environment page.":::

# [Azure CLI](#tab/azure-cli)

1. Create a virtual network and infrastructure subnet to include with the Container Apps environment.

   When you use the following commands, replace the `<PLACEHOLDERS>` with your values.
    
   > [!NOTE]
   > The consumption-only environment requires a dedicated subnet that has a Classless Inter-Domain Routing (CIDR) range of `/23` or larger. The workload profiles environment requires a dedicated subnet that has a CIDR range of `/27` or larger. For more information about subnet sizing, see [Networking architecture overview](../container-apps/custom-virtual-networks.md#subnet).
    
    
    ```azurecli-interactive
    az network vnet create \
      --resource-group <RESOURCE_GROUP_NAME> \
      --name <VNET_NAME> \
      --location <LOCATION> \
      --address-prefix 10.0.0.0/16
    ```
    
    ```azurecli-interactive
    az network vnet subnet create \
      --resource-group <RESOURCE_GROUP_NAME> \
      --vnet-name <VNET_NAME> \
      --name infrastructure \
      --address-prefixes 10.0.0.0/21
    ```

1. Query for the infrastructure subnet ID.

    ```azurecli-interactive
    INFRASTRUCTURE_SUBNET=`az network vnet subnet show --resource-group <RESOURCE_GROUP_NAME> --vnet-name <VNET_NAME> --name infrastructure --query "id" -o tsv | tr -d '[:space:]'`
    ```

1. Create the environment with the `--zone-redundant` parameter. The location must be the same location used when you create the virtual network.

    ```azurecli-interactive
    az containerapp env create \
      --name <CONTAINER_APP_ENV_NAME> \
      --resource-group <RESOURCE_GROUP_NAME> \
      --location "<LOCATION>" \
      --infrastructure-subnet-resource-id $INFRASTRUCTURE_SUBNET \
      --zone-redundant
    ```

# [Azure PowerShell](#tab/azure-powershell)

1. Create a virtual network and infrastructure subnet to include with the Container Apps environment.

   When you use the following commands, replace the `<PLACEHOLDERS>` with your values.
    
   > [!NOTE]
   > The consumption-only environment requires a dedicated subnet that has a CIDR range of `/23` or larger. The workload profiles environment requires a dedicated subnet that has a CIDR range of `/27` or larger. For more information about subnet sizing, see [Networking architecture overview](../container-apps/custom-virtual-networks.md#subnet).
    
    ```azurepowershell-interactive
    $SubnetArgs = @{
        Name = 'infrastructure-subnet'
        AddressPrefix = '10.0.0.0/21'
    }
    $subnet = New-AzVirtualNetworkSubnetConfig @SubnetArgs

    $VnetArgs = @{
        Name = <VNetName>
        Location = <Location>
        ResourceGroupName = <ResourceGroupName>
        AddressPrefix = '10.0.0.0/16'
        Subnet = $subnet 
    }
    $vnet = New-AzVirtualNetwork @VnetArgs
    ```

1. Query for the infrastructure subnet ID.

    ```azurepowershell-interactive
    $InfrastructureSubnet=(Get-AzVirtualNetworkSubnetConfig -Name $SubnetArgs.Name -VirtualNetwork $vnet).Id
    ```

1. Create the environment with the `--zone-redundant` parameter. The location must be the same location used when you create the virtual network.

    A Log Analytics workspace is required for the Container Apps environment. The following commands create a Log Analytics workspace and save the workspace ID and primary shared key to environment variables.
    
    ```azurepowershell-interactive
    $WorkspaceArgs = @{
        Name = 'myworkspace'
        ResourceGroupName = <ResourceGroupName>
        Location = <Location>
        PublicNetworkAccessForIngestion = 'Enabled'
        PublicNetworkAccessForQuery = 'Enabled'
    }
    New-AzOperationalInsightsWorkspace @WorkspaceArgs
    $WorkspaceId = (Get-AzOperationalInsightsWorkspace -ResourceGroupName <ResourceGroupName> -Name $WorkspaceArgs.Name).CustomerId
    $WorkspaceSharedKey = (Get-AzOperationalInsightsWorkspaceSharedKey -ResourceGroupName <ResourceGroupName> -Name $WorkspaceArgs.Name).PrimarySharedKey
    ```

1. Create the environment by running the following command:
    
    ```azurepowershell-interactive
    $EnvArgs = @{
        EnvName = <EnvironmentName>
        ResourceGroupName = <ResourceGroupName>
        Location = <Location>
        AppLogConfigurationDestination = "log-analytics"
        LogAnalyticConfigurationCustomerId = $WorkspaceId
        LogAnalyticConfigurationSharedKey = $WorkspaceSharedKey
        VnetConfigurationInfrastructureSubnetId = $InfrastructureSubnet
        VnetConfigurationInternal = $true
        ZoneRedundant = $true
    }
    New-AzContainerAppManagedEnv @EnvArgs
    ```
---

## Verify zone redundancy

To verify that zone redundancy is enabled for your Container Apps environment, do the following steps:

# [The Azure portal](#tab/portal)

1. Go to the [Azure portal](https://portal.azure.com/).

1. Search for **Container Apps Environments** in the top search box.

1. Select **Container Apps Environments**.

1. Select your environment.

1. Select **JSON View**.

    :::image type="complex" source="./media/how-to-zone-redundancy/portal-json-view.png" alt-text="Screenshot of the Azure portal that shows the environment. The JSON View button is highlighted.":::
      Screenshot of the Azure portal that shows the overview page for a Container Apps environment named myacaenv1. The left navigation menu highlights the Overview section, with other options such as Activity log, Access control (IAM), Tags, and Settings visible. The main panel displays environment details including resource group, status, location, subscription, environment type, virtual network, infrastructure subnet, static IP address, applications, KEDA version, and Dapr version. On the right side of the details panel, a JSON View link appears outlined in red, which indicates where users access the environment's JSON configuration.
    :::image-end:::

1. Check that the response contains `"zoneRedundant": true`.

    :::image type="complex" source="./media/how-to-zone-redundancy/portal-resource-json.png" alt-text="Screenshot of the Azure portal that shows the JSON view of the environment. The zoneRedundant property is highlighted.":::
      Screenshot of the Azure portal that shows the Resource JSON view for a Container Apps environment named myacaenv1. The top of the page displays the title Resource JSON and the environment name. The Resource ID field appears below the title and contains a partial subscription path. The main section presents a formatted JSON object with properties such as id, name, type, location, systemData, and properties. The properties section includes provisioningState, vnetConfiguration, defaultDomain, appLogsConfiguration, and other configuration details. The zoneRedundant property appears in the JSON, set to true and highlighted with a red rectangle.
    :::image-end:::

# [The Azure CLI](#tab/azure-cli)

1. Run the [`az containerapp env show`](/cli/azure/containerapp/env#az-containerapp-env-show) command.

    When you use this command, replace the `<PLACEHOLDERS>` with your values.

    ```azurecli
    az containerapp env show \
      --name <CONTAINER_APP_ENV_NAME> \
      --resource-group <RESOURCE_GROUP_NAME> \
      --subscription <SUBSCRIPTION_ID>
    ```

1. The command returns a JSON response. Check that the response contains `"zoneRedundant": true`.

# [Azure PowerShell](#tab/azure-powershell)

1. Run the [`az containerapp env show`](/cli/azure/containerapp/env#az-containerapp-env-show) command.

    When you use this command, replace the `<PLACEHOLDERS>` with your values.

    ```azurepowershell-interactive
    $Env = Get-AzContainerAppManagedEnv `
        -Name <EnvironmentName> `
        -ResourceGroupName <ResourceGroupName>
    
    $Env.ZoneRedundant
    ```

1. The command displays `True` if the environment is zone redundant, and `False` if it isn't.

---
