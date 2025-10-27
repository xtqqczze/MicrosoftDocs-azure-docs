---
title: About SAP Testing Automation Framework
description: Overview of the framework and tooling for SAP Testing Automation Framework.
author: devanshjain
ms.author: devanshjain
ms.reviewer: depadia
ms.date: 10/27/2025
ms.service: sap-on-azure
ms.subservice: sap-automation
ms.topic: conceptual
---

# SAP Testing Automation Framework Overview

The [SAP Testing Automation Framework](https://github.com/Azure/sap-automation-qa) is an open-source orchestration tool designed to validate SAP deployments on Microsoft Azure. It enables you to assess overall system and infrastructure configurations against SAP on Azure best practices and guidelines. Additionally, the framework facilitates automation for various testing scenarios, including High Availability (HA) functional testing.

The SAP Testing Automation Framework started as an addition to the [SAP Deployment Automation Framework (SDAF)](./deployment-framework.md), offering a robust testing layer for SAP systems deployed on Azure through automated validation processes. However, the framework is designed to be flexible and can be configured as a standalone solution, enabling customers who have not deployed their systems using SDAF to independently leverage the testing capabilities and validate their existing SAP environments. The framework helps to validate the configurations and behavior of SAP systems under a wide array of scenarios, bringing confidence and assurance by simulating real-world conditions.

## Key Scenarios

SAP Testing Automation is designed as a scalable framework to orchestrate and validate a wide spectrum of SAP landscape scenarios through repeatable, policy-driven test modules. The framework currently takes care of following scenarios -

### High Availability Testing

In the SAP Testing Automation Framework, thorough validation of high availability SAP HANA scale-up and SAP Central Services failover mechanism in a two node pacemaker cluster can be performed, ensuring the system operates correctly across different situations.

- **High Availability Configuration Validation:** The framework helps to ensure that SAP HANA scale-up and SAP Central Services configurations and load balancer settings are compliant with SAP on Azure high availability configuration guidelines.
- **Functional Testing:** The framework executes series of real-world scenarios based on the SAP HANA and SAP Central Services high availability setup to identify potential issues, whether during a new system deployment or before implementing cluster changes in a production environment. The test cases are based on what is documented in how-to guides for SAP HANA and SAP Central Services configuration.
- **Offline configuration validation:** Offline validation is a mode of the framework that validates SAP HANA and SAP Central Services high availability cluster configurations without establishing a live SSH connection to the production cluster. Instead, it analyzes captured cluster information base (CIB) XML files exported from each cluster node.

### Configuration Checks (Preview)

The framework performs comprehensive configuration checks to ensure that the SAP system and its components are set up according to [SAP on Azure best practice](../../sap/). This includes validating infrastructure settings, operating system parameter configurations, and network settings, in addition to the cluster configuration, to identify any deviations that could impact system performance or reliability.

- **Infrastructure Validation:** This includes validating the underlying infrastructure components, such as virtual machines, load balancer, and other resource configurations, to ensure they meet the requirements for running SAP workloads on Azure.

- **Storage Configuration Checks:** It validates settings of disks, storage accounts, Azure NetApp Files, including throughput, performance, and stripe size.

- **Operating System and SAP Parameter Validation:** The framework checks critical operating system parameters and SAP kernel settings to ensure they align with recommended configurations.

- **Cluster Configuration Validation:** This framework ensures that the high availability cluster resource settings adhere to best practices for high availability and failover scenarios.

The framework generates comprehensive reports, highlighting configuration mismatch or deviations from recommended best practices. For high availability scenarios, the report includes failover test outcomes, any failures encountered, and logs with insights to aid in troubleshooting identified issues.

> [!NOTE]
>
> The configuration checks scenarios in SAP Testing Automation Framework is in public preview, while the high availability testing scenario is generally available (GA).

## Why Use the SAP Testing Automation Framework?

Testing is crucial for keeping SAP systems running smoothly, especially for critical business operations. This framework helps by addressing key challenges:

- **Risk Prevention** - The high availability testing helps simulate system failures like node crashes, network issues, and storage failures to check if recovery mechanisms work properly, helping to catch problems before they affect real operations. Configuration validation detects misalignments with SAP on Azure best practices early.

- **Compliance Requirements** - Many businesses need to prove their SAP systems are reliable. This framework provides detailed reports and logs that help with audits and ensure compliance with internal and regulatory standards.

- **Quality Assurance** - The framework runs automated tests to verify whether the failover behavior of SAP components functions as expected on Azure across various test scenarios. It also ensures that the cluster and resource configurations are set up correctly, helping to maintain system reliability.

- **Test Automation** - Manually validating overall SAP systems' configurations and high availability (HA) setup is slow and error-prone. This framework automates the process, from setup to reporting, saving time and ensuring more accurate and consistent results.

## Considerations

Before running the scenarios, review these guidelines to ensure smooth execution -

1. On new deployment you can execute the scenarios to validate that the system is configured according to SAP on Azure best practices and to observe how the cluster system behaves under various test cases. 
2. Full end-to-end high availability test typically takes around 90 minutes on new HANA setups with small databases and for SAP Central services. For larger database, the run time may extend. Internal validation has been performed on HANA database of size 3.5 TiB. 
3. For large HANA databases, test first in a non-production environment matching production scale. You may need to adjust certain retry logic parameters as operations like stop, start, and registration takes more time on large database.
4. For production SAP systems, run the high availability scenarios only during maintenance window with no active business operations.
5. The framework does not install packages or modify any configuration on cluster nodes. The generated HTML report simply reflects the configuration values and observed behavior of your current setup.

## Architecture and Components

To learn how the framework works, refer to the [architecture and components](./testing-framework-architecture.md) documentation.

## Get Started

There are two primary ways to get started with the SAP Testing Automation Framework. You can choose the path that best fits your current environment and objectives:

### Option 1: Standalone Setup of SAP Testing Automation Framework

For users focused solely on validating SAP functionality and configurations, the standalone approach offers a streamlined process to test critical SAP components without the complexity of full deployment integration. For more details on the setup, see following documents to get started -

- Configure management server following the document [Setup Guide for SAP Testing Automation Framework](https://github.com/Azure/sap-automation-qa/blob/main/docs/SETUP.MD).
  - For high availability testing scenarios, see [High Availability documentation](https://github.com/Azure/sap-automation-qa/blob/main/docs/HIGH_AVAILABILITY.md).
  - For Configuration Checks and Testing details, see the [Configuration Checks documentation](https://github.com/Azure/sap-automation-qa/blob/main/docs/CONFIGURATION_CHECKS.md).

### Option 2: Integration with SAP Deployment Automation Framework (SDAF)

If you already have an [SAP Deployment Automation Framework](./deployment-framework.md) environment set up, integrating the SAP Testing Automation Framework is a natural extension that allows you to apply existing deployment pipelines and configurations. For more details on the setup, see [Setup Guide for SAP Testing Automation Framework with SDAF](https://github.com/Azure/sap-automation-qa/blob/main/docs/SDAF_INTEGRATION.md)

## Next steps

- To understand the architecture of SAP Testing Automation Framework, see [Review the framework architecture](testing-framework-architecture.md).
- For SAP Testing Automation Framework support matrix, see [Understand supported platforms](testing-framework-supportability.md).
