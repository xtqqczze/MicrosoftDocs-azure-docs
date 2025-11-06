# Release Notes - Debian Linux 12

## Supported Benchmarks

|Benchmark Title|
|---|
|[CIS Debian Linux 12 Benchmark 1.1.0 Level 1 + Level 2 - Server](#cis-debian-linux-12-benchmark-110-level-1--level-2---server)|

## CIS Debian Linux 12 Benchmark 1.1.0 Level 1 + Level 2 - Server

### Mismatched Rules

> **_NOTE:_** The mismatched rules are the ones that in some circumstances the assessment might differ from CIS-CAT® Pro Assessor; usually our implementation enforces stricter criteria.

- Ensure world writable files and directories are secured
- Ensure only one logging system is in use
- Ensure a single firewall configuration utility is in use

### Not Implemented Rules

- Ensure cryptographic mechanisms are used to protect the integrity of audit tools
- Ensure access to the su command is restricted

### Configurable Parameters

|Rule|Parameter|Default Value|
|---|---|---|
|Ensure permissions on /etc/crontab are configured|mask|0177|
||owner|root|
||group|root|
|Ensure permissions on /etc/cron.hourly are configured|mask|0077|
||owner|root|
||group|root|
|Ensure permissions on /etc/cron.daily are configured|mask|0077|
||owner|root|
||group|root|
||packageName|cron|
||alternativePackageName|cronie|
|Ensure permissions on /etc/cron.weekly are configured|mask|0077|
||owner|root|
||group|root|
|Ensure permissions on /etc/cron.monthly are configured|mask|0077|
||owner|root|
||group|root|
||alternativePackageName|cronie|
|Ensure permissions on /etc/cron.d are configured|mask|0077|
||owner|root|
||group|root|
|Ensure permissions on /etc/ssh/sshd_config are configured|mask|0177|
||owner|root|
||group|root|
|Ensure permissions on /etc/passwd are configured|mask|0133|
||owner|root|
||group|root|
|Ensure permissions on /etc/passwd- are configured|mask|0133|
||owner|root|
||group|root|
|Ensure permissions on /etc/group are configured|mask|0133|
||owner|root|
||group|root|
|Ensure permissions on /etc/group- are configured|mask|0133|
||owner|root|
||group|root|
|Ensure permissions on /etc/shadow are configured|mask|0137|
||owner|root|
||group|root\|shadow|
|Ensure permissions on /etc/shadow- are configured|mask|0137|
||owner|root|
||group|root\|shadow|
|Ensure permissions on /etc/gshadow are configured|mask|0137|
||owner|root|
||group|shadow\|root|
|Ensure permissions on /etc/gshadow- are configured|mask|0137|
||owner|root|
||group|shadow\|root|
|Ensure permissions on /etc/shells are configured|mask|0133|
||owner|root|
||group|root|
|Ensure permissions on /etc/security/opasswd are configured|mask|0177|
||owner|root|
||group|root|
