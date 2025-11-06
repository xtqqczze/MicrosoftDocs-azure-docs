---
title: Reference - Release Notes - CIS Benchmark - Red Hat Enterprise Linux 9
description: Details of Release Notes - CIS Benchmark - Red Hat Enterprise Linux 9
ms.date: 11/05/2025
author: pallakatos
ms.author: pallakatos
ms.topic: reference
ms.custom: generated
---
# Release Notes - CIS Benchmark - RedHat Enterprise Linux 9

**Supported Benchmarks**
| Benchmark Title |
| --- |
| [CIS Red Hat Enterprise Linux 9 Benchmark 2.0.0 Level 1 + 2 Server Profiles](#cis-red-hat-enterprise-linux-9-benchmark-200-level-1-2-server-profiles) |

## CIS Red Hat Enterprise Linux 9 Benchmark 2.0.0 Level 1 + 2 Server Profiles
<a id="cis-red-hat-enterprise-linux-9-benchmark-200-level-2-server"></a>

**Mismatched Rules**
> **_NOTE:_** The mismatched rules are the ones that in some circumstances the assessment might differ from CIS-CAT® Pro Assessor; usually our implementation enforces stricter criteria.
- Ensure only one logging system is in use

**Not Implemented Rules**
- Ensure access to the su command is restricted

**Configurable Parameters**
| Rule | Parameter | Default Value |
| --- | --- | --- |
| Ensure dns server services are not in use | serviceName | named.service |
|  | expectedUnitFileState | enabled |
|  | expectedActiveState | active |
|  | packageName | bind |
| Ensure permissions on /etc/crontab are configured | mask | 0177 |
|  | owner | root |
|  | group | root |
| Ensure permissions on /etc/cron.hourly are configured | mask | 0077 |
|  | owner | root |
|  | group | root |
| Ensure permissions on /etc/cron.daily are configured | mask | 0077 |
|  | owner | root |
|  | group | root |
|  | packageName | cron |
|  | alternativePackageName | cronie |
| Ensure permissions on /etc/cron.weekly are configured | mask | 0077 |
|  | owner | root |
|  | group | root |
| Ensure permissions on /etc/cron.monthly are configured | mask | 0077 |
|  | owner | root |
|  | group | root |
|  | alternativePackageName | cronie |
| Ensure permissions on /etc/cron.d are configured | mask | 0077 |
|  | owner | root |
|  | group | root |
| Ensure permissions on /etc/ssh/sshd_config are configured | mask | 0177 |
|  | owner | root |
|  | group | root |
| Ensure permissions on /etc/passwd are configured | mask | 0133 |
|  | owner | root |
|  | group | root |
| Ensure permissions on /etc/passwd- are configured | mask | 0133 |
|  | owner | root |
|  | group | root |
| Ensure permissions on /etc/group are configured | mask | 0133 |
|  | owner | root |
|  | group | root |
| Ensure permissions on /etc/group- are configured | mask | 0133 |
|  | owner | root |
|  | group | root |
| Ensure permissions on /etc/shadow are configured | mask | 0137 |
|  | owner | root |
|  | group | root|shadow |
| Ensure permissions on /etc/shadow- are configured | mask | 0137 |
|  | owner | root |
|  | group | root|shadow |
| Ensure permissions on /etc/gshadow are configured | mask | 0137 |
|  | owner | root |
|  | group | shadow|root |
| Ensure permissions on /etc/gshadow- are configured | mask | 0137 |
|  | owner | root |
|  | group | shadow|root |
| Ensure permissions on /etc/shells are configured | mask | 0133 |
|  | owner | root |
|  | group | root |
| Ensure permissions on /etc/security/opasswd are configured | mask | 0177 |
|  | owner | root |
|  | group | root |
