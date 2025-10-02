---
title: Use the Dedicated SKU for Azure Functions Durable Task Scheduler (preview)
description: Learn about how the Dedicated SKU in Azure Functions Durable Task Scheduler.
ms.topic: conceptual
ms.date: 10/02/2025
ms.author: franlanglois
---
# Azure Functions Durable Task Scheduler Pricing and SKU Options

The Azure Durable Task Scheduler offers two pricing models to accommodate different workload requirements, usage patterns, and preferred billing models.

The two models:

- Dedicated
- Consumption (preview)

This document outlines the available SKU options and their pricing structures.

## Actions

An action is one of the fundamental billing units in the Durable Task Scheduler, representing a function invocation triggered by the Durable Task Scheduler. Each time a function runs, it's because an action from the Durable Task Scheduler told it to.

## Actions Breakdown

Consider an orchestration that calls three different activities. Here's how the Durable Task Scheduler processes each action:

:::image type="content" source="media/durable-task-scheduler-dedicated-sku/function-code-image.png" alt-text="Screenshot of orchestration code showing function calls and action breakdown.":::

1. Orchestration Start uses 1 action

1. Activity 1 uses 2 actions

   - One to schedule the activity
   - One to process the result

1. Activity 2 uses 2 actions

    - One to schedule the activity
    - One to process the result

1. Activity 3 uses 2 actions

    - One to schedule the activity
    - One to process the result

Total Calculation: 

Total = 1 (orchestration) + Activity 1 + Activity 2 + Activity 3 = 7 actions

## Calculating the number of Actions

You can use a formula to calculate the number of actions per orchestration:

(Activity Count \* 2) + 1 = Total Number of Actions Per Orchestration

> [!NOTE]
> _Timers_ and _Events Raised_ are also _Activities_

## Dedicated SKU

The Dedicated SKU provides predictable performance and pricing through preallocated Compute Units (CUs).

### Key Features

- Dedicated Infrastructure: Runs on dedicated compute resources

- Predictable Performance: Guaranteed throughput and consistent latency.

- Enterprise SLA: 99.95% uptime guarantee

- Data Retention: Up to 90 days of orchestration data retention

- Custom Scaling: Configure CUs based on your specific throughput or availability requirements

### Pricing and Limits

- Base Cost: Fixed monthly cost per Compute Unit (CU) (regional pricing)

- Capacity: Each CU supports up to 2,000 actions per second

- Storage: Each CU support up to 50GB of orchestration data

- Minimum: 1 CU required per deployment

### High Availability and Zone Redundancy

For high availability and zone redundancy, a minimum of three CUs is required to distribute workloads across multiple scheduler instances.

### Capacity Unit Planning Examples

#### Small five activity example

For orchestrations with five activities plus error handling, averaging 12 actions per orchestration (orchestrator invocations + activity invocations).

Calculation running 20 million orchestrations per month:

- Monthly actions: 20,000,000 × 12 = 240,000,000 actions- 

- Actions per second: 240,000,000 ÷ 2,628,000 ≈ 91 actions/second

- Required CUs: 91 ÷ 2,000 = 0.046 → 1 CU sufficient

#### Large enterprise example

A large enterprise running 500 million complex orchestrations monthly, with an average of 15 actions per orchestration (multiple activities with orchestrator coordination).

Calculation:

- Monthly actions: 500 million × 13 = 6.5 billion actions

- Actions per second: 6.5 billion ÷ 2,628,000 ≈ 2,854 actions/second

- Required CUs: 2,473 ÷ 2,000 = 1.23 → 2 CUs sufficient

#### SaaS platform example

A SaaS platform supporting 800 million orchestrations monthly, each with an average of 15 actions (for example, user interactions, background processing, and external API calls).

Calculation:

- Monthly actions: 800 million × 15 = 12 billion actions

- Actions per second: 12 billion ÷ 2,628,000 ≈ 4,567 actions/second

- Required CUs: 4,567 ÷ 2,000 = 2.28 then three CUs sufficient

## Consumption (preview) SKU

The Consumption (preview) SKU offers a pay-as-you-use model ideal for variable workloads and development scenarios.

### Key Features

- Pay-Per-Use: Only pay for actions dispatched

- No Upfront Costs: No minimum commitments or base fees

- SLA: 99.9% uptime guarantee

- Data Retention: 30-day maximum retention of orchestration data

### Pricing and Limits

- Cost: \$0.03 per action dispatched

- Throughput: Up to 500 actions per second

### Consumption SKU Examples

#### Development environment example

A development team is testing simple orchestrations, each with three actions (using the Hello City pattern), and runs 10,000 orchestrations per month.

Cost Calculation:

- Monthly actions: 10,000 × 3 = 30,000 actions

- Cost: 30,000 × \$0.003 = \$90/month

#### Bursty workloads example

An e-commerce application experiences dynamic workload scaling during promotional sales events, especially on weekends. It uses an orchestration comprising seven total actions, which executes approximately 20,000 times per month.

Cost Calculation:

- Monthly actions: 20,000  × 7 = 140,000 actions

- Cost: 140,000 × \$0.003 = \$420/month

## Comparing Dedicated and Consumption SKUs

| Feature         | Consumption SKU                 | Dedicated SKU                     |
|-----------------|---------------------------------|-----------------------------------|
| Infrastructure  | Multitenant                    | Dedicated Infrastructure          |
| Pricing Model   | Pay-per-action                  | Fixed monthly CU cost             |
| Cost per Action | \$0.003                         | Varies by CU utilization          |
| Max Throughput  | 500 actions/second              | 2,000 actions/second per CU       |
| SLA             | 99.9%                           | 99.95%                            |
| Data Retention  | Up to 30 days                   | Up to 90 days                     |
| Best For        | Variable workloads, development | Predictable workloads, enterprise |

## Next steps

Try out the [Durable Functions quickstart sample](quickstart-durable-task-scheduler.md).