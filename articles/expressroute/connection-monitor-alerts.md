---
title: 'Configure alerts for Connection Monitor'
description: Learn how to set up and customize Azure Monitor alerts for Connection Monitor to get notified about connectivity issues, performance degradation, and monitoring gaps in your network.
services: network-watcher
author: dpremchandani
ms.service: azure-expressroute
ms.topic: how-to
ms.date: 11/04/2025
ms.author: divyapr
---

# Configure alerts for Connection Monitor

When your network has connectivity issues, you need to know immediately—not hours later when users start complaining. Connection Monitor in Azure Network Watcher continuously tests your network paths and can alert you the moment something goes wrong.

This article shows you how to configure and customize alerts for Connection Monitor so you're notified about connectivity failures, performance degradation, and monitoring gaps before they impact your business.

## How Connection Monitor alerts work

Connection Monitor runs continuous tests between your endpoints and measures:
- **Test results** - Whether connectivity succeeds or fails
- **Round-trip time (RTT)** - How long packets take to travel between endpoints
- **Checks failed percentage** - The packet loss rate

Azure Monitor alerts automatically notify you when these metrics exceed your thresholds. For ExpressRoute connections, a default alert is created automatically when you enable Connection Monitor.

## Default alert for ExpressRoute connections

When you configure Connection Monitor for an ExpressRoute connection, Azure automatically creates an alert with these settings:

| Setting | Default value | What it means |
|---------|--------------|---------------|
| Signal | Test result | Monitors whether tests pass or fail |
| Aggregation | Maximum | Alert fires if ANY test fails |
| Threshold | Greater than 2 | Triggers on Warning (2) or Fail (3) status |
| Evaluation frequency | Every 1 minute | Checks for issues every minute |
| Lookback period | 5 minutes | Reviews the last 5 minutes of data |

### Understanding test result values

Connection Monitor assigns each test a numeric value based on your configured thresholds:

- **1 (Pass)** - Connectivity successful, performance within thresholds
- **2 (Warning)** - Connectivity works but performance is degraded
- **3 (Fail)** - Connectivity failed or performance severely degraded

For more information about test states, see [Connection Monitor overview](connection-monitor-overview.md#states-of-a-test).

> [!NOTE]
> The default alert is sensitive—it fires if even one test fails. This helps you catch issues quickly but might generate more alerts than you need. You can adjust the settings to match your environment.

## Customize the default alert

You can modify the default alert to make it more or less sensitive, or to focus on specific endpoints.

### Edit alert conditions

1. Go to your ExpressRoute connection in the Azure portal.

1. Select **Monitoring** > **Connection Monitor**.

1. In the **Alerts** column, select the alert value.

1. Select **Edit condition** to modify the alert rule.

### Common customizations

**Alert only when many tests are failing:**
- Change **Aggregation type** to **Average**
- Increase the **Threshold** (for example, to 2.5 for alerting when most tests fail)

**Alert for a specific destination:**
1. Select **Add dimension**.
1. Choose **Destination endpoint name**.
1. Select the specific endpoint you want to monitor.

**Alert for specific source-destination pairs:**
1. Select **Add dimension**.
1. Add both **Source endpoint name** and **Destination endpoint name**.
1. Select the specific endpoints you want to monitor.

> [!IMPORTANT]
> Each dimension combination creates a separate time series, which can increase your Azure Monitor costs. Add dimensions only when you need to isolate specific endpoints.

## Create alerts for performance metrics

Beyond the default connectivity alert, you can create alerts for performance issues.

### Alert when latency is too high

High round-trip time (RTT) can indicate network congestion or routing issues.

1. On the Connection Monitor dashboard, select **Alerts** > **Create alert rule**.

1. Configure the alert:
   - **Signal name**: Round Trip Time (ms)
   - **Aggregation type**: Average
   - **Operator**: Greater than
   - **Threshold**: Your acceptable latency (for example, 100 ms)
   
   > [!TIP]
   > Start with your baseline latency plus 50%. If your typical RTT is 40ms, set the threshold to 60ms.

1. (Optional) Add dimensions to alert on specific endpoints.

1. Configure your action group to define how you want to be notified.

1. Select **Review + create** and then **Create**.

### Alert when packet loss is too high

Packet loss causes application performance issues and connection drops.

1. On the Connection Monitor dashboard, select **Alerts** > **Create alert rule**.

1. Configure the alert:
   - **Signal name**: Checks Failed Percent
   - **Aggregation type**: Average
   - **Operator**: Greater than
   - **Threshold**: Your acceptable packet loss (for example, 5%)
   
   > [!TIP]
   > Most applications tolerate 1-2% packet loss. Set your threshold based on your application requirements and SLA.

1. (Optional) Add dimensions to alert on specific endpoints.

1. Configure your action group to define how you want to be notified.

1. Select **Review + create** and then **Create**.

## Alert when monitoring stops

Metric-based alerts don't fire if Connection Monitor stops sending data. This can happen when:
- Source VMs are shut down
- Network Watcher extension isn't installed or running
- Monitoring agents fail

To detect these gaps, create a log-based alert.

### Create a log alert for missing data

1. In the Azure portal, go to **Monitor** > **Alerts**.

1. Select **Create** > **Alert rule**.

1. Select your Connection Monitor as the scope.

1. On the **Condition** tab, select **Custom log search**.

1. Enter this query, replacing the placeholders with your values:

   ```kusto
   NWConnectionMonitorTestResult
   | where ConnectionMonitorResourceId =~ "/subscriptions/<subscription-id>/resourcegroups/<resource-group>/providers/microsoft.network/networkwatchers/<network-watcher-name>/connectionmonitors/<connection-monitor-name>"
   ```

   > [!TIP]
   > Copy the `ConnectionMonitorResourceId` value directly from your Connection Monitor dashboard to avoid typing errors.

1. Configure the alert logic:
   - **Measurement**: Table rows
   - **Aggregation type**: Count
   - **Operator**: Less than
   - **Threshold**: 1
   - **Evaluation frequency**: 5 minutes
   - **Lookback period**: 10 minutes

1. Configure your action group to define how you want to be notified.

1. Select **Review + create** and then **Create**.

This alert fires if no test results are recorded in the last 10 minutes, indicating a monitoring gap.

## Best practices for Connection Monitor alerts

### Start simple, then refine

1. **Use the default alert initially** - Let it run for a week to understand your baseline
1. **Review alert history** - Identify false positives and true issues
1. **Adjust thresholds** - Increase if you get too many alerts, decrease if you're missing issues
1. **Add dimensions carefully** - Only when you need to isolate specific endpoints

### Set up multiple notification channels

Configure action groups with different notification methods:
- **Critical issues**: SMS and phone calls
- **Warnings**: Email and Teams messages
- **Informational**: Email only

### Create a maintenance window

Suppress alerts during planned maintenance to avoid alert fatigue:
1. Go to **Monitor** > **Alerts** > **Alert processing rules**
1. Create a rule that suppresses alerts during your maintenance window

### Test your alerts

After creating an alert:
1. Go to the alert rule
1. Select **Test action group**
1. Verify you receive the notification
1. Check that the notification contains enough information to take action

## Troubleshooting alerts

### I'm not receiving alerts

**Check these common issues:**
- Verify the alert rule is **Enabled**
- Confirm the action group has the correct contact information
- Check your email spam folder for alert notifications
- Verify thresholds aren't set too high

### I'm getting too many alerts

**Reduce alert noise:**
- Increase thresholds to focus on significant issues
- Change aggregation from Maximum to Average
- Add dimensions to exclude known flapping endpoints
- Increase the lookback period to avoid alerting on transient issues

### Alert says "test failed" but connection works

**Possible causes:**
- Thresholds are too strict for your network conditions
- Transient network congestion triggered the alert
- Background tasks on VMs caused temporary performance issues

**What to do:**
1. Check the **Reason** column in Connection Monitor dashboard
1. Review historical trends to see if this is recurring
1. Consider adjusting thresholds if alerts don't reflect real issues

## FAQ

**How many alerts can I create for a Connection Monitor?**

There's no hard limit, but we recommend keeping alerts focused. Start with 2-3 alerts (connectivity, RTT, and missing data) and add more only if needed.

**Do alerts cost extra?**

Azure Monitor alerts have costs based on the number of alert rules and evaluations. For details, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

**Can I alert on multiple Connection Monitors with one rule?**

Yes. When creating an alert rule, select multiple Connection Monitors as the scope. This is useful for alerting on all your ExpressRoute connections at once.

**How quickly do alerts fire after an issue occurs?**

The default evaluation frequency is 1 minute with a 5-minute lookback. In most cases, you'll receive an alert within 2-3 minutes of an issue occurring.

**Can I send alerts to a ticketing system?**

Yes. Configure an action group with a webhook that sends to your ITSM tool (ServiceNow, Jira, etc.). For details, see [ITSM Connector](../azure-monitor/alerts/itsmc-overview.md).

## Next steps

- [Monitor Azure ExpressRoute](../expressroute/monitor-expressroute.md)
- [Connection Monitor overview](connection-monitor-overview.md)
- [Create an action group](../azure-monitor/alerts/action-groups.md)
