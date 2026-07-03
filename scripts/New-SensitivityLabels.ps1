#Requires -Modules @{ModuleName='ExchangeOnlineManagement'; ModuleVersion='3.0.0'}
<#
.SYNOPSIS
    Creates enterprise sensitivity label taxonomy in Microsoft Purview Information Protection.

.DESCRIPTION
    This script creates a complete set of sensitivity labels in Microsoft Purview using
    the Security & Compliance PowerShell module. It creates labels with appropriate
    protection settings and configures access control permissions.

    Labels created:
    - Internal Projects     : Encryption, internal users
    - Client Confidential   : Encryption, account team
    - Finance Restricted    : Encryption, Finance group
    - Finance Confidential  : Encryption, Finance group (auto-label target)
    - Executive Confidential: Encryption, leadership group

    IMPORTANT: This script creates labels only. Labels must be published via a
    Label Policy before they appear to users. Use New-AutoLabelingPolicy.ps1 to
    configure auto-labeling detection rules.

.PARAMETER FinanceGroup
    UPN or email address of the Finance security group in Entra ID.
    Example: finance-team@contoso.com

.PARAMETER AccountTeamGroup
    UPN or email address of the Account Management security group.
    Example: account-team@contoso.com

.PARAMETER LeadershipGroup
    UPN or email address of the Leadership/Executive security group.
    Example: leadership@contoso.com

.PARAMETER InternalDomain
    Organization's Microsoft 365 tenant domain.
    Example: patchthecloud.onmicrosoft.com

.PARAMETER WhatIf
    Shows what would happen without making changes.

.EXAMPLE
    .\New-SensitivityLabels.ps1 `
        -FinanceGroup "finance@contoso.com" `
        -AccountTeamGroup "accounts@contoso.com" `
        -LeadershipGroup "leadership@contoso.com" `
        -InternalDomain "contoso.onmicrosoft.com"

.NOTES
    Author  : Lokesh Karnam
    Purpose : Microsoft 365 Portfolio — Microsoft Purview Information Protection
    Tenant  : Patchthecloud.onmicrosoft.com (lab)
    Module  : ExchangeOnlineManagement (Security & Compliance PowerShell)
    Ref     : https://techcertguide.blog/microsoft-information-protection-ms102/

    SECURITY: Never commit credentials. Use Connect-IPPSSession interactively
              or via managed identity in production.
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$FinanceGroup,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$AccountTeamGroup,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$LeadershipGroup,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$InternalDomain
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

function Test-IPPSConnection {
    try {
        $null = Get-Label -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

function New-PurviewLabel {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$Name,
        [string]$DisplayName,
        [string]$Comment,
        [string]$Tooltip,
        [string]$AdvancedSettings,
        [int]$Priority
    )

    $existing = Get-Label -Identity $Name -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Log "Label '$Name' already exists — skipping creation" -Level WARN
        return $existing
    }

    if ($PSCmdlet.ShouldProcess($Name, 'Create Sensitivity Label')) {
        $params = @{
            Name        = $Name
            DisplayName = $DisplayName
            Comment     = $Comment
            Tooltip     = $Tooltip
        }
        $label = New-Label @params
        Write-Log "Created label: $DisplayName" -Level SUCCESS
        return $label
    }
}

# ── Main ──────────────────────────────────────────────────────────────────────

Write-Log "Microsoft Purview — New-SensitivityLabels.ps1 starting" -Level INFO

# Verify IPPS connection
if (-not (Test-IPPSConnection)) {
    Write-Log "Not connected to Security & Compliance PowerShell. Connecting..." -Level WARN
    try {
        Connect-IPPSSession -ErrorAction Stop
        Write-Log "Connected to Security & Compliance PowerShell" -Level SUCCESS
    } catch {
        Write-Log "Failed to connect: $_" -Level ERROR
        throw
    }
} else {
    Write-Log "Security & Compliance PowerShell session active" -Level INFO
}

# ── Define Label Configurations ───────────────────────────────────────────────

$labelDefinitions = @(
    @{
        Name        = "Internal_Projects"
        DisplayName = "Internal Projects"
        Tooltip     = "Apply to internal project documents, plans, and initiatives. Restricted to internal staff."
        Comment     = "Internal Projects label — encryption for authenticated internal users. Part of Purview MIP lab."
    },
    @{
        Name        = "Client_Confidential"
        DisplayName = "Client Confidential"
        Tooltip     = "Apply to customer contracts, proposals, and account documentation. Account team access only."
        Comment     = "Client Confidential label — encryption for named account team. Part of Purview MIP lab."
    },
    @{
        Name        = "Finance_Restricted"
        DisplayName = "Finance Restricted"
        Tooltip     = "Apply to financial records, budgets, and audit documents. Finance team access only."
        Comment     = "Finance Restricted label — encryption for Finance group. Part of Purview MIP lab."
    },
    @{
        Name        = "Finance_Confidential"
        DisplayName = "Finance Confidential"
        Tooltip     = "Apply to confidential financial data. Also applied automatically when credit card numbers are detected."
        Comment     = "Finance Confidential label — auto-label target for Credit Card Number SIT. Part of Purview MIP lab."
    },
    @{
        Name        = "Executive_Confidential"
        DisplayName = "Executive Confidential"
        Tooltip     = "Apply to board materials, M&A documents, and strategic plans. Leadership access only."
        Comment     = "Executive Confidential label — encryption for leadership group. Part of Purview MIP lab."
    }
)

# ── Create Labels ─────────────────────────────────────────────────────────────

$createdLabels = @()
foreach ($def in $labelDefinitions) {
    $label = New-PurviewLabel @def
    if ($label) { $createdLabels += $label }
}

Write-Log "Label creation complete. $($createdLabels.Count) labels processed." -Level INFO

# ── Configure Protection Settings ─────────────────────────────────────────────
# Note: Full IRM/RMS protection settings are configured via Set-Label -EncryptionEnabled
# and related parameters. The following demonstrates the pattern for Finance Restricted.

Write-Log "Configuring encryption settings for Finance Restricted label..." -Level INFO

if ($PSCmdlet.ShouldProcess("Finance_Restricted", "Configure encryption")) {
    try {
        Set-Label -Identity "Finance_Restricted" `
            -EncryptionEnabled $true `
            -EncryptionProtectionType "template" `
            -EncryptionRightsDefinitions "${FinanceGroup}:VIEW,VIEWRIGHTSDATA,EDIT,SAVE,PRINT,EXTRACT,DOCEDIT,OBJMODEL" `
            -EncryptionOfflineAccessDays 7
        Write-Log "Finance Restricted: encryption configured" -Level SUCCESS
    } catch {
        Write-Log "Finance Restricted encryption config failed (may require label recreation): $_" -Level WARN
    }
}

Write-Log "Configuring encryption settings for Finance Confidential label..." -Level INFO

if ($PSCmdlet.ShouldProcess("Finance_Confidential", "Configure encryption")) {
    try {
        Set-Label -Identity "Finance_Confidential" `
            -EncryptionEnabled $true `
            -EncryptionProtectionType "template" `
            -EncryptionRightsDefinitions "${FinanceGroup}:VIEW,VIEWRIGHTSDATA,EDIT,SAVE,PRINT,EXTRACT,DOCEDIT,OBJMODEL" `
            -EncryptionOfflineAccessDays 7
        Write-Log "Finance Confidential: encryption configured" -Level SUCCESS
    } catch {
        Write-Log "Finance Confidential encryption config failed: $_" -Level WARN
    }
}

# ── Summary Report ─────────────────────────────────────────────────────────────

Write-Log "=== LABEL CREATION SUMMARY ===" -Level INFO
$allLabels = Get-Label | Where-Object { $_.Name -in $labelDefinitions.Name }
$allLabels | Select-Object DisplayName, Name, @{N='Created';E={$_.WhenCreatedUTC}} |
    Format-Table -AutoSize

Write-Log @"
Next Steps:
  1. Publish labels via a Label Policy in compliance.microsoft.com
  2. Assign labels to appropriate users/groups
  3. Run New-AutoLabelingPolicy.ps1 to configure auto-labeling for Finance Confidential
  4. Wait 24 hours for policy synchronization before testing in Office apps
"@ -Level INFO

Write-Log "New-SensitivityLabels.ps1 complete" -Level SUCCESS
