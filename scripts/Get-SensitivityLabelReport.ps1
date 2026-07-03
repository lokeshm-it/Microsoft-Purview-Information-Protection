#Requires -Modules @{ModuleName='ExchangeOnlineManagement'; ModuleVersion='3.0.0'}
<#
.SYNOPSIS
    Generates a comprehensive report of Microsoft Purview sensitivity label configuration
    and labeling activity.

.DESCRIPTION
    This script produces three reports:
    1. Label Inventory Report  — all sensitivity labels with protection settings
    2. Policy Configuration Report — all label policies with scope and settings
    3. Auto-Labeling Report    — all auto-labeling policies and rules
    4. Activity Summary        — label application activity from compliance logs

    Reports are exported as CSV files to the specified output directory.

.PARAMETER OutputPath
    Directory where CSV reports will be saved.
    Default: current directory

.PARAMETER DaysBack
    Number of days of activity data to include in the Activity Summary.
    Default: 30

.PARAMETER IncludeActivityReport
    Switch to include the Activity Explorer report (requires additional time).
    Note: Full activity data requires compliance audit log access.

.EXAMPLE
    .\Get-SensitivityLabelReport.ps1 -OutputPath "C:\Reports\Purview" -DaysBack 30

.EXAMPLE
    .\Get-SensitivityLabelReport.ps1 -IncludeActivityReport

.NOTES
    Author  : Lokesh Karnam
    Purpose : Microsoft 365 Portfolio — Microsoft Purview Information Protection
    Tenant  : Patchthecloud.onmicrosoft.com (lab)
    Module  : ExchangeOnlineManagement (Security & Compliance PowerShell)

    SECURITY: Never commit credentials or report output files to git.
              The .gitignore in this repo excludes CSV exports.
#>

[CmdletBinding()]
param (
    [Parameter()]
    [string]$OutputPath = (Get-Location).Path,

    [Parameter()]
    [ValidateRange(1, 90)]
    [int]$DaysBack = 30,

    [Parameter()]
    [switch]$IncludeActivityReport
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ── Functions ─────────────────────────────────────────────────────────────────

function Write-Log {
    param([string]$Message, [ValidateSet('INFO','WARN','ERROR','SUCCESS')]$Level = 'INFO')
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $color = @{ INFO='Cyan'; WARN='Yellow'; ERROR='Red'; SUCCESS='Green' }[$Level]
    Write-Host "[$ts] [$Level] $Message" -ForegroundColor $color
}

function Export-Report {
    param([string]$Name, [object[]]$Data, [string]$Path)
    $file = Join-Path $Path "${Name}_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
    $Data | Export-Csv -Path $file -NoTypeInformation -Encoding UTF8
    Write-Log "Report saved: $file" -Level SUCCESS
    return $file
}

# ── Main ──────────────────────────────────────────────────────────────────────

Write-Log "Microsoft Purview — Get-SensitivityLabelReport.ps1 starting" -Level INFO
Write-Log "Report period: Last $DaysBack days" -Level INFO

# Ensure output directory exists
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
    Write-Log "Created output directory: $OutputPath" -Level INFO
}

# Verify IPPS connection
try {
    $null = Get-Label -ErrorAction Stop
    Write-Log "Security & Compliance PowerShell session active" -Level INFO
} catch {
    Write-Log "Connecting to Security & Compliance PowerShell..." -Level WARN
    Connect-IPPSSession
}

# ── Report 1: Label Inventory ──────────────────────────────────────────────────

Write-Log "Generating Label Inventory Report..." -Level INFO

$labels = Get-Label | Select-Object `
    DisplayName,
    Name,
    Priority,
    IsActive,
    @{N='EncryptionEnabled'; E={ $_.EncryptionEnabled }},
    @{N='ContentMarkingEnabled'; E={ $_.ContentMarkingEnabled }},
    @{N='Scope'; E={ $_.ContentType -join ', ' }},
    @{N='ParentLabel'; E={ $_.ParentId }},
    @{N='CreatedUTC'; E={ $_.WhenCreatedUTC }},
    @{N='ModifiedUTC'; E={ $_.WhenChangedUTC }},
    Comment

Write-Log "Found $($labels.Count) sensitivity labels" -Level INFO
Export-Report -Name "Label_Inventory" -Data $labels -Path $OutputPath | Out-Null

# Display summary
$labels | Format-Table DisplayName, EncryptionEnabled, Scope, IsActive -AutoSize

# ── Report 2: Label Policy Configuration ──────────────────────────────────────

Write-Log "Generating Label Policy Configuration Report..." -Level INFO

$policies = Get-LabelPolicy | Select-Object `
    Name,
    @{N='LabelsIncluded'; E={ ($_.Labels | Get-Label -ErrorAction SilentlyContinue).DisplayName -join ', ' }},
    @{N='AssignedUsers'; E={
        if ($_.ExchangeLocation -eq 'All') { 'All Users' }
        else { $_.ExchangeLocation -join ', ' }
    }},
    @{N='MandatoryLabel'; E={ $_.Settings | Where-Object { $_.Key -eq 'requiredowngradejustification' } | Select-Object -ExpandProperty Value }},
    @{N='CreatedUTC'; E={ $_.WhenCreatedUTC }},
    @{N='ModifiedUTC'; E={ $_.WhenChangedUTC }},
    Comment

Write-Log "Found $($policies.Count) label policies" -Level INFO
Export-Report -Name "Label_Policy_Config" -Data $policies -Path $OutputPath | Out-Null

$policies | Format-Table Name, AssignedUsers, LabelsIncluded -AutoSize

# ── Report 3: Auto-Labeling Policies ──────────────────────────────────────────

Write-Log "Generating Auto-Labeling Policy Report..." -Level INFO

try {
    $autoPolicies = Get-AutoSensitivityLabelPolicy | ForEach-Object {
        $policy = $_
        $rules = Get-AutoSensitivityLabelRule -Policy $policy.Name -ErrorAction SilentlyContinue

        [PSCustomObject]@{
            PolicyName       = $policy.Name
            ApplyLabel       = $policy.ApplySensitivityLabel
            Mode             = $policy.Mode
            ExchangeScope    = $policy.ExchangeLocation
            SharePointScope  = $policy.SharePointLocation
            OneDriveScope    = $policy.OneDriveLocation
            RuleCount        = $rules.Count
            DetectionTypes   = ($rules.ContentContainsSensitiveInformation.Name -join ', ')
            Status           = $policy.Workload
            CreatedUTC       = $policy.WhenCreatedUTC
            ModifiedUTC      = $policy.WhenChangedUTC
        }
    }

    if ($autoPolicies) {
        Write-Log "Found $($autoPolicies.Count) auto-labeling policies" -Level INFO
        Export-Report -Name "AutoLabel_Policy_Report" -Data $autoPolicies -Path $OutputPath | Out-Null
        $autoPolicies | Format-Table PolicyName, ApplyLabel, Mode, DetectionTypes -AutoSize
    } else {
        Write-Log "No auto-labeling policies found" -Level WARN
    }
} catch {
    Write-Log "Auto-labeling policy query failed (may require E5 licensing): $_" -Level WARN
}

# ── Report 4: Activity Summary (Optional) ─────────────────────────────────────

if ($IncludeActivityReport) {
    Write-Log "Generating Labeling Activity Summary (last $DaysBack days)..." -Level INFO

    $startDate = (Get-Date).AddDays(-$DaysBack)
    $endDate   = Get-Date

    try {
        $activities = Search-UnifiedAuditLog `
            -StartDate $startDate `
            -EndDate $endDate `
            -Operations SensitivityLabelApplied, SensitivityLabelChanged, SensitivityLabelRemoved, SensitivityLabelAutoApplied `
            -RecordType MicrosoftPurviewLabelActivity `
            -ResultSize 5000 |
            ForEach-Object {
                $auditData = $_.AuditData | ConvertFrom-Json
                [PSCustomObject]@{
                    Timestamp     = $_.CreationDate
                    User          = $_.UserIds
                    Operation     = $_.Operations
                    LabelApplied  = $auditData.SensitivityLabelEventData.LabelName
                    PreviousLabel = $auditData.SensitivityLabelEventData.OldSensitivityLabelId
                    ContentType   = $auditData.ItemType
                    ContentName   = $auditData.ObjectId
                    Workload      = $_.Workload
                }
            }

        if ($activities) {
            Write-Log "Found $($activities.Count) labeling events" -Level INFO

            # Summary by operation type
            $summary = $activities | Group-Object Operation | Select-Object `
                @{N='Operation'; E={$_.Name}},
                @{N='Count'; E={$_.Count}}

            Write-Log "=== ACTIVITY SUMMARY ===" -Level INFO
            $summary | Format-Table -AutoSize

            Export-Report -Name "Labeling_Activity" -Data $activities -Path $OutputPath | Out-Null
        } else {
            Write-Log "No labeling activity found in the last $DaysBack days" -Level INFO

            # Export empty with headers
            [PSCustomObject]@{
                Timestamp='N/A'; User='N/A'; Operation='No events found'; LabelApplied='N/A'
            } | Export-Csv -Path (Join-Path $OutputPath "Labeling_Activity_empty.csv") -NoTypeInformation
        }
    } catch {
        Write-Log "Activity report failed: $_" -Level WARN
    }
}

# ── Final Summary ──────────────────────────────────────────────────────────────

Write-Log "=== REPORT GENERATION COMPLETE ===" -Level SUCCESS
Write-Log "Reports saved to: $OutputPath" -Level INFO
Write-Log "Labels found    : $($labels.Count)" -Level INFO
Write-Log "Policies found  : $($policies.Count)" -Level INFO

$reportFiles = Get-ChildItem -Path $OutputPath -Filter "*.csv" | Sort-Object LastWriteTime -Descending
Write-Log "Generated files:" -Level INFO
$reportFiles | Select-Object Name, @{N='Size';E={"$([Math]::Round($_.Length/1KB,1)) KB"}}, LastWriteTime |
    Format-Table -AutoSize

Write-Log "Get-SensitivityLabelReport.ps1 complete" -Level SUCCESS
