---
title: Data cubes in Microsoft Planetary Computer Pro overview
description: Learn about data cube concepts and data cube enrichment for STAC assets in Microsoft Planetary Computer Pro. This article explains how to enable and disable data cube enrichment.
author: tanyamarton
ms.author: tanyamarton
ms.service: planetary-computer-pro
ms.topic: concept-article
ms.date: 04/24/2025

ms.custom:
  - build-2025
# customer intent: As a GeoCatalog User I want to undertand how Data Cubes are supported in Microsoft Planetary Computer Pro so that I can ingest, manage, and visualize data cube data formats.
---
# Data cubes in Microsoft Planetary Computer Pro

As mentioned in [Supported Data Types](./supported-data-types.md), Microsoft Planetary Computer Pro supports ingestion, cloud optimization, and visualization of data cube files in NetCDF, HDF5, and GRIB2 formats. Though complex and historically cumbersome on local storage, these assets are optimized for cloud environments with Planetary Computer Pro, further empowering them as efficient tools to structure and store multidimensional data like satellite imagery and climate models.

## Ingestion of data cubes

Data cube files can be ingested into Planetary Computer Pro in the same way as other raster data types. As with other date formats, assets and associated Spatio Temporal Asset Catalog (STAC) Items must first be stored in Azure Blob Storage. Unlike other two-dimensional raster assets, however, additional cloud optimization steps will occur upon ingestion of certain data cube formats (NetCDF and HDF5).

> [!NOTE]
> GRIB2 data will be ingested in the same way as other two-dimensional raster data (with no additional cloud optimization steps), as they are essentially a collection of 2D rasters with an associated index file that references the data efficiently in cloud environments.

## Cloud optimization of data cubes

When a STAC Item containing NetCDF or HDF5 assets is ingested, the assets are cloud optimized, not by transforming the data itself, but rather by generation of reference files that enable more efficient data access.

### Cloud optimization via Kerchunk manifests  

Unlike 2D raster data that is transformed into cloud optimized geotiffs, data cube assets are optimized by generation of chunk reference files, or Kerchunk manifests. Kerchunk is an open-source Python library that creates these chunk manifests, or JSON files that describe the structure of the data cube and its chunks using Zarr-style chunk keys that map to the byte ranges in the original file where those chunks reside. Once generated, the Kerchunk files are stored in blob storage alongside the assets, and the STAC items are enriched to include references to these manifests, optimizing data access for cloud environments.

### STAC item enrichment  

Data cube enrichment is **enabled** for applicable assets in the STAC item JSON. For each asset, enrichment is triggered if both of the following conditions are met:  

* The asset format is one of the following types:
    - `application/netcdf`
    - `application/x-netcdf`
    - `application/x-hdf5`
* The asset has a `roles` field that includes either `data` or `visual` within its list of roles. 

If these conditions are met, a **Kerchunk manifest** (`assetid-kerchunk.json`) is generated in blob storage alongside the asset. 

> [!NOTE]
> The asset format type`application/x-hdf` often corresponds to HDF4 assets. GeoCatalog ingestion doesn't currently support creating virtual kerchunk manifests for HDF4 due to its added complexity and multiple variants.

### Data cube enrichment modifies the STAC item JSON  

For each enriched asset within the **STAC item JSON**, the following fields are added:  

- `msft:datacube_converted: true` – Indicates that enrichment was applied. 
- `cube:dimensions` – A dictionary listing dataset dimensions and their properties. 
- `cube:variables` – A dictionary describing dataset variables and their properties. 


### Disabling data cube enrichment  

To **disable enrichment** for an asset, remove `data` and `visual` from the asset’s `roles` list in the STAC item JSON before ingestion.

### Handling enrichment failures  

If Data cube enrichment fails, the asset can be **re-ingested** with enrichment disabled by updating the STAC item JSON to exclude the `data` or `visual` role before retrying ingestion.

### Why enable data cube enrichment?  

Enabling Data cube enrichment improves **data access performance**, especially for visualization workflows. When a Kerchunk manifest is present, it allows **faster access** compared to loading the entire dataset file. 

### Faster dataset access for data APIs and visualization with Kerchunk  

The Data Explorer and tiling APIs preferentially use the **Kerchunk manifest (`.json`)** for data read operations if one exists in the same blob storage directory as the original asset. Instead of opening the full `.nc` file, we use a **Zarr with reference files** to access only the necessary data. 

Reading data using a chunked, reference-based approach is faster because it avoids reading the entire file into memory.

## Related content

- [Access STAC collection data cube assets with a collection-level SAS token](./get-collection-sas-token.md)

  
