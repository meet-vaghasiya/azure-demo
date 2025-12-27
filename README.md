# Nuxt 4 + Azure App Service - CI/CD Project

A fresh Nuxt 4 SSR application with complete CI/CD pipelines for Azure App Service deployment across dev, test, and production environments.

## Project Structure

```
├── .github/
│   └── workflows/          # GitHub Actions CI/CD pipelines
│       ├── deploy-dev.yml  # Auto-deploy on push to 'develop' branch
│       ├── deploy-test.yml # Auto-deploy on push to 'test' branch
│       └── deploy-prod.yml # Auto-deploy on push to 'main' branch
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

### Step 2: Configure GitHub Secrets

Get publish profiles for each environment:

```bash
# Dev environment
az webapp deployment list-publishing-profiles --name nuxt-demo-dev --resource-group rg-nuxt-demo --xml

# Test environment
az webapp deployment list-publishing-profiles --name nuxt-demo-test --resource-group rg-nuxt-demo --xml

# Prod environment
az webapp deployment list-publishing-profiles --name nuxt-demo-prod --resource-group rg-nuxt-demo --xml
```

Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

- `AZURE_WEBAPP_NAME_DEV`: Your dev app service name (e.g., nuxt-demo-dev)
- `AZURE_WEBAPP_NAME_TEST`: Your test app service name (e.g., nuxt-demo-test)
- `AZURE_WEBAPP_NAME_PROD`: Your prod app service name (e.g., nuxt-demo-prod)
- `AZURE_WEBAPP_PUBLISH_PROFILE_DEV`: Dev publish profile XML
- `AZURE_WEBAPP_PUBLISH_PROFILE_TEST`: Test publish profile XML
- `AZURE_WEBAPP_PUBLISH_PROFILE_PROD`: Prod publish profile XML

### Step 3: Branch Strategy

The CI/CD pipelines are triggered by pushes to specific branches:

- **develop** → Deploys to DEV environment
- **test** → Deploys to TEST environment
- **main** → Deploys to PROD environment

Create the branches:

```bash
git checkout -b develop
git push origin develop

git checkout -b test
git push origin test
```

## CI/CD Pipeline Features

### Development (develop branch)
- ✅ Automatic deployment on push
- ✅ Linting (if configured)
- ✅ Build with NODE_ENV=development
- ✅ Deploy to dev App Service

### Test (test branch)
- ✅ Automatic deployment on push
- ✅ Linting (if configured)
- ✅ Tests (if configured)
- ✅ Build with NODE_ENV=test
- ✅ Smoke tests after deployment
- ✅ Deploy to test App Service

### Production (main branch)
- ✅ Automatic deployment on push
- ✅ Linting (if configured)
- ✅ Tests (if configured)
- ✅ Build with NODE_ENV=production
- ✅ Smoke tests after deployment
- ✅ Deploy to prod App Service

## Manual Deployment

You can also trigger deployments manually from GitHub Actions tab using "workflow_dispatch".

## Scripts

```bash
npm run dev          # Start development server
npm run build        # Build for production

# yarn
yarn build

# bun
bun run build
```

Locally preview production build:

```bash
# npm
npm run preview

# pnpm
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
- **CI/CD**: GitHub Actions
- **Infrastructure**: PowerShell script for automated setup

## Support

For issues or questions, refer to:
- [Nuxt Documentation](https://nuxt.com/docs)
- [Azure App Service Documentation](https://docs.microsoft.com/azure/app-service/)
- [GitHub Actions Documentation](https://docs.github.com/actions)
