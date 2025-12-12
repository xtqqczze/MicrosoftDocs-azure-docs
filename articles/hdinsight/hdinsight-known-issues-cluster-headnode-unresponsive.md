---
title: Azure HDInsight headnode goes to unresponsive state
description: Azure HDInsight – Headnode Unresponsive Due to /tmp Disk Usage Leak in Latest HDInsight 5.1 Releases
ms.service: azure-hdinsight
ms.topic: troubleshooting-known-issue
ms.date: 12/10/2025
---

**Issue published date**: December 12, 2025

## Azure HDInsight headnode goes to unresponsive state due to disk usage issue

Certain Azure HDInsight 5.1 cluster versions contain an issue where temporary OpenSSL-related directories accumulate under /tmp/tmp-*openssl. These directories are not automatically cleaned up by the system as intended. Over time, this leads to a disk usage spike to 100% on the headnodes, causing cluster instability and headnode unresponsiveness.

## Symptoms

   1. Headnode becomes unreachable or slow.
   2. YARN/DFS operations fail due to lack of disk space.
   3. Health probes report headnode unhealthy.
   4. Logs show No space left on device errors.
   5. SSH sessions may fail or commands hang due to full /tmp.

## Impact

Affects HDInsight 5.1 clusters as below:
   1. Causes /tmp to reach 100% utilization.
   2. Headnodes enter unresponsive/unhealthy state.
   3. Can affect job submission, Ambari access, and essential HDInsight control-plane operations.

## Root cause

A regression in the latest HDInsight 5.1 release introduced an issue where OpenSSL temporary directories created in /tmp/tmp-*openssl do not get cleaned up automatically as expected.

## Recommended steps

1. To resolve this issue, run the following [script action](/azure/hdinsight/hdinsight-hadoop-customize-cluster-linux#script-action-to-a-running-cluster) on headnodes

   `https://hdiconfigactions.blob.core.windows.net/openssl-patch/openssltmpclean.sh`

>[!IMPORTANT]
> Automated cleanup included in the code path does not execute as expected, hence the manual cleanup is temporary—recurring creation continues. The cron-based cleanup is the recommended and supported mitigation until a patched HDInsight image is released.

## Resources

- [Script action to a running cluster](/azure/hdinsight/hdinsight-hadoop-customize-cluster-linux#script-action-to-a-running-cluster)
- [Supported HDInsight versions](/azure/hdinsight/hdinsight-component-versioning#supported-hdinsight-versions)

