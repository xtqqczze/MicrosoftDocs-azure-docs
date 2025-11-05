---
title: Azure NetApp Files large volume breakthrough mode performance benchmarks for Linux
description: Describes the tested performance capabilities of a single Azure NetApp Files large volume breakthrough mode as it pertains to Linux use cases.
services: azure-netapp-files
author: netapp-manishc
ms.service: azure-netapp-files
ms.workload: storage
ms.tgt_pltfrm: na
ms.custom: linux-related-content
ms.topic: concept-article
ms.date: 11/05/2025
ms.author: anfdocs
# Customer intent: As a cloud architect, I want to understand the performance benchmarks of Azure NetApp Files large volumes breakthrough mode for Linux use cases, so that I can optimize volume sizing and workload configurations for our applications.
---
# Azure NetApp Files large volume breakthrough mode performance benchmarks for Linux

This article describes the tested performance capabilities of a single [Azure NetApp Files large volumes breakthrough mode](large-volumes-requirements-considerations.md) as it pertains to Linux use cases. The tests explored scenarios for scale-out read and write workloads, involving one and many virtual machines (VMs). Knowing the performance envelope of large volumes helps you facilitate volume sizing.

##  Linux scale-out tests on large volume breakthrough mode 

Tests observed performance thresholds of a single large volume breakthrough mode on scale-out and were conducted with the following configuration:

| Component | Configuration |  
|- | - |
| Azure VM size | E32s_v5 |
| Azure VM egress bandwidth limit | 2000MiB/s (2GiB/s) |
| Operating system | RHEL 8.4 |
| Large volume size | 101 TiB Ultra |
| Mount options | `hard,rsize=65536,wsize=65536,vers=3`  <br /> **NOTE:** Use of both 262144 and 65536 had similar performance results. |

### 256-KiB sequential workloads (MiB/s) 

The graph represents a 256-KiB sequential workload using 12 virtual machines reading and writing to a single large volume using a 1-TiB working set. The graph shows that a single Azure NetApp Files large volume can handle between approximately 21,202 MiB/s pure sequential writes and 50,000 MiB/s pure sequential reads.

:::image type="content" source="./media/performance-large-volumes-linux/sequential-reads-breakthrough-mode.png" alt-text="Bar chart of a 256-KiB sequential workload on a large volume breakthrough mode." lightbox="./media/performance-large-volumes-linux/sequential-reads-breakthrough-mode.png":::

### 8-KiB random workload (IOPS)

The graph represents an 8-KiB random workload and a 1 TiB working set. The graph shows that an Azure NetApp Files large volume can handle between approximately 994,384 pure random writes and approximately 1,800,000 pure random reads.

:::image type="content" source="./media/performance-large-volumes-linux/random-workload-chart-breakthrough-mode.png" alt-text="Bar chart of a random workload on a large volume breakthrough mode." lightbox="./media/performance-large-volumes-linux/random-workload-chart-breakthrough-mode.png":::