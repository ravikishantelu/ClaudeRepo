# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Salesforce DX (SFDX) project named **MCPSetup** using API version 66.0. The default target org is `trailhead`. Source code lives under `force-app/main/` following the standard SFDX source format.

## Deployment & Org Operations

**Always use the Salesforce MCP tools** for all deployment, retrieval, and org operations. Fall back to the `sf` CLI commands below only if the Salesforce MCP is unavailable or returns an error.

### Salesforce MCP (preferred)

Use the available `mcp__Salesforce__*` tools for:
- Deploying metadata (`mcp__Salesforce__deploy_metadata`)
- Retrieving metadata (`mcp__Salesforce__retrieve_metadata`)
- Running SOQL queries (`mcp__Salesforce__run_soql_query`)
- Running Apex tests (`mcp__Salesforce__run_apex_test`)
- Running Code Analyzer (`mcp__Salesforce__run_code_analyzer`)

### Salesforce CLI (fallback only)
```bash
# Deploy all source to org
sf project deploy start

# Deploy specific component
sf project deploy start --source-dir force-app/main/default/lwc/myComponent

# Retrieve metadata from org
sf project retrieve start --manifest manifest/package.xml

# Run Apex anonymously
sf apex run --file scripts/apex/hello.apex

# Run SOQL query
sf data query --file scripts/soql/account.soql

# Create scratch org
sf org create scratch --definition-file config/project-scratch-def.json --alias my-scratch-org

# Open target org
sf org open
```

### Linting & Formatting
```bash
npm run lint                # ESLint for Aura and LWC JS files
npm run prettier            # Format all supported file types
npm run prettier:verify     # Check formatting without writing
```

### Testing
```bash
npm run test                # Run all LWC Jest unit tests
npm run test:unit:watch     # Watch mode
npm run test:unit:debug     # Debug mode
npm run test:unit:coverage  # With coverage report

# Run tests related to a specific file
npx sfdx-lwc-jest -- --testPathPattern=myComponent
```

## Architecture

- **`force-app/main/default/`** — All Salesforce metadata in source format: `lwc/`, `aura/`, `classes/`, `triggers/`, etc.
- **`manifest/package.xml`** — Declares all metadata types for retrieve/deploy operations (ApexClass, AuraDefinitionBundle, LightningComponentBundle, etc.).
- **`config/project-scratch-def.json`** — Scratch org definition (Developer edition, Lightning Experience enabled).
- **`scripts/apex/`** — Anonymous Apex scripts for ad-hoc execution via VS Code or CLI.
- **`scripts/soql/`** — SOQL query files for ad-hoc data queries.

## Pre-commit Hooks

Husky runs `lint-staged` on commit, which automatically:
1. Formats all staged files with Prettier.
2. Lints staged Aura/LWC JS files with ESLint.
3. Runs Jest tests related to staged LWC files (`--bail --findRelatedTests`).

## ESLint Configuration

- **Aura JS** (`**/aura/**/*.js`): `@salesforce/eslint-plugin-aura` recommended + locker rules.
- **LWC JS** (`**/lwc/**/*.js`): `@salesforce/eslint-config-lwc/recommended`.
- **LWC test files** (`*.test.js`): Same as LWC but with `@lwc/lwc/no-unexpected-wire-adapter-usages` disabled.
