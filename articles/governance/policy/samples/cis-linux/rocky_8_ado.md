# Release Notes - CIS Benchmark - Rocky Linux 8

**Supported Benchmarks**
| Benchmark Title |
| --- |
| [CIS Rocky Linux 8 Benchmark 2.0.0 Level 1 + 2 Server Profiles](#cis-rocky-linux-8-benchmark-200-level-1-2-server-profiles) |

## CIS Rocky Linux 8 Benchmark 2.0.0 Level 1 + 2 Server Profiles
<a id="cis-rocky-linux-8-benchmark-200-level-1-2-server-profiles"></a>

**Mismatched Rules**
> **_NOTE:_** The mismatched rules are the ones that in some circumstances the assessment might differ from CIS-CAT® Pro Assessor; usually our implementation enforces stricter criteria.
- Ensure audit configuration files are 640 or more restrictive
- Ensure sshd LoginGraceTime is configured
- Ensure /etc/shadow password fields are not empty
- Ensure audit configuration files are owned by root
- Ensure crontab is restricted to authorized users
- Ensure sshd MaxStartups is configured
- Ensure root is the only UID 0 account

**Not Implemented Rules**
- Ensure cryptographic mechanisms are used to protect the integrity of audit tools
- Ensure only authorized groups are assigned ownership of audit log files
- Ensure access to the su command is restricted

**Configurable Parameters**
- None
