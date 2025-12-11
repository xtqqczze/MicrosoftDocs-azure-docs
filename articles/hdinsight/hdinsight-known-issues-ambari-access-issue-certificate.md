---
title: Ambari access broken due to certificate issues ost certification rotation
description: Ambari access broken due to certificate issues ost certification rotation
ms.service: azure-hdinsight
ms.topic: troubleshooting-known-issue
ms.date: 10/12/2025
---

# Ambari access broken due to certificate issues post certification rotation

**Issue published date**: October 10, 2025

In the latest Azure HDInsight release, there's an issue while trying to access Ambari UI due to certificate issue, when the new certificate rotation happens from RP

> [!IMPORTANT]  
> This issue affects HDInsight 5.1 clusters

## Recommended steps

1. Sign-in in headnode via ssh.
2. Restart the Ambari UI with command 
    service ambari-server restart
5. Login to Ambari service


## Resources


- [Supported HDInsight versions](./hdinsight-component-versioning.md#supported-hdinsight-versions).
