<#
.SYNOPSIS
    Moves the 38 MIP portal screenshots from Downloads into the correct
    images subfolder of Microsoft-Purview-Information-Protection.

.DESCRIPTION
    Files downloaded via browser use __ as a folder/filename separator.
    Example:  02-sensitivity-labels__03-create-label-name.avif
    → images\02-sensitivity-labels\03-create-label-name.avif

    Duplicate download suffixes like " (1)", " (2)" are stripped automatically,
    so re-triggered downloads overwrite rather than create separate files.

.EXAMPLE
    cd "C:\Back\SOP-ZTs\Microsoft 365 Infrastructure Portfolio\Microsoft-Purview-Information-Protection"
    .\Move-MipImages.ps1
#>

$Downloads = "$env:USERPROFILE\Downloads"
$ImagesRoot = Join-Path $PSScriptRoot "images"

$files = Get-ChildItem -Path $Downloads -Filter "*__*.avif"

if ($files.Count -eq 0) {
    Write-Host "No files matching *__*.avif found in $Downloads" -ForegroundColor Yellow
    Write-Host "Ensure browser downloads completed before running this script." -ForegroundColor Yellow
    exit
}

$moved = 0
foreach ($f in $files) {
    $parts = $f.BaseName -split '__', 2
    if ($parts.Count -ne 2) { continue }
    $folder = $parts[0]
    # Strip duplicate download suffixes e.g. " (1)", " (2)"
    $cleanName = $parts[1] -replace ' \(\d+\)$', ''
    $filename  = $cleanName + '.avif'
    $destDir   = Join-Path $ImagesRoot $folder
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
    $dest = Join-Path $destDir $filename
    Move-Item -Path $f.FullName -Destination $dest -Force
    Write-Host "Moved: $folder\$filename" -ForegroundColor Green
    $moved++
}

Write-Host ""
Write-Host "Done — $moved screenshots organised into images\ subfolders." -ForegroundColor Cyan
