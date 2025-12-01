---
title: Submit Job on CycleCloud with Slurm 
description: How to submit your first job on CycleCloud with Slurm
author: xpillons
ms.date: 12/01/2025
ms.author: padmalathas
---

# Submit Your First Job on Azure CycleCloud with Slurm

This guide walks you through submitting and managing jobs on an CycleCloud cluster running Slurm. 

## Prerequisites

Before starting, you'll need:

- An Azure CycleCloud Workspace for Slurm environment already deployed. For instructions on how to deploy, see [deployment quickstart](https://learn.microsoft.com/en-us/azure/cyclecloud/qs-deploy-ccws?view=cyclecloud-8) to set up your environment.
- SSH key pair configured during deployment.
- Access to the CycleCloud VM or Azure Bastion.

## Understanding the Cluster Components

Your CycleCloud Slurm cluster has three main node types you'll interact with:

| Node Type | What It Does | When You Use It |
|-----------|--------------|-----------------|
| **Login Node** | Entry point for users | Connect here to submit and manage jobs |
| **Scheduler Node** | Manages job queue and resources | Runs automatically in the background |
| **Compute Nodes** | Execute your workloads | Created on-demand when jobs need resources |

## Understanding Slurm Partitions

Your cluster comes with pre-configured partitions (resource pools) designed for different workload types:

| Partition | Best For | Typical VM Types |
|-----------|----------|------------------|
| **HTC** | Independent tasks that don't need to communicate (data processing, rendering) | General-purpose VMs (D-series) |
| **HPC** | Tightly coupled parallel jobs using MPI (simulations, modeling) | HPC-optimized VMs with InfiniBand (HBv3, HBv4, HBv5) |
| **GPU** | Machine learning, deep learning, GPU-accelerated computing | GPU VMs (NC-series, ND-series) |

> [NOTE]
> See [Slurm Scheduler Integration](https://learn.microsoft.com/en-us/azure/cyclecloud/slurm?view=cyclecloud-8) for partition configuration options.

---

## Step 1: Connect to the Login Node

You have two options for connecting to your cluster.

### Option A: Connect via CycleCloud VM

If you have access to the CycleCloud VM, use the CycleCloud CLI:

```bash
# First, SSH to the CycleCloud VM
ssh -i ~/.ssh/your_private_key username@cyclecloud-vm-ip

# Initialize CycleCloud (first time only)
cyclecloud initialize

# Connect to the login node
cyclecloud connect login-1 -c your-cluster-name
```

### Option B: Direct SSH Connection

If you have the login node's IP address:

```bash
ssh -i ~/.ssh/your_private_key username@login-node-ip
```

> [NOTE]
> If your cluster doesn't allow public IPs, connect through Azure Bastion. See [Azure Bastion documentation](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) for setup instructions.

---

## Step 2: Check Cluster Status

Once connected to the login node, verify the cluster is ready:

```bash
# View available partitions and their status
sinfo
```

Example output:
```
PARTITION  AVAIL  TIMELIMIT  NODES  STATE  NODELIST
htc*       up     infinite   10     idle~  htc-[1-10]
hpc        up     infinite   10     idle~  hpc-[1-10]
gpu        up     infinite   4      idle~  gpu-[1-4]
```

**Reading the output:**
- `idle~` means nodes are available but not yet running (CycleCloud will start them when needed)
- `idle` means nodes are running and ready
- `alloc` means nodes are currently running jobs

For more detail:

```bash
# Detailed partition and node information
sinfo -l
```

---

## Step 3: Create a Job Script

Job scripts tell Slurm what resources you need and what commands to run. Create a simple test script:

```bash
# Create the script file
nano hello-world.sh
```

Paste this content:

```bash
#!/bin/bash
#SBATCH --job-name=hello_world    # Name to identify your job
#SBATCH --output=hello_world.out  # File for standard output
#SBATCH --partition=hpc           # Which partition to use
#SBATCH --nodes=1                 # Number of nodes needed
#SBATCH --ntasks=1                # Number of tasks to run
#SBATCH --time=00:05:00           # Maximum run time (HH:MM:SS)

echo "Hello from $(hostname)"
echo "Job started at $(date)"
echo "Running on partition: $SLURM_JOB_PARTITION"
sleep 10
echo "Job completed at $(date)"
```

Save and exit (Ctrl+X, then Y, then Enter).

### Common SBATCH Options

| Option | Description | Example |
|--------|-------------|---------|
| `--job-name` | Identifier for your job | `--job-name=my_analysis` |
| `--output` | Where to write output | `--output=results_%j.out` (%j = job ID) |
| `--partition` | Resource pool to use | `--partition=gpu` |
| `--nodes` | Number of compute nodes | `--nodes=4` |
| `--ntasks` | Total tasks across all nodes | `--ntasks=16` |
| `--cpus-per-task` | CPUs for each task | `--cpus-per-task=4` |
| `--mem` | Memory per node | `--mem=32G` |
| `--time` | Maximum runtime | `--time=02:00:00` |
| `--gres` | Generic resources (like GPUs) | `--gres=gpu:1` |

---

## Step 4: Submit Your Job

Submit the job to the queue:

```bash
sbatch hello-world.sh
```

You'll see a confirmation with your job ID:
```
Submitted batch job 1
```

### What Happens Behind the Scenes

1. **Job queued** — Slurm adds your job to the queue
2. **Resources requested** — Slurm tells CycleCloud it needs compute nodes
3. **Nodes provisioned** — CycleCloud creates VMs in Azure (takes 2-5 minutes for new nodes)
4. **Job runs** — Your script executes on the allocated nodes
5. **Nodes released** — After the job completes, idle nodes are eventually terminated to save costs

---

## Step 5: Monitor Your Job

### Check Job Status

```bash
# View all jobs in the queue
squeue
```

Example output:
```
JOBID  PARTITION  NAME         USER     ST  TIME  NODES  NODELIST(REASON)
1      hpc        hello_world  hpcuser  R   0:05  1      hpc-1
```

**Job states:**
- `PD` (Pending) — Waiting for resources
- `CF` (Configuring) — Nodes being set up
- `R` (Running) — Job is executing
- `CG` (Completing) — Job finishing up
- `CD` (Completed) — Job finished successfully
- `F` (Failed) — Job encountered an error

### Check Node Allocation

```bash
# See which nodes are allocated
sinfo

# View detailed job information
scontrol show job 1
```

### Monitor from CycleCloud Web UI

You can also monitor your cluster visually:

1. Open your browser and navigate to `https://your-cyclecloud-vm-ip`
2. Log in with your CycleCloud credentials
3. Click on your cluster to see node status and provisioning progress

---

## Step 6: View Job Results

Once your job completes, check the output file:

```bash
# View the output
cat hello_world.out
```

Example output:
```
Hello from hpc-1
Job started at Mon Dec  1 14:23:45 UTC 2025
Running on partition: hpc
Job completed at Mon Dec  1 14:23:55 UTC 2025
```

### Output File Location

By default, output files are created in the directory where you submitted the job. This directory is typically on a shared filesystem (like Azure NetApp Files), making outputs accessible from any node.

---

## Practical Examples

### Example 1: Simple Python Script

```bash
#!/bin/bash
#SBATCH --job-name=python_analysis
#SBATCH --output=analysis_%j.out
#SBATCH --partition=htc
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=01:00:00

module load python/3.9  # Load Python if using modules
python my_analysis.py
```

### Example 2: Multi-Node MPI Job

```bash
#!/bin/bash
#SBATCH --job-name=mpi_simulation
#SBATCH --output=sim_%j.out
#SBATCH --partition=hpc
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=120
#SBATCH --time=04:00:00

module load mpi/openmpi
srun ./my_mpi_program
```

### Example 3: GPU Job

```bash
#!/bin/bash
#SBATCH --job-name=ml_training
#SBATCH --output=training_%j.out
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --time=08:00:00

module load cuda/11.8
python train_model.py
```

---

## Common Slurm Commands Reference

| Command | Description |
|---------|-------------|
| `sbatch script.sh` | Submit a batch job |
| `squeue` | View job queue |
| `squeue -u $USER` | View only your jobs |
| `sinfo` | View partition and node status |
| `scancel JOB_ID` | Cancel a job |
| `scancel -u $USER` | Cancel all your jobs |
| `scontrol show job JOB_ID` | Detailed job information |
| `sacct -j JOB_ID` | Job accounting information (after completion) |
| `srun command` | Run interactive command on allocated resources |
| `salloc` | Request interactive resource allocation |

---

## Troubleshooting

### Job Stuck in Pending (PD) State

Check the reason:
```bash
squeue -j JOB_ID -o "%j %T %r"
```

Common reasons:
- `(Resources)` — Waiting for nodes to be provisioned (normal, wait 2-5 minutes)
- `(Priority)` — Other jobs have higher priority
- `(QOSMaxJobsPerUserLimit)` — You've hit your job limit

### Nodes Not Starting

Check CycleCloud for provisioning errors:
```bash
# From CycleCloud VM
cyclecloud show_cluster your-cluster-name
```

### Job Failed Immediately

Check the output file and Slurm logs:
```bash
# View your output file
cat your_output_file.out

# Check Slurm's record
sacct -j JOB_ID --format=JobID,State,ExitCode,Reason
```

---

## Next Steps

- **Scale up:** Submitting jobs that use multiple nodes
- **Use containers:** CycleCloud Workspace for Slurm includes Pyxis and Enroot for containerized workloads
- **Set up job accounting:** Enable MySQL integration to track resource usage over time
- **Explore Open OnDemand:** Access your cluster through a web interface
