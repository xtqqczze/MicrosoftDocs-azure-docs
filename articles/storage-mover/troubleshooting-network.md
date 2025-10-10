---
title: Troubleshooting network issues with the Azure Storage Mover Agent
description: Learn how to troubleshoot network issues with the Azure Storage Mover Agent.
author: stevenmatthew
ms.author: shaas
ms.service: azure-storage-mover
ms.topic: how-to
ms.date: 10/08/2025
ms.custom: template-how-to
---

# Troubleshooting network issues with the Azure Storage Mover Agent

The Azure Storage Mover Agent is an important part of the Azure Storage Mover service, a powerful tool for seamlessly migrating data to Azure. The agent's functionality depends heavily on reliable network connectivity. When network issues arise, The Azure Storage Mover Agent provides a robust set of tools for diagnosing and resolving network issues. 

By following a structured approach, starting with configuration checks, progressing through connectivity tests, and applying endpoint diagnostics, administrators can ensure reliable operation and successful data migrations. For persistent or complex issues, the support bundle offers a path to deeper analysis and assistance from Microsoft Support. 

These native diagnostic tools can be used with standard network troubleshooting tools and techniques.

This article outlines the available methods for troubleshooting network issues with the agent, including configuration checks, connectivity tests, endpoint diagnostics, and support tools.

## Network Configuration Overview

The recommended first step in diagnosing network issues is to inspect the agent’s network configuration. This inspection can be done via the **Show network configuration** tool located in **Network Configuration** group of the agent's menu. 

The **Show Network Configuration** tool displays critical information such as:

- DHCP status
- IP address and subnet mask
- MAC address
- Link and operational state
- Speed and MTU
- DNS servers and routing table
- Default gateway and proxy settings
- NTP server configuration

The following is example output from the tool:

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
    169.254.169.254/32 proto dhcp scope link src 192.168.1.10 metric 100
Global DNS (The Domain Name System servers that are used by all devices on your network): 192.168.1.1
Default Gateway (The device that routes your network traffic to other networks or the internet): 192.168.1.1
Proxy (A server that acts as an intermediary for requests from clients seeking resources from other servers): No proxy
NTP Server(s) (Network Time Protocol servers - these servers provide time synchronization for your device): [ntp.ubuntu.com, time.google.com]
```

When inspecting an agent's network configuration, any fields containing blank or incorrect values indicate a potential misconfiguration of the hypervisor's network adapter settings or the agent's interface settings. For example, an empty **IP address** value or a **Link** or **Operstate** other than `up` suggests that the agent may not be properly connected to the network. In such cases, administrators should verify the hypervisor's network adapter settings or reconfigure the agent's interface settings.

## Connectivity Testing

After the network configuration is verified, the next step is to test the connectivity to the agent's essential Azure endpoints. The agent provides several tools for this purpose.

### General Network Checks

`2) Network Configuration > 3) Test network connectivity`

The **Test Network Connectivity** tool verifies HTTPS connectivity to essential Azure endpoints, including those required for registration and Agent operations. The tool uses the `azcmagent check` command to test Azure Arc endpoints, and then checks Storage Mover-specific endpoints. The results of these tests include:

- HTTPS reachability
- DNS resolution status
- IP type (private/public)
- Proxy usage

> [!NOTE]
> Note: This test does not include Storage Account or Key Vault endpoints used during job execution.

### Verbose Network Checks

`2) Network Configuration > 4) Test network connectivity verbosely`

This enhanced version of the General Network Check provides detailed output from `azcmagent` and `curl`, including HTTP response codes and TLS packet data. It is useful for diagnosing SSL-related issues or inspecting specific error messages.

### Single Endpoint Testing

`2) Network Configuration > 5) Test single endpoint connectivity`

This tool allows targeted testing of a specific endpoint using:

- nslookup for DNS resolution
- traceroute for path analysis
- curl for HTTPS connectivity

It also supports testing of Storage Account and Key Vault endpoints, which are not covered by the general network check.

## Service and Job Status Checks

`3) Service and job Status`

These tools help assess the Agent’s registration status and job execution health.

Service Communication Status: Verifies the Agent’s connection to the Storage Mover Service.
Job Summary, Details, and Copylogs: Provide insights into job performance, including transfer rates and potential network errors (e.g., SSL interception).


## Restricted Shell Tools

`8) Open restricted shell`

The restricted shell allows execution of basic network commands:

nslookup and ping for endpoint testing
mount, showmount, and umount for SMB/NFS share diagnostics

These tools are particularly useful for troubleshooting source share connectivity.

## SMB Diagnostics

`9) Troubleshooting > 1) SMB Troubleshooting`

This menu collects SMB logs for inclusion in the support bundle. It is essential for diagnosing issues with SMB source shares.

## Support Bundle Collection

`5) Collect support bundle`

The support bundle aggregates logs from all diagnostic tools (except restricted shell) and can be shared with Microsoft Support via SFTP. It is the most comprehensive resource for in-depth troubleshooting.

## Common Networking Issues and Resolutions

The document outlines several common issues and how to resolve them:

DNS Resolution Failures: Use nslookup, endpoint testing, and network configuration tools to verify DNS settings.
HTTPS Connectivity Failures: Check firewall/proxy settings, validate IP addresses, and inspect verbose curl output.
Arc Private Link Scope Misconfiguration: Ensure correct responses during network checks and validate endpoint IP types.
SSL Interception Errors: Look for “x509: certificate signed by unknown authority” in verbose logs or copy logs. allowlisting endpoints might be necessary.

## Next steps

You might find information in the following articles helpful:

- [Release notes](release-notes.md)
- [Resource hierarchy](resource-hierarchy.md)
