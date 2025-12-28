# Cloud Guru Azure Setup Guide

## Important: Cloud Guru Limitations
Cloud Guru playgrounds have restricted permissions. You must create resources manually through the Azure Portal.

## Step 1: Create Resources in Azure Portal

### 1.1 Create Resource Group
1. Go to Azure Portal: https://portal.azure.com
2. Search for "Resource Groups"
3. Click "+ Create"
4. Name: `rg-nuxt-demo`
5. Region: `East US`
6. Click "Review + Create" → "Create"

### 1.2 Create App Service Plan
1. Search for "App Service plans"
2. Click "+ Create"
3. Resource Group: `rg-nuxt-demo`
4. Name: `nuxt-demo-plan`
5. Operating System: **Linux**
6. Region: `East US`
7. Pricing Tier: **F1 (Free)** - Click "Change size" → Dev/Test → F1
8. Click "Review + Create" → "Create"

### 1.3 Create Web App
1. Search for "App Services"
2. Click "+ Create" → "Web App"
3. Resource Group: `rg-nuxt-demo`
4. Name: `nuxt-demo-app` (or choose your unique name)
5. Publish: **Code**
6. Runtime stack: **Node 20 LTS**
7. Operating System: **Linux**
8. Region: `East US`
9. App Service Plan: Select `nuxt-demo-plan` (the one you just created)
10. Click "Review + Create" → "Create"

## Step 2: Get Publish Profile

### Option A: From Azure Portal
1. Go to your Web App (`nuxt-demo-app`)
2. Click "Download publish profile" in the overview page
3. Open the downloaded `.PublishSettings` file in a text editor
4. Copy ALL the XML content

### Option B: Using Azure CLI (if you have permissions)
```bash
az webapp deployment list-publishing-profiles \
  --name nuxt-demo-app \
  --resource-group rg-nuxt-demo \
  --xml
```

## Step 3: Configure GitHub Secrets

1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"

Add these 2 secrets:

| Secret Name | Value |
|------------|-------|
| `AZURE_WEBAPP_NAME` | `nuxt-demo-app` (your app name) |
| `AZURE_WEBAPP_PUBLISH_PROFILE` | (paste entire XML content) |

## Step 4: Update Workflow File

The workflow is already configured to use a single app. Just make sure the secret names match.

## Step 5: Deploy

```bash
git add .
git commit -m "Setup Azure deployment"
git push origin main
```

This will trigger the GitHub Action and deploy your Nuxt app to Azure!

## Verify Deployment

Visit: `https://nuxt-demo-app.azurewebsites.net`

(Replace `nuxt-demo-app` with your actual app name)

## Cost

- **F1 Free Tier**: $0/month
- Includes: 60 minutes/day compute, 1GB storage, 165MB memory
- Perfect for testing and demos!
