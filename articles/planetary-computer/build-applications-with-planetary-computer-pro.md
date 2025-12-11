---
title: Building Custom Applications with Microsoft Planetary Computer Pro
description: "Learn the basics of how to connect Microsoft Planetary Computer Pro (Planetary Computer Pro) to applications or build your application on top of Planetary Computer Pro's API services."
author: prasadko
ms.author: prasadkomma
ms.service: planetary-computer-pro
ms.topic: concept-article #Don't change.
ms.date: 04/29/2025

#customer intent: As a developer, I want to understand how to build applications that integrate with Microsoft Planetary Computer Pro so that I can create solutions leveraging geospatial data at scale.
ms.custom:
  - build-2025
---

# Building applications with Microsoft Planetary Computer Pro

Microsoft Planetary Computer Pro offers multiple ways to access, analyze, and visualize large-scale geospatial datasets—from no-code browser experiences to fully custom application development. This article provides an overview of the application development options available with Planetary Computer Pro and guides you to the right approach for your needs.

## Prerequisites

- An Azure account and subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- Access to a Microsoft Planetary Computer Pro [GeoCatalog resource](./deploy-geocatalog-resource.md).

## Application integration approaches

Planetary Computer Pro supports multiple integration approaches depending on your application's requirements. You can build applications that access Planetary Computer Pro's data and services in several ways:

[ ![Diagram illustrating how to build applications with Microsoft Planetary Computer Pro, showing integration points, APIs, and supported workflows.](media/build-apps-diagram.png) ](media/build-apps-diagram.png#lightbox)

### No code: Built-in Explorer

The fastest way to get started is with the built-in **Explorer** web application. Explorer allows you to visualize and interact with geospatial data directly in your browser—no coding required.

By using Explorer, you can:
- Browse collections and view items on an interactive map
- Apply filters and mosaic definitions to refine your data
- Generate code samples for Python integration
- Create collection thumbnails

Once your data is [configured for visualization](./collection-configuration-concept.md), you can [use the Explorer](./use-explorer.md) immediately. Explorer is ideal for data exploration, quick visualization, and sharing insights with stakeholders.

By using [the API services](#custom-development-rest-apis), you can also integrate data in Planetary Computer Pro with Microsoft applications such as [Fabric](/fabric) and [Microsoft Foundry](/azure/ai-foundry/what-is-azure-ai-foundry).

### Desktop GIS applications

For geospatial professionals who prefer working with desktop GIS tools, Planetary Computer Pro integrates with industry-standard applications:

**ArcGIS Pro** — Planetary Computer Pro integrates directly with ESRI ArcGIS Pro, providing a seamless workflow for GIS professionals. By connecting Planetary Computer Pro data directly to ArcGIS Pro, users can:

- Access and analyze large-scale, cloud-hosted geospatial datasets without complex data transfers.
- Use ArcGIS Pro's advanced visualization, editing, and analysis capabilities on authoritative data from Planetary Computer Pro.
- Streamline collaboration by combining enterprise GIS workflows with the latest planetary-scale datasets.
- Accelerate decision-making by integrating cloud-based data with local projects, enabling richer insights and more informed outcomes.

For more information, see [Configure ArcGIS Pro to access a GeoCatalog](./create-connection-arc-gis-pro.md).

**QGIS**: The open-source QGIS desktop application connects via the STAC API for browsing and visualization. QGIS enables direct interaction with STAC collections, so you can visualize, analyze, and style data on the fly. For more information, see [Configure QGIS to access a GeoCatalog resource](./configure-qgis.md).

### Custom development: REST APIs

For full control over your application's functionality, integrate directly with Planetary Computer Pro's REST APIs. By using these APIs, you can build custom web applications, backend services, and automated pipelines.

| API Name      | Description                                                                                   |
|---------------|----------------------------------------------------------------------------------------------|
| STAC API      | Search, discover, and access geospatial data using the SpatioTemporal Asset Catalog (STAC) specification.                   |
| Tiler API     | Serve map tiles and imagery for visualization in web maps and GIS apps.                      |
| SAS API       | Generate secure, time-limited access tokens for sharing geospatial data.                     |
| Ingestion API | Ingest and transform new geospatial datasets into the GeoCatalog.      |

These APIs support [standard authentication through Microsoft Entra ID](/entra/architecture/guide-for-independent-software-developers), enabling secure access to your resources. To integrate your application, use [application authentication](./application-authentication.md). Once you register your app with Microsoft Entra, it can securely use the APIs to access all data inside a GeoCatalog.

For a complete walkthrough of building a browser-based application that uses these APIs, see [Build a web application with Microsoft Planetary Computer Pro](./build-web-application.md).

The [REST API is detailed in the API reference](/rest/api/planetarycomputer).

## Authentication and authorization

All applications that interact with Planetary Computer Pro must authenticate properly by using Microsoft Entra ID. 

### Authentication options and recommendations

| Application Hosting Environment | Access Type Required | Recommended Identity Type        | Explanation                                                                                                                               |
| :------------------------------ | :------------------- | :------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Running on Azure** (VM, App Service, Functions, Container Apps, etc.) | App-Only (Application acts as itself) | Managed Identity (User-assigned recommended) | **Security & Manageability:** Eliminates the need to store and manage credentials (secrets or certificates) in code or configuration. Azure handles credential rotation automatically. User-assigned is preferred for sharing across multiple resources. |
| **Running on Azure** (VM, App Service, Functions, Container Apps, etc.) | Delegated (Application acts on behalf of a user) | Managed Identity (User-assigned recommended) | **Leverages Azure Integration:** Combines the security benefits of Managed Identity for the application itself with standard user authentication flows. Simplifies infrastructure setup within Azure. |
| **Running Outside Azure** (On-premises, other cloud, developer machine) | App-Only (Application acts as itself) | Service Principal | **Standard for External Apps:** The established method for non-Azure applications to authenticate with Microsoft Entra ID. Requires managing credentials (secrets or certificates) securely. |
| **Running Outside Azure** (On-premises, other cloud, developer machine) | Delegated (Application acts on behalf of a user) | Service Principal | **Standard for External Apps:** Enables standard OAuth 2.0 flows for user sign-in and consent for applications outside Azure, using the application's registered identity in Entra ID. |
| **Running Outside Azure (Alternative)** | App-Only or Delegated | Managed Identity | **Brings Azure Benefits:** By hosting the application in an Azure compute service (like a VM or Container App), it can use the enhanced security and manageability of Managed Identities, avoiding credential management even though the *origin* might be considered non-Azure. |

For detailed authentication guidance, see [Set up application authentication for Planetary Computer Pro](./application-authentication.md).

## Choose your integration path

Select the approach that best fits your use case:

| Use case | Recommended approach | Get started |
|----------|---------------------|-------------|
| **Explore data without coding** | Use the built-in Explorer web application | [Use the Explorer](./use-explorer.md) |
| **Build a custom web application** | Browser-based app with JavaScript or TypeScript using MSAL.js | [Build a web application](./build-web-application.md) |
| **Desktop GIS with ArcGIS Pro** | Connect ArcGIS Pro directly to GeoCatalog | [Configure ArcGIS Pro](./create-connection-arc-gis-pro.md) |
| **Desktop GIS with QGIS** | Connect QGIS to GeoCatalog via STAC | [Configure QGIS](./configure-qgis.md) |
| **Batch processing on Azure** | Run processing jobs with Azure Batch and managed identity | [Use Azure Batch](./azure-batch.md) |
| **Backend/server-side integration** | Python applications using managed identity or service principal | [Configure application authentication](./application-authentication.md) |

## Related content

- [Build a web application with Microsoft Planetary Computer Pro](./build-web-application.md)
- [Use Azure Batch with Microsoft Planetary Computer Pro](./azure-batch.md)
- [Connect ArcGIS Pro to Microsoft Planetary Computer Pro](./create-connection-arc-gis-pro.md)
- [Configure QGIS to access a GeoCatalog resource](./configure-qgis.md)
- [Manage access to Microsoft Planetary Computer Pro](./manage-access.md)
- [Microsoft Planetary Computer Pro REST API reference](/rest/api/planetarycomputer)
