#Requires -Modules @{ModuleName='ExchangeOnlineManagement'; ModuleVersion='3.0.0'}
<#
.SYNOPSIS
    Creates an auto-labeling policy in Microsoft Purview to detect sensitive information
    and automatically apply a sensitivity label.

.DESCRIPTION
    This script creates a Microsoft Purview auto-labeling policy that:
    - Detects Credit Card Numbers using built-in Sensitive Information Types
    - Automatically applies the "Finance Confidential" sensitivity label
    - Covers Exchange Online, SharePoint Online, and OneDrive workloads
    - Starts in Simulation mode for safe validation before production enforcement

    Auto-labeling requires Microsoft 365 E5 or Microsoft Purview Information Protection
    add-on licensing for service-side scanning.

.PARAMETER PolicyName
    Name for the auto-labeling policy.
    Default: "Finance Confidential Auto-Label"

.PARAMETER LabelName
    Display name of the sensitivity label to apply.
    Default: "Finance Confidential"

.PARAMETER StartInSimulation
    If specified, policy is created in simulation mode.
    Default: $true (simulation mode — recommended for initial deployment)

.PARAMETER EnableForProduction
    Switch to activate automatic enforcement after simulation review.
    Use only after reviewing simulation results.

.PARAMETER SharePointSitesToExclude
    Array of SharePoint site URLs to exclude from the policy scope.

.EXAMPLE
    # Create in simulation mode (recommended first step)
    .\New-AutoLabelingPolicy.ps1 -StartInSimulation

.EXAMPLE
    # Enable automatic enforcement after simulation review
    .\New-AutoLabelingPolicy.ps1 -EnableForProduction

.NOTES
    Author  : Lokesh Karnam
    Purpose : Microsoft 365 Portfolio — Microsoft Purview Information Protection
    Tenant  : Patchthecloud.onmicrosoft.com (lab)
    Module  : ExchangeOnlineManagement (Security & Compliance PowerShell)
    Ref     : https://techcertguide.blog/automatic-sensitivity-labels-in-microsoft-purview/

    Licensing note: Auto-labeling policies (service-side) require Microsoft 365 E5.
    The Auto-labeling menu may not appear in E3 tenants without the Purview add-on.

    SECURITY: Never commit credentials. Use Connect-IPPSSession interactively.
#>

[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Simulation')]
param (
    [Parameter()]
    [string]$PolicyName = "Finance Confidential Auto-Label",

    [Parameter()]
    [string]$LabelName = "Finance Confidential",

    [Parameter(ParameterSetName = 'Simulation')]
    [switch]$StartInSimulation = $true,

    [Parameter(ParameterSetName = 'Production')]
    [switch]$EnableForProduction,

    [Parameter()]
    [string[]]$SharePointSitesToExclude = @()
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

# ── Main ──────────────────────────────────────────────────────────────────────

Write-Log "Microsoft Purview — New-AutoLabelingPolicy.ps1 starting" -Level INFO

# Verify connection
try {
    $null = Get-Label -ErrorAction Stop
    Write-Log "Security & Compliance PowerShell session active" -Level INFO
} catch {
    Write-Log "Connecting to Security & Compliance PowerShell..." -Level WARN
    Connect-IPPSSession
}

# Verify label exists
$label = Get-Label -Identity $LabelName -ErrorAction SilentlyContinue
if (-not $label) {
    Write-Log "Label '$LabelName' not found. Run New-SensitivityLabels.ps1 first." -Level ERROR
    throw "Label '$LabelName' does not exist"
}
Write-Log "Target label found: $($label.DisplayName)" -Level SUCCESS

# ── Check for Existing Policy ──────────────────────────────────────────────────

$existingPolicy = Get-AutoSensitivityLabelPolicy -Identity $PolicyName -ErrorAction SilentlyContinue
if ($existingPolicy) {
    Write-Log "Policy '$PolicyName' already exists." -Level WARN

    if ($EnableForProduction) {
        if ($PSCmdlet.ShouldProcess($PolicyName, 'Enable auto-labeling policy for production (Automatic mode)')) {
            Set-AutoSensitivityLabelPolicy -Identity $PolicyName -Mode Enable
            Write-Log "Policy '$PolicyName' set to Automatic enforcement mode" -Level SUCCESS
        }
    } else {
        Write-Log "Policy exists and no changes requested. Use -EnableForProduction to activate." -Level INFO
    }
    return
}

# ── Determine Policy Mode ──────────────────────────────────────────────────────

$mode = if ($EnableForProduction) { 'Enable' } else { 'TestWithoutNotifications' }
$modeDescription = if ($EnableForProduction) { 'Automatic (Production)' } else { 'Simulation (TestWithoutNotifications)' }
Write-Log "Policy mode: $modeDescription" -Level INFO

# ── Create Auto-Labeling Rule ──────────────────────────────────────────────────

$ruleName = "${PolicyName}-Rule-CreditCard"

Write-Log "Creating auto-labeling policy: $PolicyName" -Level INFO

if ($PSCmdlet.ShouldProcess($PolicyName, "Create Auto-Labeling Policy")) {

    # Create the policy
    $policyParams = @{
        Name             = $PolicyName
        ApplySensitivityLabel = $LabelName
        Mode             = $mode
        Comment          = "Detects Credit Card Numbers and applies Finance Confidential label. Created by New-AutoLabelingPolicy.ps1."
        ExchangeLocation = "All"
        SharePointLocation= "All"
        OneDriveLocation  = "All"
    }

    if ($SharePointSitesToExclude.Count -gt 0) {
        $policyParams['SharePointLocationException'] = $SharePointSitesToExclude
        $policyParams['OneDriveLocationException'] = $SharePointSitesToExclude
        Write-Log "Excluding $($SharePointSitesToExclude.Count) sites from policy scope" -Level INFO
    }

    $policy = New-AutoSensitivityLabelPolicy @policyParams
    Write-Log "Policy created: $($policy.Name)" -Level SUCCESS

    # Create detection rule: Credit Card Number SIT, high confidence, 1+ instance
    $ruleParams = @{
        Name                        = $ruleName
        Policy                      = $PolicyName
        ContentContainsSensitiveInformation = @{
            Name           = "Credit Card Number"
            MinCount       = 1
            MinConfidenceLevel = 85
        }
        ReportSeverityLevel         = 'Medium'
    }

    $rule = New-AutoSensitivityLabelRule @ruleParams
    Write-Log "Detection rule created: $ruleName (Credit Card Number, ≥1 instance, ≥85% confidence)" -Level SUCCESS
}

# ── Summary ───────────────────────────────────────────────────────────────────

$summaryPolicy = Get-AutoSensitivityLabelPolicy -Identity $PolicyName -ErrorAction SilentlyContinue
$summaryRule   = Get-AutoSensitivityLabelRule -Policy $PolicyName -ErrorAction SilentlyContinue

if ($summaryPolicy) {
    Write-Log "=== AUTO-LABELING POLICY SUMMARY ===" -Level INFO
    Write-Log "Policy Name : $($summaryPolicy.Name)" -Level INFO
    Write-Log "Label       : $($summaryPolicy.ApplySensitivityLabel)" -Level INFO
    Write-Log "Mode        : $($summaryPolicy.Mode)" -Level INFO
    Write-Log "Exchange    : $($summaryPolicy.ExchangeLocation)" -Level INFO
    Write-Log "SharePoint  : $($summaryPolicy.SharePointLocation)" -Level INFO
    Write-Log "OneDrive    : $($summaryPolicy.OneDriveLocation)" -Level INFO
    Write-Log "Rules       : $($summaryRule.Count)" -Level INFO
}

Write-Log @"
Next Steps:
  Simulation Mode:
    1. Wait for the first simulation scan to complete (24-48 hours)
    2. Review results in compliance.microsoft.com → Information Protection → Auto-labeling
    3. Select the policy → 'View simulated results'
    4. Verify detection accuracy — check for false positives
    5. When satisfied, run: .\New-AutoLabelingPolicy.ps1 -EnableForProduction

  Production Mode:
    1. Monitor Activity Explorer for auto-labeling events
    2. Review users affected and validate label application
    3. Set up alerts for unexpected label volume changes
"@ -Level INFO

Write-Log "New-AutoLabelingPolicy.ps1 complete" -Level SUCCESS
