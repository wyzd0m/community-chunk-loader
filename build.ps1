<#
.SYNOPSIS
    Packages the datapack in pack/ into a distributable .zip.

.EXAMPLE
    .\build.ps1
    .\build.ps1 -Version 1.1.0
#>
param(
    [string]$Version = "1.0.0",
    [string]$OutDir  = "dist"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$src  = Join-Path $root "pack"

if (-not (Test-Path $src)) { throw "Source folder not found: $src" }

# Keep pack.mcmeta's description in step with the version being built.
$mcmetaPath = Join-Path $src "pack.mcmeta"
$mcmeta     = Get-Content $mcmetaPath -Raw | ConvertFrom-Json
$mcmeta.pack.description = "Community Chunk Loader v$Version - per-player persistent chunk loading"
$mcmeta | ConvertTo-Json -Depth 10 | Set-Content $mcmetaPath -Encoding UTF8

$outPath = Join-Path $root $OutDir
if (-not (Test-Path $outPath)) { New-Item -ItemType Directory -Path $outPath | Out-Null }

$zip = Join-Path $outPath "community-chunk-loader-v$Version.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }

# Zip the CONTENTS of pack/, so pack.mcmeta sits at the archive root where
# Minecraft expects it.
Compress-Archive -Path (Join-Path $src "*") -DestinationPath $zip -CompressionLevel Optimal

$size = [math]::Round((Get-Item $zip).Length / 1KB, 1)
Write-Host "Built $zip ($size KB)"
Write-Host "Drop it in <world>/datapacks/ and restart the server."
