# Azure App Service Setup Script for Nuxt 4 Application
# This script creates App Service resources for dev, test, and prod environments

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$Location = "eastus",
    
    [Parameter(Mandatory=$true)]
    [string]$AppNamePrefix
)

$ErrorActionPreference = "Stop"

Write-Host "Starting Azure Resource Deployment..." -ForegroundColor Green
Write-Host "Resource Group: $ResourceGroupName" -ForegroundColor Cyan
Write-Host "Location: $Location" -ForegroundColor Cyan
Write-Host "App Name Prefix: $AppNamePrefix" -ForegroundColor Cyan

# Login check
$account = az account show 2>$null | ConvertFrom-Json
if (-not $account) {
    Write-Host "Please login to Azure..." -ForegroundColor Yellow
    az login
}

Write-Host "`nCurrent Subscription: $($account.name)" -ForegroundColor Cyan

# Create Resource Group
Write-Host "`nCreating Resource Group..." -ForegroundColor Green
az group create --name $ResourceGroupName --location $Location

# Define environments
$environments = @("dev", "test", "prod")

foreach ($env in $environments) {
    Write-Host "`n=== Setting up $env environment ===" -ForegroundColor Magenta
    
    $appServicePlanName = "$AppNamePrefix-plan-$env"
    $appServiceName = "$AppNamePrefix-$env"
    
    # Create App Service Plan
    Write-Host "Creating App Service Plan: $appServicePlanName" -ForegroundColor Yellow
    
    if ($env -eq "prod") {
        # Production: Standard tier with better performance
        az appservice plan create `
            --name $appServicePlanName `
            --resource-group $ResourceGroupName `
            --location $Location `
            --sku S1 `
            --is-linux
    } else {
        # Dev/Test: Basic tier for cost savings
        az appservice plan create `
            --name $appServicePlanName `
            --resource-group $ResourceGroupName `
            --location $Location `
            --sku B1 `
            --is-linux
    }
    
    # Create App Service
    Write-Host "Creating App Service: $appServiceName" -ForegroundColor Yellow
    az webapp create `
        --name $appServiceName `
        --resource-group $ResourceGroupName `
        --plan $appServicePlanName `
        --runtime "NODE:20-lts"
    
    # Configure App Service settings
    Write-Host "Configuring App Service settings..." -ForegroundColor Yellow
    az webapp config appsettings set `
        --name $appServiceName `
        --resource-group $ResourceGroupName `
        --settings `
            NODE_ENV=$env `
            WEBSITE_NODE_DEFAULT_VERSION="~20" `
            SCM_DO_BUILD_DURING_DEPLOYMENT=true `
            ENABLE_ORYX_BUILD=true
    
    # Enable logging
    az webapp log config `
        --name $appServiceName `
        --resource-group $ResourceGroupName `
        --application-logging filesystem `
        --detailed-error-messages true `
        --failed-request-tracing true `
        --web-server-logging filesystem
    
    # Get deployment URL
    $appUrl = "https://$appServiceName.azurewebsites.net"
    Write-Host "App Service created: $appUrl" -ForegroundColor Green
}

Write-Host "`n=== Deployment Complete ===" -ForegroundColor Green
Write-Host "`nNext Steps:" -ForegroundColor Cyan
Write-Host "1. Set up GitHub secrets for CI/CD:" -ForegroundColor White
Write-Host "   - AZURE_CREDENTIALS (Service Principal JSON)" -ForegroundColor Gray

foreach ($env in $environments) {
    $appServiceName = "$AppNamePrefix-$env"
    Write-Host "`n2. Get publish profile for $env environment:" -ForegroundColor White
    Write-Host "   az webapp deployment list-publishing-profiles --name $appServiceName --resource-group $ResourceGroupName --xml" -ForegroundColor Gray
}

Write-Host "`n3. Add the publish profiles as GitHub secrets:" -ForegroundColor White
Write-Host "   - AZURE_WEBAPP_PUBLISH_PROFILE_DEV" -ForegroundColor Gray
Write-Host "   - AZURE_WEBAPP_PUBLISH_PROFILE_TEST" -ForegroundColor Gray
Write-Host "   - AZURE_WEBAPP_PUBLISH_PROFILE_PROD" -ForegroundColor Gray

Write-Host "`nResource URLs:" -ForegroundColor Cyan
foreach ($env in $environments) {
    $appServiceName = "$AppNamePrefix-$env"
    Write-Host "  $env: https://$appServiceName.azurewebsites.net" -ForegroundColor White
}
