---
title: Agent Builder scenarios in Azure SRE Agent
description: Learn how you can use Agent Builder in Azure SRE Agent to connect observability tools, manage knowledge bases, configure specialized sub-agents, and automate operational workflows using triggers and scheduled tasks.
author: craigshoemaker
ms.author: cshoe
ms.topic: how-to
ms.date: 11/05/2025
ms.service: azure-sre-agent
---

## Agent Builder scenarios in Azure SRE Agent

Agent Builder in Azure SRE Agent enables you to design, configure, and extend intelligent operational agents tailored to your organization's needs. With Agent Builder, you can seamlessly integrate data sources, manage and enrich knowledge bases, create specialized sub-agents, and automate workflows by using triggers and scheduled tasks. This article explores common scenarios and configuration patterns to help you maximize the value of Agent Builder for your site reliability engineering (SRE) operations.

### Bring your own data sources (observability tools)

Agent Builder enables you to connect your existing observability infrastructure to enhance your agents' capabilities.

#### Supported data connectors

SRE Agent supports the following data connectors that interface with Agent Builder:

- **Azure Monitor**: Integrate with Azure Monitor workspaces for metrics and alerting data.
- **Model Context Protocol (MCP)**: Connect to external data sources and APIs.
- **GitHub**: Connect to repositories for code analysis and deployment history.
- **Azure DevOps**: Integrate with work items and pipeline data.

#### Configuration process

Use the following steps to configure your agent.

1. Navigate to data connectors.

    In Agent Builder, select the **Settings > Connectors** tab.

1. Choose connector type.

    Select from available connector options.

1. Provide connection details.

    Enter connection strings, authentication credentials, and scope settings.

1. Test the connection.

    Validate connectivity and permissions before saving.

1. Associate with agents.

    Link data sources to specific agents based on their operational focus.

### File upload and knowledge base management

Enhance your agents' knowledge by uploading organizational documentation, runbooks, and procedural guides.

#### Supported file types

- **Documents**: PDF, DOCX, TXT files containing operational procedures

- **Runbooks**: Step-by-step incident resolution guides

- **Configuration files**: YAML, JSON configurations for reference

- **Example knowledge articles**: Internal documentation and best practices

#### File management workflow

1. Access the knowledge base by going to the **Settings > Knowledge Base > Files** tab.

1. Upload files by dragging and dropping your files or browsing to select files (maximum 50 MB per file).

1. Organize content by adding tags and descriptions for better searchability.

1. Enable agent access by configuring which agents can access specific knowledge sources.

1. Monitor usage by tracking how agents utilize uploaded knowledge in their responses.

> [!NOTE]
> Uploaded files are automatically indexed and made searchable by your agents. The system supports up to 1,000 files per agent instance.

### Build your sub-agents

Create specialized sub-agents that focus on specific operational domains or technical areas.

#### Sub-agent types

Examples of specialized agents include:

- **Database specialists**: Focused on database performance and connectivity diagnostics

- **Network analysts**: Specialized in connectivity and performance issues

- **Security investigators**: Trained on security incidents and compliance checks

- **Application monitors**: Experts in specific application stacks or frameworks

#### Sub-agent configuration

- **Define agent purpose**: Clearly specify the agent's operational focus and expertise

- **Select tools**: Choose relevant system tools and data connectors for the agent's domain

- **Customize instructions**: Provide domain-specific guidance and operational procedures

- **Set handoff rules**: Configure how the sub-agent escalates to human operators or other agents

- **Test capabilities**: Validate the sub-agent's performance on domain-specific scenarios

Example sub-agent configuration:

```yml
agent: 
  name: "WebApp-Performance-Specialist" 
  description: "Specialized agent for web application performance analysis" 
  instructions: | 
    You are a specialist in diagnosing web application performance and reliability issues. 

    Focus on HTTP response codes, memory usage patterns, and application dependencies  

    when investigating incidents. 
  tools: 
    - "AzureMonitorQuery" 
    - "HttpHealthCheck"  
    - "ResourceHealthStatus" 
    - "DeploymentHistory" 
  handoff_conditions: 
    - "Infrastructure-level issues requiring network analysis" 
    - "Database performance issues requiring specialized expertise" 
    - "Security incidents requiring specialized investigation" 
```

### Extended tools (built-in data connectors and MCP tools)

Expand your agents' capabilities with a comprehensive toolkit for operational tasks.

#### Built-in system tools

- **Azure-specific tools**:

  - **Resource management**: Scale, restart, and configure Azure resources
  
  - **Azure Monitor queries**: Execute queries against Azure Monitor logs and metrics
  
  - **Health checks**: Assess resource health and availability status
  
  - **Deployment analysis**: Review recent changes and deployment history

- **Generic operational tools**:

  - **HTTP requests**: Test endpoint availability and response times

  - **File operations**: Read configuration files and logs

  - **Data transformation**: Process and analyze operational data

  - **Notification systems**: Send alerts and status updates

#### Model Context Protocol (MCP) integration

MCP enables your agents to connect with external systems and APIs beyond Azure's native capabilities.

- **MCP connection setup**:

  - **Configure MCP server**: Set up the external service endpoint
  
  - **Authentication**: Provide necessary credentials and access tokens
  
  - **Tool discovery**: Import available tools and functions from the MCP server
  
  - **Agent assignment**: Associate MCP tools with specific agents

- **Supported MCP scenarios**

  - **Custom APIs**: Internal tools and services specific to your organization
  
  - **Third-party integrations**: ServiceNow, Jira, Slack, and other operational tools
  
  - **Specialized databases**: Time-series databases, document stores, and analytics platforms
  
  - **Monitoring systems**: Grafana, Prometheus, and custom dashboards

> [!IMPORTANT]
> MCP connections require proper network configuration and authentication.

### Triggers (incidents and scheduled tasks)

Automate your operational workflows with intelligent triggering mechanisms.

#### Incident triggers

Automatically activate agents when specific incident conditions are met by adjusting the following configuration options:

- **Platform integration**: Azure Monitor, PagerDuty, ServiceNow, or custom webhook sources

- **Filtering criteria**: Service impact, severity level, incident type, and custom matching rules

- **Response timing**: Immediate activation or delayed response based on incident duration

- **Escalation paths**: Define handoff procedures when automated resolution fails

Example incident trigger:

```yml
trigger: 
  name: "High-CPU-Alert-Response" 
  platform: "AzureMonitor" 
  conditions: 
    - metric: "cpu_percent" 
    - threshold: "> 90%" 
    - duration: "5 minutes" 
    - service: "production-webapp" 
  response: 
    agent: "WebApp-Performance-Specialist" 
    mode: "review" 
    timeout: "30 minutes" 
```

#### Scheduled tasks

Create recurring operational activities that run automatically:

- **Schedule types**:

  - **Cron expressions**: Use standard cron syntax for precise timing
  
  - **Preset intervals**: Hourly, daily, weekly, or monthly execution
  
  - **Natural language**: Describe schedules in plain English (for example, "every weekday at 9 AM")

- **Common scheduled task patterns**:

  - **Health summaries**: Daily environment status reports

  - **Compliance scans**: Weekly security and policy validation

  - **Performance reviews**: Monthly resource utilization analysis

  - **Maintenance checks**: Quarterly system health assessments

Example scheduled task:

```yml
scheduled_task: 
 name: "Daily-Environment-Health-Report" 
  schedule: "0 9 * * 1-5"  # Weekdays at 9 AM 
  timezone: "UTC" 
  instructions: | 
    Generate a comprehensive health report covering: 
    - Resource utilization trends (CPU, memory, storage) 
    - Active alerts and their resolution status 
    - Recent deployment impacts on performance 
    - Recommendations for optimization 
  outputs: 
    - email: "ops-team@company.com" 
    - teams_channel: "operations-reports" 
```

## Related content

- [Agent Builder overview](./agent-builder-overview.md)
