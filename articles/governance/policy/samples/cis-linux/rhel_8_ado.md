---
title: Reference - Release Notes - CIS Benchmark - Red Hat Enterprise Linux 8
description: Details of Release Notes - CIS Benchmark - Red Hat Enterprise Linux 8
ms.date: 11/05/2025
author: pallakatos
ms.author: pallakatos
ms.topic: reference
ms.custom: generated
---
# Release Notes - CIS Benchmark - RedHat Enterprise Linux 8

**Supported Benchmarks**
| Benchmark Title |
| --- |
| [CIS Red Hat Enterprise Linux 8 Benchmark 3.0.0 Level 1 + 2 Server Profiles](#cis-red-hat-enterprise-linux-8-benchmark-300-level-1--2-server-profiles) |

## CIS Red Hat Enterprise Linux 8 Benchmark 3.0.0 Level 1 + 2 Server Profiles
<a id="cis-red-hat-enterprise-linux-8-benchmark-300-level-1--2-server-profiles"></a>

**Mismatched Rules**
> **_NOTE:_** The mismatched rules are the ones that in some circumstances the assessment might differ from CIS-CAT® Pro Assessor; usually our implementation enforces stricter criteria.
- Ensure crontab is restricted to authorized users
- Ensure /etc/shadow password fields are not empty
- Ensure sshd MaxStartups is configured
- Ensure audit configuration files are owned by root
- Ensure sshd LoginGraceTime is configured
- Ensure audit configuration files are 640 or more restrictive
- Ensure root is the only UID 0 account

**Not Implemented Rules**
- Ensure only authorized groups are assigned ownership of audit log files
- Ensure cryptographic mechanisms are used to protect the integrity of audit tools
- Ensure access to the su command is restricted

**Configurable Parameters**
| Rule | Parameter | Default Value |
| --- | --- | --- |
| Ensure dns server services are not in use | serviceName | named.service |
|  | expectedUnitFileState | enabled |
|  | expectedActiveState | active |
|  | packageName | bind |
