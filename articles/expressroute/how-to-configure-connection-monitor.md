---
title: 'Configure Connection Monitor for Azure ExpressRoute'
description: Configure cloud-based network connectivity monitoring for Azure ExpressRoute circuits. This covers monitoring over ExpressRoute private peering and Microsoft peering.
services: expressroute
author: dpremchandani
ms.service: azure-expressroute
ms.topic: how-to
ms.date: 01/31/2025
ms.author: divyapr
ms.custom: sfi-image-nochange
# Customer intent: "As a network engineer, I want to configure Connection Monitor for Azure ExpressRoute, so that I can monitor connectivity and performance between Azure and on-premises locations to quickly identify and resolve potential network issues."
---

# Configure Connection Monitor for Azure ExpressRoute

When you're investigating ExpressRoute connectivity issues, you're left guessing where the problem is: your network, Azure's infrastructure, or somewhere in between.

Connection Monitor changes this by providing true end-to-end visibility. Unlike OOB resource metrics and health that only focus on the individual component, or open-source tools that can detect failures but can't pinpoint where problems occur, Connection Monitor tests your entire ExpressRoute path—from your on-premises servers through the ExpressRoute circuit to your Azure workloads to not just detect but also localize and mitigate issues.

With Connection Monitor, you can:

- **Detect any connectivity or performance degradation** with continuous connectivity tests between your on-premises and Azure workloads
- **Pinpoint the exact problem location** with hop-by-hop network path visualization
- **Prove whether it's your issue or Azure's** by localizing failures within the Azure network or your infrastructure
- **Track performance over time** with historical latency and packet loss data
- **Get instant alerts** when thresholds are breached (learn more about [configuring alerts](connection-monitor-alerts.md))

This article shows you how to set up Connection Monitor so you have complete visibility into your ExpressRoute connection health.

> [!NOTE]
> If you don't see the Connection Monitor option when creating or editing an ExpressRoute connection, you may need to enable the feature flag. Access the Azure portal with this URL: `https://ms.portal.azure.com/?feature.experimentation=false&exp.AzurePortal_ExRCMIntegration=true#home`

## Prerequisites

Before you begin, ensure you have the following:

### What you need

* **An active ExpressRoute connection** between your on-premises network and Azure
* **Azure Monitor agent for on-premises endpoints**: Install the [Azure Monitor agent](../network-watcher/azure-monitor-agent-with-connection-monitor.md) on any on-premises server that you intend to use as a source endpoint for connectivity testing.
* **A TCP listener running** on your on-premises servers (on the port you'll configure)

### Permissions

Most users need **Network Contributor** role. If you don't have it, ask your Azure administrator.

<details>
<summary>Detailed permission requirements (expand if you need specifics)</summary>

Your exact permissions depend on your scenario:

**Creating a new connection with monitoring:**
* `Microsoft.Network/virtualNetworks/write`
* `Microsoft.Resources/deployments/*`
* `Microsoft.OperationalInsights/workspaces/*`

**If Network Watcher isn't enabled in your region:**
* Contributor role OR `Microsoft.Resources/subscriptions/resourceGroups/write`

**If monitoring Azure Arc servers:**
* `Microsoft.HybridCompute/machines/write`
* `Microsoft.Authorization/*/Read`

</details>

## Understand test configuration and limitations

Connection Monitor automatically creates tests based on your selected endpoints. Understanding how tests are created helps you plan your monitoring strategy effectively.

### How tests are created

The type of test Connection Monitor creates depends on your endpoint configuration:

| On-premises endpoint type | Azure endpoint | Test direction |
|---------------------------|----------------|---------------|
| Azure Arc-enabled server | Azure VM or Virtual Machine Scale Set | Bi-directional: Azure to Arc server and Arc server to Azure |
| External address (IP address without Azure Arc) | Azure VM or Virtual Machine Scale Set | Uni-directional: Azure to external address only |

### Regional considerations

Only endpoints in the same Azure region as your ExpressRoute connection can serve as source endpoints. This limitation affects the number and direction of tests that Connection Monitor creates.

**Key points:**

- Endpoints in any region can be destination endpoints.
- Only endpoints in the ExpressRoute connection region can be source endpoints.

**Example:**

Your ExpressRoute connection is in **East US** and you select the following endpoints:

- **On-premises endpoints:**
    - Arc-enabled server 1 in East US
    - Arc-enabled server 2 in West US

- **Azure endpoints:**
    - Virtual network 1 in East US
    - Virtual network 2 in West US

Connection Monitor creates these tests:

| Test direction | Source | Destination | Reason |
|----------------|--------|-------------|--------|
| Azure to on-premises | Virtual network 1 (East US) | Arc-enabled server 1 | Virtual network 1 is in the ExpressRoute connection region |
| Azure to on-premises | Virtual network 1 (East US) | Arc-enabled server 2 | Virtual network 1 is in the ExpressRoute connection region |
| On-premises to Azure | Arc-enabled server 1 (East US) | Virtual network 1 | Arc-enabled server 1 is in the ExpressRoute connection region |
| On-premises to Azure | Arc-enabled server 1 (East US) | Virtual network 2 | Arc-enabled server 1 is in the ExpressRoute connection region |

Connection Monitor doesn't create these tests:

- Arc-enabled server 2 to Azure endpoints because Arc-enabled server 2 is in West US, not the ExpressRoute connection region
- Virtual network 2 to Arc-enabled servers because virtual network 2 is in West US, not the ExpressRoute connection region

### Azure endpoint configuration

When you configure Azure endpoints:

- **Automatic selection**: Connection Monitor automatically selects endpoints in the same region as your ExpressRoute connection.
- **Manual selection**: You can manually select endpoints in other regions as destination endpoints.
- **Virtual network visibility**: Only virtual networks that contain at least one virtual machine or Virtual Machine Scale Set appear in the endpoint list.
- **Virtual machine sampling**: Connection Monitor selects up to three virtual machines per virtual network and automatically installs the Network Watcher extension on them.
- **Endpoint limit**: You can select up to 30 Azure virtual networks as endpoints.

## Configure Connection Monitor

You can configure Connection Monitor when creating a new ExpressRoute connection or add it to an existing connection.

### Create a new ExpressRoute connection with monitoring

Follow these steps to enable Connection Monitor while creating a new ExpressRoute connection:

1. Create the ExpressRoute connection by following the steps in [Link a virtual network to ExpressRoute circuits](../expressroute/expressroute-howto-linkvnet-portal-resource-manager.md).

1. On the **Monitoring** tab during connection setup:
    * The **Enable Connection Monitor** checkbox is selected by default. Clear it if you don't want to enable monitoring.
    * Select your **on-premises and Azure endpoints**. Both endpoints are required to define the test path.
        * **On-premises endpoint**: Select the on-premises endpoint for your connectivity tests. You can choose one or both options:
            * **Azure Arc-enabled endpoint**: Select a server that has the Azure Monitor agent installed. This option supports bi-directional tests (the endpoint can act as both source and destination).
            * **External URL or IP address**: Enter an external address that is reachable through your ExpressRoute connection. This option only supports uni-directional tests where the external address serves as the destination endpoint.
              
              > [!NOTE]
              > If you don't have Arc-enabled servers yet, you can start with external addresses and upgrade to Arc later for bi-directional testing.

            > [!NOTE]
            > See [Understand test configuration](#understand-test-configuration-and-limitations) for details on how your endpoint selection affects test creation.
           
        * **Azure endpoint**: Select your Azure Virtual Machine (VM) or Virtual Machine Scale Set (VMSS) from the list of available Azure Virtual Networks. If you don't explicitly select a VM, Connection Monitor randomly samples a VM within the selected virtual network. Bi-directional tests are supported when the Azure endpoint is in the same region as the on-premises endpoint. Otherwise, only uni-directional tests are available.

            > [!TIP]
            > Endpoints in the same region as your ExpressRoute connection are auto-selected because they provide the most comprehensive test coverage.

    * Configure the **test settings**:
        * **Protocol**: The network protocol used for testing. Connection Monitor supports TCP to simulate application traffic on a specific port.
        * **Disable traceroute**: Select this checkbox to stop sources from discovering topology and hop-by-hop RTT.
        * **Destination port**: Enter the port your application uses.
          
          > [!TIP]
          > Common choices: Port 443 (HTTPS), 1433 (SQL Server), or 3389 (RDP). Pick a port that matches your critical workload.

        * **Listen on port**: This checkbox applies when the protocol is TCP. Select this checkbox to open the chosen TCP port if it isn't already open.
        * **Test Frequency**: How often Connection Monitor checks your connection.
            * **30 seconds**: Best for mission-critical apps where you need immediate detection (uses more resources)
            * **5 minutes**: Good balance for most production environments
            * **30 minutes**: Adequate for non-critical monitoring
            * Select **Custom** to enter another frequency from 30 seconds to 30 minutes
        * **Success Threshold**: Set thresholds to get alerted when performance degrades:
            * **Checks failed**: The percentage of acceptable packet loss. Start with 10% and adjust based on your SLA requirements.
            * **Round-trip time**: The maximum acceptable latency in milliseconds. Start with your baseline plus 20% (for example, if your typical RTT is 50ms, set this to 60ms).

    :::image type="content" source="./media/how-to-configure-connection-monitor/connection-monitor.png" alt-text="Screenshot showing the Monitoring tab configuration page for Connection Monitor settings." lightbox="./media/how-to-configure-connection-monitor/connection-monitor.png":::

1. Select **Review + create** and then select **Create** to deploy the connection. The monitor is created only if the ExpressRoute connection deploys successfully.

## Verify your monitoring is working

After you configure Connection Monitor, confirm everything is running correctly:

1. **Wait 5 minutes** for the first test results to appear.

1. Go to your ExpressRoute connection and select **Monitoring** > **Connection Monitor**.

1. **You should see:**
   * ✅ Green "Pass" status for each endpoint
   * ✅ Latency graphs showing data points
   * ✅ Path view displaying network hops from on-premises to Azure

1. **If you see "Indeterminate" status:**
   * Wait up to 10 minutes—the first test run can take time
   * Check that Azure Monitor agent is running on your on-premises servers
   * Verify the TCP listener is started on the configured port

1. **If you see "Fail" status:**
   * Select the endpoint to view the **Reason** column for specific error details
   * Common issues:
     * Firewall blocking the test port
     * TCP listener not running on Arc endpoints
     * Network Watcher extension still installing on Azure VMs

1. **Test your alerts** (optional but recommended):
   * Go to **Monitoring** > **Alerts** on your ExpressRoute connection
   * Select the Connection Monitor alert rule
   * Select **Test action group** to trigger a test notification

> [!TIP]
> Bookmark the Connection Monitor dashboard for quick access. You'll use this frequently to check connection health.

**Next steps:** Learn how to [update configured alert thresholds](connection-monitor-alerts.md) to match your SLA requirements.

### Add monitoring to an existing ExpressRoute connection

Follow these steps to add monitoring to an existing ExpressRoute connection:

1. In the Azure portal, go to **ExpressRoute Circuit**, then select **Connections** and select the connection you want to monitor.

1. Check the **Monitoring status** column in the connections list:
    * If a monitor exists, select **View Tests** to edit the configuration.
    * If no monitor exists, select **Add monitor**.

    Alternatively, open the connection resource and select **Connection Monitor** under **Monitoring** in the left menu.

1. Configure endpoints and test settings by following the same steps as described in [Create a new ExpressRoute connection with monitoring](#create-a-new-expressroute-connection-with-monitoring).

1. Select **Review + create** and then select **Create** to deploy the monitor. After the monitor is created, you can view performance and connectivity data.

## Troubleshoot deployment issues

### The connection deploys but monitoring doesn't appear

**Why this happens:** Network Watcher might not be enabled in your region, or you might lack permissions to create monitoring resources.

**What to do:**
1. In the Azure portal, search for **Network Watcher**.
1. Check if your region appears in the list of enabled regions.
1. If your region isn't listed, ask your Azure administrator to enable Network Watcher or grant you Contributor permissions.

### I get a permissions error during setup

**Why this happens:** You need additional permissions to create Log Analytics workspaces or manage Network Watcher resources.

**What to do:**
1. Note the exact error message from the deployment failure.
1. Share the error message with your Azure administrator.
1. Ask them to grant you Network Contributor role or create the Log Analytics workspace for you.

### Tests show "Indeterminate" status

**Why this happens:** The monitoring agents haven't collected data yet, or there's a connectivity issue preventing test execution.

**What to do:**
1. Wait 10 minutes for the first test run to complete.
1. If status remains "Indeterminate," check that:
   * The Azure Monitor agent is installed and running on your on-premises servers
   * The TCP listener is started on the configured port
   * Network Watcher extension is installed on Azure VMs

### Tests show "Fail" immediately after setup

**Why this happens:** Firewall rules might be blocking the test traffic, or the destination port isn't accessible.

**What to do:**
1. Check the **Reason** column in the Connection Monitor dashboard for specific error details.
1. Common fixes:
   * Open the destination port in your firewall rules
   * Verify the TCP listener is running on Arc-enabled endpoints
   * Check that your ExpressRoute circuit has active BGP sessions
   * Confirm your routing allows traffic between the selected endpoints

## Monitor connection status and alerts

After Connection Monitor is configured, you can track connectivity status and receive alerts when issues occur.

### View connection status

1. In the Azure portal, go to your **ExpressRoute connection**.

1. In the left menu, select **Monitoring**, then select **Connection Monitor**.

1. The dashboard shows the aggregated status for each endpoint based on test results from the past hour:
    * **Pass**: All tests succeeded
    * **Fail**: All tests failed
    * **Warning**: Some tests failed (e.g., "2/6" means 2 out of 6 tests failed)
    * **Indeterminate**: No test data found in Log Analytics
    
1. Select an endpoint to view:
    * Individual test results
    * The **Reason** column for failure causes
    * Latency trends and packet loss metrics
    * Network path visualization

### Configure and manage alerts

Connection Monitor automatically creates Azure Monitor alerts when connectivity issues are detected. You can view, edit, and create custom alerts based on your monitoring needs.

**To view or edit alert rules:**

1. On the Connection Monitor dashboard, select the value in the **Alerts** column.

1. The alert rule definition opens where you can:
    * Modify alert thresholds
    * Change notification settings
    * Add action groups
    * Configure alert severity

For detailed information about default alerts, customizing alert conditions, creating alerts for performance metrics (RTT and packet loss), and detecting monitoring gaps, see [Configure alerts for Connection Monitor](connection-monitor-alerts.md).

## FAQ

### Endpoint configuration

**What's the difference between Azure Arc endpoints and external addresses?**

When configuring on-premises endpoints, you have two options:

- **Azure Arc endpoints**: If you have Azure Arc-enabled servers, they automatically appear in the endpoint list. When you select these servers, Connection Monitor creates bi-directional tests—from each Azure endpoint to each Arc server AND from each Arc server to each Azure endpoint.

- **External addresses**: If you don't have Azure Arc-enabled servers, you can manually enter on-premises IP addresses. When you specify external addresses, Connection Monitor creates uni-directional tests only—from each Azure endpoint to each external address. No reverse-direction tests are created.

**What does "Your source endpoints must be in the same region as your ExpressRoute connection region" mean?**

You can select endpoints from any region, but only endpoints in the same region as your ExpressRoute connection can act as source endpoints. This limitation affects how many tests are created:

- Endpoints in any region can serve as destinations in tests
- Only endpoints in the ExpressRoute connection region can initiate tests as sources
- Each endpoint can be used as a source in one test and as a destination in another test to provide monitoring in both directions

This regional requirement limits the total number of possible tests based on your endpoint selections.

**Why don't I see some of my virtual networks in the Azure endpoints list?**

Only virtual networks that contain at least one VM or Virtual Machine Scale Set appear in the endpoint list. If your virtual network only has other resources (like App Service, Azure Kubernetes Service, or databases), it won't be listed.

**Why are some endpoints automatically selected?**

Endpoints in the same region as your ExpressRoute connection are automatically selected. You can manually select or deselect other endpoints from different regions as needed.

**Do tests run on all VMs in a virtual network?**

No. Connection Monitor selects up to 3 VMs per virtual network. The Network Watcher Extension is automatically enabled on these VMs when you create the connection or update an existing connection with Connection Monitor enabled. You can't manually choose which specific VMs are used.

**Can I select more than 30 virtual networks as Azure endpoints?**

No, 30 virtual networks is the current limit per Connection Monitor. If you need to monitor more endpoints, contact Azure support to discuss your requirements.

### Monitoring and alerts

**How am I notified when an issue occurs?**

Azure Monitor automatically raises alerts when Connection Monitor detects connectivity issues. For more information, see [Connection Monitor alerts](connection-monitor-alerts.md).

**Can I edit the automatically configured alerts?**

Yes. On the Connection Monitor dashboard, select the value in the **Alerts** column. This opens the alert rule definition where you can edit thresholds, notification settings, action groups, and alert severity. For step-by-step guidance, see [Configure alerts for Connection Monitor](connection-monitor-alerts.md).

**What should I do when Connection Monitor alerts are triggered?**

Go to your ExpressRoute connection resource and select **Monitoring** > **Connection Monitor** from the left menu. The dashboard shows the connectivity test status for each endpoint, helping you identify which tests are failing and why.

**What does the status on the Connection Monitor dashboard mean?**

A Connection Monitor includes one or more tests. The dashboard shows an aggregated status based on test results from the past hour:

- **Pass**: All tests passed
- **Fail**: All tests failed
- **Indeterminate**: No test data found in Log Analytics
- **Warning**: Some tests failed. The status column displays the number of failed tests (for example, "1/4" means 1 out of 4 tests failed). The **Reason** column provides the cause of failure.

Select an endpoint to view individual test results, latency trends, packet loss metrics, and network path visualization.

## Pricing

Connection Monitor tests created for ExpressRoute connections through the Azure portal are **free of charge**. This benefit applies when you:

- Enable Connection Monitor while creating a new ExpressRoute connection in the portal
- Add Connection Monitor to an existing ExpressRoute connection through the portal

**What's included:**
- All tests automatically created between your selected endpoints
- No limit on the number of tests
- No monthly charges for these ExpressRoute monitoring tests

**What's not included in this benefit:**
- Connection Monitor tests created through other methods (PowerShell, CLI, ARM templates, or REST API)
- Existing Connection Monitor setups created before this portal integration
- Connection Monitor tests for non-ExpressRoute scenarios
- Azure Alerts and Log analytics workspace storage costs

For these scenarios, standard [Azure Network Watcher Connection Monitor pricing](https://azure.microsoft.com/pricing/details/network-watcher/) applies:
- 0-10 tests: Free
- 10-240,010 tests: $0.30/test/month
- 240,010-750,010 tests: $0.10/test/month
- 750,010-1,000,010 tests: $0.06/test/month
- 1,000,010+ tests: $0.03/test/month

> [!TIP]
> To take advantage of free monitoring, always configure Connection Monitor through the Azure portal when working with ExpressRoute connections.

## Next steps

- [Configure alerts for Connection Monitor](connection-monitor-alerts.md)
- [Monitor Azure ExpressRoute](monitor-expressroute.md)
