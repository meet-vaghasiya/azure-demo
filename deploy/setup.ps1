# Cloud Guru - Create Dev/Test/Prod Environments

$ErrorActionPreference = "Stop"

Write-Host "=== Cloud Guru Azure Setup ===" -ForegroundColor Cyan

# Check login
$account = az account show 2>$null | ConvertFrom-Json
if (-not $account) {
    az login
    $account = az account show | ConvertFrom-Json
}
Write-Host "Logged in as: $($account.user.name)" -ForegroundColor Green

# Get Cloud Guru resource group
$rgs = az group list --query "[].{Name:name, Location:location}" | ConvertFrom-Json
$ResourceGroupName = $rgs[0].Name
$Location = $rgs[0].Location
Write-Host "Using: $ResourceGroupName" -ForegroundColor Green

# Create environments
$results = @()
foreach ($env in @("dev", "test", "prod")) {
    $num = Get-Random -Maximum 9999
    $appName = "nuxt-$env-$num"
    $planName = "$appName-plan"
    
    Write-Host "`nCreating $env..." -ForegroundColor Yellow
    az appservice plan create --name $planName --resource-group $ResourceGroupName --location $Location --sku F1 --is-linux --output none
    az webapp create --name $appName --resource-group $ResourceGroupName --plan $planName --runtime "NODE:20-lts" --output none
    az webapp config appsettings set --name $appName --resource-group $ResourceGroupName --settings NODE_ENV=$env --output none
    
    $results += [PSCustomObject]@{ Env=$env; App=$appName; URL="https://$appName.azurewebsites.net" }
    Write-Host "Created: $appName" -ForegroundColor Green
}

Write-Host "`n=== All Environments Created ===" -ForegroundColor Cyan
$results | Format-Table

Write-Host "`nGitHub Secrets to Add:" -ForegroundColor Yellow
foreach ($r in $results) {
    $e = $r.Env.ToUpper()
    Write-Host "AZURE_WEBAPP_NAME_$e = $($r.App)" -ForegroundColor White
}

Write-Host "`nGet Publish Profiles:" -ForegroundColor Yellow
foreach ($r in $results) {
    Write-Host "az webapp deployment list-publishing-profiles --name $($r.App) --resource-group $ResourceGroupName --xml" -ForegroundColor Gray
}
