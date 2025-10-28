---
title: Use the Dedicated SKU for Azure Functions Durable Task Scheduler (preview)
description: Learn about how the Dedicated SKU in Azure Functions Durable Task Scheduler.
ms.topic: conceptual
ms.date: 10/22/2025
ms.author: franlanglois
---
# Azure Functions Durable Task Scheduler Pricing and SKU Options

The Durable Task Scheduler offers two pricing models to accommodate different workload requirements, usage patterns, and preferred billing models:

- Dedicated
- Consumption (preview)

You can also use the Durable Task Scheduler with [any of the Functions SKUs](../../functions-scale.md).

In this article, you learn about actions, the available SKU options, and their pricing structures.

## What is an action?

An action is one of the fundamental billing units in the Durable Task Scheduler, representing a function invocation triggered by the Durable Task Scheduler. Each time a function runs, an action from the Durable Task Scheduler told it to.

The following functions are each triggered by one action:

- Starting an orchestration or suborchestration  
- Starting an activity 
- Completing a timer 
- Triggering an external event
- Executing an entity operation 
- Suspending, resuming, or terminating an orchestration
- Processing the result of an activity, entity call, entity lock, or suborchestration 

### Actions breakdown

Let's say you have an orchestration that calls three different activities. 

:::image type="content" source="media/durable-task-scheduler-dedicated-sku/function-code-image.png" alt-text="Screenshot of orchestration code showing function calls and action breakdown.":::

In this example, you can see how Durable Task Scheduler processes each action:

- Orchestrator start (`RunOrchestrator`) uses one action
- Activity 1 (`(nameof(SayHello), "Tokyo")`) uses two actions:
   - Scheduling the activity
   - Processing the result
- Activity 2 (`(nameof(SayHello), "Seattle")`) uses two actions:
   - Scheduling the activity
   - Processing the result
- Activity 3 (`(nameof(SayHello), "London")`) uses two actions:
   - Scheduling the activity
   - Processing the result

### Calculating the number of actions

You can use a formula to calculate the number of actions per orchestration:

> (Activity Count \* 2) + 1 = Total Number of Actions Per Orchestration

In the previous example, the total calculation would be: 

> 1 (orchestration) + Activity 1 + Activity 2 + Activity 3 = 7 actions

> [!NOTE]
> _Timers_ and _Events Raised_ are also considered activities.

## Available SKUs

Durable Task Scheduler offers two SKU options: Dedicated and Consumption (preview).

|   | Consumption SKU (preview)       | Dedicated SKU                     |
| - | ------------------------------- | --------------------------------- |
| Infrastructure  | Multitenant                     | Dedicated Infrastructure          |
| Pricing Model   | Pay-per-action                  | Fixed monthly CU cost             |
| Cost per Action | $0.003                         | Varies by CU utilization          |
| Max Throughput  | 500 actions/second              | 2,000 actions/second per CU       |
| SLA             | 99.9%                           | 99.95%                            |
| Data Retention  | Up to 30 days                   | Up to 90 days                     |
| Best For        | Variable workloads, development | Predictable workloads, enterprise |

### SKU support

Since the Consumption SKU is currently in preview, use the following table to understand what is supported. 

| Experience | Language | Dedicated SKU | Consumption SKU |
| ---------- | -------- | ------------- | --------------- |
| Durable Task Scheduler for Durable Functions | C#<br>Python<br>JavaScript<br>PowerShell<br>Java| Generally available<br>Generally available<br>Generally available<br>Generally available<br>Generally available | Preview<br>Preview<br>Preview<br>Preview<br>Preview |
| Durable Task SDKs | C#<br>Python<br>Java| Generally available<br>Preview<br>Preview | Preview<br>Preview<br>Preview |

#### [Dedicated SKU](#tab/dedicated)

The Dedicated SKU provides predictable performance and pricing through preallocated Compute Units (CUs). You can purchase up to three CUs. 

#### Key features

| Feature | Description |  
| - | - |
| Dedicated infrastructure | Runs on dedicated compute resources |
| Predictable performance | Guaranteed throughput and consistent latency |
| Enterprise SLA | 99.95% uptime guarantee |  
| Data retention | Up to 90 days of orchestration data retention |  
| Custom scaling | Configure CUs based on your specific throughput or availability requirements |  

#### Pricing and limits

| Pricing | Description |  
| - | - |
| Base cost | Fixed monthly cost per Compute Unit (CU) (regional pricing) |
| Capacity | Each CU supports up to **2,000 actions** per second |
| Storage | Each CU support up to 50GB of orchestration data |  
| Minimum | 1 CU required per deployment |  

#### High availability and zone redundancy

For high availability and zone redundancy, a minimum of three CUs is required to distribute workloads across multiple scheduler instances.

#### Capacity Unit planning examples

Learn more about the cost calculation with the following capacity planning scenarios. 

##### Five activities example

You have an orchestration with 5 activities, plus error handling, and averaging 12 actions per orchestration (orchestrator invocations + activity invocations). Let's calculate running 20 million orchestrations per month.

- Monthly actions: 20,000,000 × 12 = 240,000,000 actions 

- Actions per second: 240,000,000 ÷ 2,628,000 ≈ 91 actions/second

- Required CUs: 91 ÷ 2,000 = 0.046 → **1 CU sufficient**

##### Large enterprise example

A large enterprise runs 500 million complex orchestrations monthly, with an average of 15 actions per orchestration (multiple activities with orchestrator coordination). 

Calculation:

- Monthly actions: 500 million × 13 = 6.5 billion actions

- Actions per second: 6.5 billion ÷ 2,628,000 ≈ 2,854 actions/second

- Required CUs: 2,473 ÷ 2,000 = 1.23 → **2 CUs sufficient**

##### SaaS platform example

A Software as a Service (SaaS) platform supports 800 million orchestrations monthly, each with an average of 15 actions (for example, user interactions, background processing, and external API calls).

Calculation:

- Monthly actions: 800 million × 15 = 12 billion actions

- Actions per second: 12 billion ÷ 2,628,000 ≈ 4,567 actions/second

- Required CUs: 4,567 ÷ 2,000 = 2.28, or **3 CUs sufficient**

#### [Consumption SKU](#tab/consumption)

The Consumption SKU offers a pay-as-you-use model, ideal for variable workloads and development scenarios.

#### Key Features

| Feature | Description |  
| - | - |
| Pay-Per-Use | Only pay for actions dispatched |
| No upfront costs | No minimum commitments or base fees |
| SLA | 99.9% uptime guarantee |  
| Data retention | 30-day maximum retention of orchestration data |  

#### Pricing and Limits

| Pricing | Description |  
| - | - |
| Cost | $0.03 per action dispatched |
| Throughput | Up to 500 actions per second |

#### Consumption SKU Examples

Learn more about the cost calculation with the following capacity planning scenarios. 

##### Development environment example

A development team is testing simple orchestrations, each with three actions (using the "Hello City" pattern), and runs 10,000 orchestrations per month.

Calculation:

- Monthly actions: 10,000 × 3 = 30,000 actions

- Cost: 30,000 × $0.003 = **$90/month**

##### Workloads with bursts example

An e-commerce application experiences dynamic workload scaling during promotional sales events, especially on weekends. It uses an orchestration comprising seven total actions, which executes approximately 20,000 times per month.

Calculation:

- Monthly actions: 20,000  × 7 = 140,000 actions

- Cost: 140,000 × $0.003 = **$420/month**

## Next steps

- View [throughput performance benchmarks](./durable-task-scheduler-work-item-throughput.md)
- Try out the [Durable Functions quickstart sample](quickstart-durable-task-scheduler.md).