---
title: Reference - CIS Security Benchmarks for Oracle Linux 8
description: Reference - CIS Security Benchmarks for Oracle Linux 8
ms.date: 11/05/2025
author: pallakatos
ms.author: pallakatos
ms.topic: reference
ms.custom: generated
---
# Release Notes - Oracle Linux 8

## Supported Benchmarks

|Benchmark Title|
|---|
|[CIS Oracle Linux 8 Benchmark 3.0.0 Level 1 + Level 2 - Server](#cis-oracle-linux-8-benchmark-300-level-1--level-2---server)|

## CIS Oracle Linux 8 Benchmark 3.0.0 Level 1 + Level 2 - Server

### Mismatched Rules

> **_NOTE:_** The mismatched rules are the ones that in some circumstances the assessment might differ from CIS-CAT® Pro Assessor; usually our implementation enforces stricter criteria.

- Ensure crontab is restricted to authorized users
- Ensure sshd MaxStartups is configured
- Ensure sshd LoginGraceTime is configured
- Ensure root is the only UID 0 account
- Ensure audit configuration files are owned by root
- Ensure audit configuration files are 640 or more restrictive
- Ensure /etc/shadow password fields are not empty
- Ensure active authselect profile includes pam modules

### Unimplemented rules

- Ensure only authorized groups are assigned ownership of audit log files
- Ensure cryptographic mechanisms are used to protect the integrity of audit tools
- Ensure access to the su command is restricted

### Configurable Parameters

- None
