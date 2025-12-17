---
title: Collect custom metrics for GPU and InfiniBand on Linux VMs with the InfluxData Telegraf agent
description: Learn how to deploy and configure the InfluxData Telegraf agent on a Linux virtual machine to send GPU and InfiniBand metrics to Azure Monitor for HPC and AI workloads.
author: vinil-v
ms.author: padmalathas
ms.reviewer: daramfon10
ms.topic: how-to
ms.custom: linux-related-content
ms.date: 12/17/2025
---

# Collect custom metrics for GPU and InfiniBand on Linux VMs with the InfluxData Telegraf agent

This article explains how to deploy and configure the InfluxData Telegraf agent on a Linux virtual machine to send GPU and InfiniBand metrics to Azure Monitor for HPC and AI workloads.

> [!IMPORTANT]
> InfluxData Telegraf is an open-source agent and not officially supported by Azure Monitor. For issues with the Telegraf connector, refer to the Telegraf GitHub page: [InfluxData](https://github.com/influxdata/telegraf)

## Overview

As HPC and AI workloads continue to scale in complexity and performance demands, ensuring visibility into the underlying infrastructure becomes critical. This guide presents a monitoring solution for AI infrastructure deployed on Azure RDMA-enabled virtual machines (VMs), focusing on NVIDIA GPUs and Mellanox InfiniBand devices.

By leveraging the Telegraf agent and Azure Monitor, this setup enables real-time collection and visualization of key hardware metrics, including GPU utilization, GPU memory usage, InfiniBand port errors, and link flaps. It provides operational insights vital for debugging, performance tuning, and capacity planning in high-performance AI environments.

> [!NOTE]
> While Azure Monitor offers robust monitoring capabilities for CPU, memory, storage, and networking, it does not natively support GPU or InfiniBand metrics for Azure H- or N-series VMs. To monitor GPU and InfiniBand performance, additional configuration using third-party tools such as Telegraf is required.

Telegraf is a plug-in-driven agent that enables the collection of metrics from over 150 different sources. The Telegraf agent integrates directly with the Azure Monitor custom metrics REST API. It supports an Azure Monitor output plug-in. Using this plug-in, the agent can collect workload-specific metrics on your Linux VM and submit them as custom metrics to Azure Monitor.

[![Screenshot showing the Telegraf agent architecture for GPU and InfiniBand monitoring.](media/collect-custom-metrics-gpu-infiniband-telegraf/telegraf-agent-overview.png)](media/collect-custom-metrics-gpu-infiniband-telegraf/telegraf-agent-overview.png#lightbox)

## Prerequisites

- An Azure subscription with permissions to register resource providers
- An Azure H-series or N-series VM (for example, Standard_ND96asr_v4)
- Ubuntu-HPC 22.04 image (recommended) with pre-installed NVIDIA GPU drivers, CUDA, and InfiniBand drivers
- SSH access to the virtual machine

## Register the resource provider

Register the **microsoft.insights** resource provider in your Azure subscription to enable custom metrics.

1. Open the Azure portal and navigate to your subscription.
2. In the left menu, select **Resource providers**.
3. Search for **microsoft.insights**.
4. Select the provider and click **Register**.

[![Screenshot showing the Azure portal Resource providers registration page.](../../media/collect-custom-metrics-gpu-infiniband-telegraf/register-resource-provider.png)](media/collect-custom-metrics-gpu-infiniband-telegraf/register-resource-provider.png#lightbox)

For more information, see [Resource providers and resource types - Azure Resource Manager](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider-1).

## Enable Managed Identity

Enable Managed Service Identities to authenticate your Azure VM or Azure VMSS with Azure Monitor.

1. Navigate to your VM in the Azure portal.
2. In the left menu under **Security**, select **Identity**.
3. On the **System assigned** tab, set **Status** to **On**.
4. Select **Save**.

> [!TIP]
> You can also use User Managed Identities or Service Principal to authenticate the VM. For more information, see the [Telegraf Azure Monitor output plugin documentation](https://github.com/influxdata/telegraf/tree/release-1.15/plugins/outputs/azure_monitor#authentication).

[![Screenshot showing the Azure portal Identity settings with System assigned identity enabled.](../../media/collect-custom-metrics-gpu-infiniband-telegraf/enable-managed-identity.png)](media/collect-custom-metrics-gpu-infiniband-telegraf/enable-managed-identity.png#lightbox)

For more information, see:
- [Configure managed identities on Azure VMs](/entra/identity/managed-identities-azure-resources/how-to-configure-managed-identities)
- [Configure managed identities on Azure VMSS](/entra/identity/managed-identities-azure-resources/how-to-configure-managed-identities-scale-sets)

## Install and configure Telegraf

Set up the Telegraf agent inside the VM or VMSS to send GPU and InfiniBand data to Azure Monitor.

### Connect to the VM

Create an SSH connection to the VM where you want to install Telegraf. Select the **Connect** button on the overview page for your virtual machine.

In the **Connect to virtual machine** page, keep the default options to connect by DNS name over port 22. In **Login using VM local account**, a connection command is shown. Select the button to copy the command. The following example shows what the SSH connection command looks like:

```bash
ssh azureuser@XXXX.XX.XXX
```

Paste the SSH connection command into a shell, such as Azure Cloud Shell or Bash on Ubuntu on Windows, or use an SSH client of your choice to create the connection.

### Install the Telegraf agent

Download and run the setup script to install the Telegraf agent on Ubuntu 22.04. This script configures the NVIDIA SMI input plugin, the InfiniBand input plugin, and sets up the Telegraf configuration to send data to Azure Monitor.

> [!NOTE]
> The `gpu-ib-mon_setup.sh` script is currently supported and tested only on Ubuntu 22.04.

Run the following commands from your SSH session:

```bash
wget https://raw.githubusercontent.com/vinil-v/gpu-ib-monitoring/refs/heads/main/scripts/gpu-ib-mon_setup.sh -O gpu-ib-mon_setup.sh
chmod +x gpu-ib-mon_setup.sh
./gpu-ib-mon_setup.sh
```

For more information about InfiniBand counters collected by Telegraf, see [Understanding mlx5 Linux counters and status parameters](https://enterprise-support.nvidia.com/s/article/understanding-mlx5-linux-counters-and-status-parameters).

### Test the configuration

Test the Telegraf configuration by executing the following command:

```bash
sudo telegraf --config /etc/telegraf/telegraf.conf --test
```

## Create dashboards in Azure Monitor

Telegraf includes an output plugin specifically designed for Azure Monitor, allowing custom metrics to be sent directly to the platform. Since Azure Monitor supports a metric resolution of one minute, the Telegraf output plugin aggregates metrics into one-minute intervals and sends them to Azure Monitor at each flush cycle.

Metrics from each Telegraf input plugin are stored in a separate Azure Monitor namespace, typically prefixed with **Telegraf/** for easy identification.

### Visualize NVIDIA GPU metrics

To visualize NVIDIA GPU usage in the Azure portal:

1. Navigate to **Monitor** > **Metrics**.
2. Set the scope to your VM.
3. Choose the **Metric Namespace** as **Telegraf/nvidia-smi**.
4. Select metrics such as utilization, memory usage, or temperature.
5. Use filters and splits to analyze data across multiple GPUs or over time.

[![Screenshot showing Azure Monitor Metrics with GPU memory_used metrics using Telegraf/nvidia-smi namespace.](media/collect-custom-metrics-gpu-infiniband-telegraf/gpu-metrics-dashboard.png)](media/collect-custom-metrics-gpu-infiniband-telegraf/gpu-metrics-dashboard.png#lightbox)

### Visualize InfiniBand metrics

To monitor InfiniBand performance:

1. In the **Metrics** section, set the scope to your VM.
2. Select the **Metric Namespace** as **Telegraf/infiniband**.
3. Visualize metrics such as port status, data transmitted/received, and error counters.
4. Use filters to break down the data by port or metric type for deeper insights.

> [!NOTE]
> The `link_downed` metric with Aggregation: Count may return incorrect values. Use Max or Min aggregations instead.

[![Screenshot showing Azure Monitor Metrics with InfiniBand link_downed metrics.](media/collect-custom-metrics-gpu-infiniband-telegraf/infiniband-metrics-dashboard.png)](media/collect-custom-metrics-gpu-infiniband-telegraf/infiniband-metrics-dashboard.png#lightbox)

[![Screenshot showing Azure Monitor Metrics with InfiniBand port_rcv_data metrics.](media/collect-custom-metrics-gpu-infiniband-telegraf/infiniband-port-metrics.png)](media/collect-custom-metrics-gpu-infiniband-telegraf/infiniband-port-metrics.png#lightbox)

Creating custom dashboards in Azure Monitor with both **Telegraf/nvidia-smi** and **Telegraf/infiniband** namespaces allows for unified visibility into GPU and InfiniBand performance.

## Test GPU and InfiniBand metrics

If you're testing GPU metrics and need a reliable way to simulate multi-GPU workloads—especially over InfiniBand—use the NCCL benchmark suite. This method is ideal for verifying GPU and network monitoring setups.

### Run NCCL benchmarks

NCCL Benchmark and OpenMPI are part of the Ubuntu HPC 22.04 image. Update the variables according to your environment and update the hostfile with the hostname:

```bash
module load mpi/hpcx-v2.13.1
export CUDA_VISIBLE_DEVICES=2,3,0,1,6,7,4,5
mpirun -np 16 --map-by ppr:8:node -hostfile hostfile \
       -mca coll_hcoll_enable 0 --bind-to numa \
       -x NCCL_IB_PCI_RELAXED_ORDERING=1 \
       -x LD_LIBRARY_PATH=/usr/local/nccl-rdma-sharp-plugins/lib:$LD_LIBRARY_PATH \
       -x CUDA_DEVICE_ORDER=PCI_BUS_ID \
       -x NCCL_SOCKET_IFNAME=eth0 \
       -x NCCL_TOPO_FILE=/opt/microsoft/ndv4-topo.xml \
       -x NCCL_DEBUG=WARN \
       /opt/nccl-tests/build/all_reduce_perf -b 8 -e 8G -f 2 -g 1 -c 1
```

### Alternative: GPU load simulation using TensorFlow

For a more application-like load (for example, distributed training), use the following script that sets up a multi-GPU TensorFlow training environment using Anaconda:

```bash
wget -q https://raw.githubusercontent.com/vinil-v/gpu-monitoring/refs/heads/main/scripts/gpu_test_program.sh -O gpu_test_program.sh
chmod +x gpu_test_program.sh
./gpu_test_program.sh
```

With either method—NCCL benchmarks or TensorFlow training—you can simulate realistic GPU usage and validate your GPU and InfiniBand monitoring setup.

## Clean up resources

When they're no longer needed, you can delete the resource group, virtual machine, and all related resources. To do so, select the resource group for the virtual machine and select **Delete**. Then confirm the name of the resource group to delete.

## Next steps

- Learn more about [custom metrics in Azure Monitor](/azure/azure-monitor/metrics/metrics-custom-overview)
- Review [ND A100 v4-series GPU VM sizes](/azure/virtual-machines/sizes/gpu-accelerated/ndasra100v4-series)
- Get started with [Ubuntu HPC on Azure](https://azuremarketplace.microsoft.com/en-gb/marketplace/apps/microsoft-dsvm.ubuntu-hpc)
- Explore the [Telegraf Azure Monitor output plugin](https://github.com/influxdata/telegraf/tree/release-1.15/plugins/outputs/azure_monitor)
- Configure the [Telegraf NVIDIA SMI input plugin](https://github.com/influxdata/telegraf/tree/release-1.15/plugins/inputs/nvidia_smi)
- Review the [Telegraf InfiniBand input plugin documentation](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/infiniband/README.md)
