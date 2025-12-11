---
title: Azure HDInsight headnode goes to unresponsive state
description: Azure HDInsight headnode goes to unresponsive state due to disk usage issue
ms.service: azure-hdinsight
ms.topic: troubleshooting-known-issue
ms.date: 12/10/2025
---

# Conda version regression in a recent HDInsight release

**Issue published date**: December 12, 2025

In the latest Azure HDInsight releases, there is a file leak of /tmp/tmp-*openssl directories which causes unhealthy headnodes.
These directories aren’t cleaned up automatically, so repeated SSL context initialization causes steady growth in disk usage of /tmp.

> [!IMPORTANT]  
> This issue affects HDInsight 5.1 clusters.

## Recommended steps

1. To resolve this issue, run the following [script action](/azure/hdinsight/hdinsight-hadoop-customize-cluster-linux#script-action-to-a-running-cluster) on headnodes

   `https://hdiconfigactions.blob.core.windows.net/openssl-patch/openssltmpclean.sh`

>[!IMPORTANT]
> The script action runs a cron job  which will run daily on each headnode to remove these stale /tmp/tmp-*openssl directories. This will let the clusters self-clean without requiring manual checks or reboots.

## Resources

- [Script action to a running cluster](/azure/hdinsight/hdinsight-hadoop-customize-cluster-linux#script-action-to-a-running-cluster)
- [Supported HDInsight versions](/azure/hdinsight/hdinsight-component-versioning#supported-hdinsight-versions)


