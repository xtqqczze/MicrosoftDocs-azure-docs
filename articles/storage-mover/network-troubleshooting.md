---
title: Troubleshooting network issues with the Azure Storage Mover Agent
description: Learn how to troubleshoot network issues with the Azure Storage Mover Agent.
author: stevenmatthew
ms.author: shaas
ms.service: azure-storage-mover
ms.topic: how-to
ms.date: 10/22/2025
ms.custom: template-how-to
---

# Troubleshooting network issues with the Azure Storage Mover Agent

The Azure Storage Mover Agent is an important part of the Azure Storage Mover service, a powerful tool for seamlessly migrating data to Azure. The agent's functionality depends heavily on reliable network connectivity. When network issues arise, The Azure Storage Mover Agent provides a robust set of tools for diagnosing and resolving network issues. 

By following a structured approach, starting with configuration checks, progressing through connectivity tests, and applying endpoint diagnostics, administrators can ensure reliable operation and successful data migrations. For persistent or complex issues, the support bundle offers a path to deeper analysis and assistance from Microsoft Support. 

These native diagnostic tools can be used with standard network troubleshooting tools and techniques.

This article outlines available methods for troubleshooting agent network issues. Troubleshooting steps might include configuration checks, connectivity tests, endpoint diagnostics, and the use of support tools.

## Network configuration overview

The recommended first step in diagnosing network issues is to inspect the agent's network configuration. This inspection can be done via the **Show network configuration** tool located in **Network Configuration** group of the agent's menu. 

The **Show Network Configuration** tool displays critical information such as:

- DHCP status
- IP address and subnet mask
- MAC address
- Link and operational state
- Speed and MTU
- DNS servers and routing table
- Default gateway and proxy settings
- NTP server configuration

The following example provides sample output from the tool:

```Output
Network Interface(s):
eth0:
  DHCP (Dynamic Host Configuration Protocol) status: true
  IP Address and mask: 192.168.1.10/24
  MAC Address (The unique hardware identifier for your network interface): 00:1A:2B:3C:4D:5E
  Link (The connection status of your network interface): up
  Operstate (The operational state of your network interface): up
  Speed (The data transfer rate of your network interface): 10Gbps
  MTU (Maximum Transmission Unit - the largest size of a network packet that can be transmitted): 1500
  DNS (Domain Name System - the service that translates domain names to IP addresses): 192.168.1.1
  Routes (The rules that determine the paths network traffic will take from your device to reach their destination):
    default via 192.168.1.1 proto dhcp src 192.168.1.10 metric 100
    192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.10 metric 100
    169.254.0.0/24 proto dhcp scope link src 192.168.1.10 metric 100
Global DNS (The Domain Name System servers that are used by all devices on your network): 192.168.1.1
Default Gateway (The device that routes your network traffic to other networks or the internet): 192.168.1.1
Proxy (A server that acts as an intermediary for requests from clients seeking resources from other servers): No proxy
NTP Server(s) (Network Time Protocol servers - these servers provide time synchronization for your device): [ntp.ubuntu.com, time.google.com]
```

When an agent's network configuration is inspected, any fields containing blank or incorrect values indicate a potential misconfiguration of the hypervisor's network adapter settings or the agent's interface settings. For example, an empty `IP address` value or a `Link` or `Operstate` status other than `up` suggests that the agent might not be properly connected to the network. In such cases, administrators should verify the hypervisor's network adapter settings or reconfigure the agent's interface settings.

## Connectivity testing

After the network configuration is verified, the next step is to test the connectivity to the agent's essential Azure endpoints. The agent provides several tools for this purpose, and allows you to choose the level of detail required for your troubleshooting needs. You can choose from general connectivity tests, verbose output for deeper analysis, or single endpoint testing for targeted diagnostics. All three options provide valuable insights into the agent's network connectivity and can help identify potential issues.

Connectivity testing tools are located in the **Network Configuration** group of the agent's menu.

### General network checks

For general connectivity testing, select the **Test Network Connectivity** option. This tool verifies HTTPS connectivity to essential Azure endpoints, including the endpoints required for agent registration and operations. The tool uses the `azcmagent check` command to test Azure Arc endpoints, and then checks Storage Mover-specific endpoints. The results of these tests include:

- HTTPS reachability
- DNS resolution status
- IP type, either private or public
- Proxy usage

> [!NOTE]
> Note: This test doesn't include Storage Account or Key Vault endpoints used during job execution.

### Verbose network checks

The `Test network connectivity verbosely` option provides a more detailed analysis of network connectivity issues. This enhanced version of the General Network Check provides detailed output from `azcmagent` and `curl`, including HTTP response codes and TLS packet data. It's useful for diagnosing SSL-related issues or inspecting specific error messages.

### Single endpoint testing

The `Test single endpoint connectivity` option allows you to test the connectivity of a specific endpoint. In addition to testing Storage Account and Key Vault endpoints that aren't covered by the general network check, this tool allows targeted testing of a specific endpoint using:

- `nslookup` for DNS resolution
- `traceroute` for path analysis
- `curl` for HTTPS connectivity

## Service and job status checks

Within the `Service and job Status` menu, two tools are available for assessing the health of the agent's connection to the Storage Mover Service and the status of job executions. These tools, the **Service Communication Status** and **Job Summary, Details, and Copy logs**, help assess the Agent's registration status and job execution health.

- **Service Communication Status**: Verifies the agent's connection to the Storage Mover Service.
- **Job Summary, Details, and Copy logs**: Provide insights into job performance, including transfer rates and potential network errors such as SSL interception.

## Restricted shell tools

The `Open restricted shell` option allows execution of the following basic network commands. These commands are useful for manual diagnostics and troubleshooting source share connectivity issues:

- `nslookup` and `ping` for endpoint testing.
- `mount`, `showmount`, and `umount` for SMB/NFS share diagnostics.

## SMB diagnostics

Within the `Troubleshooting` group, the `SMB Troubleshooting` option collects SMB logs for inclusion in the support bundle. It's essential for diagnosing issues with SMB source shares. These logs provide insights into authentication problems, permission issues, and connectivity errors related to SMB shares.

## Support bundle collection

The `Collect support bundle` option aggregates logs from all diagnostic tools except for the restricted shell tools. It can be shared with Microsoft Support via SFTP, and is the most comprehensive resource for in-depth troubleshooting.

## Common network issues and resolutions

The following list outlines several common issues and their resolutions:

- **DNS Resolution Failures**<br />
When you encounter issues involving DNS resolution, use the `nslookup` tool, endpoint testing, and network configuration tools to verify DNS settings.
- **HTTPS Connectivity Failures**<br />
HTTPS connectivity failures can often be resolved by checking firewall/proxy settings, validating IP addresses, and inspecting verbose curl output.
- **Arc Private Link Scope Misconfiguration**<br />
Misconfigurations are frequently the cause of most Private Link Scope issues. To resolve these issues, ensure that you obtain correct responses during network checks and validate required endpoint IP types.
- **SSL Interception Errors**<br />
Look for "x509: certificate signed by unknown authority" in verbose logs or copy logs. Allowlisting endpoints might be necessary.

## Next steps

You might find information in the following articles helpful:

- [Release notes](release-notes.md)
- [Resource hierarchy](resource-hierarchy.md)
