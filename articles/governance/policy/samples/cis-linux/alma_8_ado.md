---
title: Reference - CIS Security Benchmarks for Alma Linux 8
description: Reference - CIS Security Benchmarks for Alma Linux 8
ms.date: 11/05/2025
author: pallakatos
ms.author: pallakatos
ms.topic: reference
ms.custom: generated
---
# Release Notes - AlmaLinux OS 8

## Supported Benchmarks

|Benchmark Title|
|---|
|[CIS AlmaLinux OS 8 Benchmark 3.0.0 Level 1 + Level 2 - Server](#cis-almalinux-os-8-benchmark-300-level-1--level-2---server)|

## CIS AlmaLinux OS 8 Benchmark 3.0.0 Level 1 + Level 2 - Server

### Mismatched Rules

> **_NOTE:_** The mismatched rules are the ones that in some circumstances the assessment might differ from CIS-CAT® Pro Assessor; usually our implementation enforces stricter criteria.

- Ensure audit configuration files are 640 or more restrictive
- Ensure root is the only UID 0 account
- Ensure crontab is restricted to authorized users
- Ensure sshd LoginGraceTime is configured
- Ensure sshd MaxStartups is configured
- Ensure /etc/shadow password fields are not empty
- Ensure audit configuration files are owned by root

### Not Implemented Rules

- Ensure only authorized groups are assigned ownership of audit log files
- Ensure cryptographic mechanisms are used to protect the integrity of audit tools
- Ensure access to the su command is restricted

### Configurable Parameters

|Rule|Parameter|Default Value|
|---|---|---|
|Ensure dns server services are not in use|serviceName|named.service|
||expectedUnitFileState|enabled|
||expectedActiveState|active|
||packageName|bind|
