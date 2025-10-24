# Azure Documentation Copilot Instructions

## Project Overview
This is the Microsoft Azure documentation repository using DocFX for static site generation. The documentation covers the entire Azure ecosystem with hundreds of services organized under `articles/` folders.

## Architecture & Structure

### Core Components
- **DocFX Configuration**: `docfx.json` defines build process, metadata mappings, content sources, and special handling for grouped services (iot-edge, cyclecloud, migrate)
- **Article Organization**: `articles/[service-name]/` - each Azure service has its own folder with documentation
- **Shared Content**: `includes/` contains reusable snippets used across multiple articles via `[!INCLUDE [file.md]]` syntax
- **Navigation**: `bread/toc.yml` defines breadcrumb navigation hierarchy across all Azure services
- **Metadata Schema**: Complex per-service metadata mapping in docfx.json for authors, reviewers, service identifiers, feedback URLs

### Content Patterns
- **Article Types**: Overview, quickstart, tutorial, how-to, reference - identified by `ms.topic` metadata
- **Metadata Standards**: Required frontmatter includes title, description, author, ms.author, ms.service, ms.date
- **Cross-References**: Heavy use of includes for common procedures, warnings, prerequisites
- **Code Examples**: Multi-language tabs using zone pivots, inline code blocks with language identifiers

## Key Workflows

### Content Creation
1. Create article in appropriate `articles/[service]/` folder
2. Add required YAML frontmatter with service-specific metadata
3. Use includes for common content (`[!INCLUDE [filename.md]]`)
4. Reference shared resources in `includes/` for reusable components
5. Follow naming conventions: `overview-*.md`, `quickstart-*.md`, `how-to-*.md`

### Build & Validation
- DocFX builds from `docfx.json` configuration
- Content validation through metadata schema enforcement
- Multi-group builds for special services (migrate, iot-edge, cyclecloud)
- Resource files (images) processed separately from content files

### Service-Specific Patterns
- **Feedback URLs**: Mapped per service in docfx.json `feedback_product_url`
- **Author Assignment**: Automatic author mapping by file path in docfx.json `author` section
- **Service Limits**: Common include pattern for service-specific limitations
- **Breadcrumbs**: Defined in bread/toc.yml for consistent navigation

## Critical Conventions

### File Organization
```
articles/
├── [service-name]/
│   ├── overview-*.md (service overviews)
│   ├── quickstart-*.md (getting started)
│   ├── how-to-*.md (task-oriented guides)
│   ├── tutorials/ (multi-step learning)
│   └── includes/ (service-specific includes)
```

### Metadata Requirements
- `ms.service`: Must match docfx.json service mappings
- `ms.author`: GitHub username (maps to real name via docfx.json)
- `author`: Display name for contributor attribution
- `ms.topic`: Article type (overview, quickstart, how-to, tutorial, reference)

### Include Patterns
- Service limits: `[!INCLUDE [service-limits.md](includes/service-limits.md)]`
- Prerequisites: Common setup steps across services
- Code snippets: Language-specific implementations
- Cleanup sections: Resource deletion instructions

### Cross-Service Integration
- Services often reference each other (App Service + Functions + Storage)
- Common authentication patterns shared via includes
- Unified CLI/PowerShell/Portal instructions where applicable

## Important Files to Reference
- `docfx.json`: Master configuration for metadata, authors, services, limits
- `bread/toc.yml`: Navigation structure
- `articles/index.yml`: Main Azure documentation hub
- `includes/`: Reusable content library
- Service-specific includes folders for common procedures

## Coding Best Practices
- Always include proper YAML frontmatter with required metadata
- Use includes for repeated content across articles
- Follow existing service patterns for consistency
- Reference the docfx.json mappings for author and service metadata
- Use zone pivots for multi-language/multi-tool scenarios
- Include proper cleanup sections for tutorials and quickstarts

This repository emphasizes content reuse, consistent metadata, and service-specific organization while maintaining unified Azure documentation standards.