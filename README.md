# Nuxt 4 + Azure App Service

A fresh Nuxt 4 SSR application for Azure App Service deployment.

## Project Structure

```
├── deploy/
│   └── azure-setup.ps1     # PowerShell script to create Azure resources
├── app/
│   └── app.vue             # Main Nuxt app component
├── public/                 # Static assets
├── web.config              # IIS/Azure App Service configuration
├── nuxt.config.ts          # Nuxt configuration
└── package.json            # Dependencies and scripts
```

## Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Run Locally

```bash
npm run dev
```

Visit http://localhost:3000

## Azure Deployment Setup

### Step 1: Create Azure Resources

Run the PowerShell script to create App Services for all environments:

```powershell
npm run deploy:setup
```

Or run directly with parameters:

```powershell
pwsh ./deploy/azure-setup.ps1 -ResourceGroupName "your-rg-name" -Location "eastus" -AppNamePrefix "your-app-name"
```

**Example:**
```powershell
pwsh ./deploy/azure-setup.ps1 -ResourceGroupName "rg-nuxt-demo" -Location "eastus" -AppNamePrefix "nuxt-demo"
```

This creates:
- Resource Group
- 3 App Service Plans (dev: B1, test: B1, prod: S1)
- 3 App Services (nuxt-demo-dev, nuxt-demo-test, nuxt-demo-prod)

### Step 2: Deploy to Azure

Deploy your application manually using Azure CLI or the Azure Portal.

## Scripts

```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run preview      # Preview production build locally
npm run start        # Start production server (used by Azure)
npm run lint         # Run linting (placeholder)
npm run test         # Run tests (placeholder)
npm run deploy:setup # Run Azure setup script
```

## Environment Variables

Copy [.env.example](.env.example) to `.env.local` for local development:

```bash
cp .env.example .env.local
```

## Azure App Service Configuration

The [web.config](web.config) file is automatically included in deployments and configures:
- IIS node handler for the Nuxt server
- URL rewriting for SSR
- Static file serving
- Logging configuration

## Tech Stack

- **Framework**: Nuxt 4 (Vue 3)
- **Rendering**: SSR (Server-Side Rendering)
- **Runtime**: Node.js 20 LTS
- **Hosting**: Azure App Service (Linux)
- **Infrastructure**: PowerShell script for automated setup

## Support

For issues or questions, refer to:
- [Nuxt Documentation](https://nuxt.com/docs)
- [Azure App Service Documentation](https://docs.microsoft.com/azure/app-service/)
