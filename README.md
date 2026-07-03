# Microsoft Purview Information Protection

[![Microsoft 365](https://img.shields.io/badge/Microsoft_365-E5-0078D4?logo=microsoft&logoColor=white)](https://microsoft.com/microsoft-365)
[![Microsoft Purview](https://img.shields.io/badge/Microsoft_Purview-Information_Protection-0078D4?logo=microsoft&logoColor=white)](https://learn.microsoft.com/en-us/purview/information-protection)
[![Sensitivity Labels](https://img.shields.io/badge/Sensitivity_Labels-Configured-107C10?logo=microsoft&logoColor=white)](https://learn.microsoft.com/en-us/purview/sensitivity-labels)
[![Auto-Labeling](https://img.shields.io/badge/Auto--Labeling-Configured-6B2D8B?logo=microsoft&logoColor=white)](https://learn.microsoft.com/en-us/purview/apply-sensitivity-label-automatically)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **Senior Infrastructure Engineer lab demonstrating Microsoft Purview Information Protection — covering sensitivity label taxonomy, manual and automatic labeling, encryption-based access control, and label policy publishing across Microsoft 365 workloads.**

---

## Business Problem

Organizations generate sensitive data across Microsoft 365 every day — emails, Word documents, Excel files, SharePoint content, and Teams messages. Without a formal classification and protection framework, that data is exposed to:

- Accidental external sharing
- Unauthorized downloads and access
- Data exfiltration via unprotected email
- Regulatory non-compliance (GDPR, ISO 27001, industry standards)
- Inconsistent protection across workloads

Manual controls alone are not scalable. Users forget to apply labels, apply incorrect classifications, or work without awareness of what is sensitive.

---

## Business Requirement

The organization requires a data classification and protection framework that:

- Classifies sensitive information using a consistent, enterprise-standard taxonomy
- Applies encryption and access control to confidential content
- Enables manual user-driven labeling for day-to-day classification
- Automates detection and labeling of sensitive information patterns (financial, personal, legal)
- Covers all primary Microsoft 365 workloads: Exchange Online, SharePoint, OneDrive, Teams, and Office apps
- Provides a foundation for downstream DLP and compliance controls

---

## Microsoft Solution

**Microsoft Purview Information Protection** — the information governance and data protection layer built into Microsoft 365 and the Microsoft Purview compliance portal.

| Capability | Purpose |
|---|---|
| Sensitivity Labels | Classify and protect content with named tiers |
| Label Policies | Publish labels to users and workloads |
| Manual Labeling | User-driven classification via Office apps and Outlook |
| Auto-Labeling Policies | Automatic detection using Sensitive Information Types |
| Encryption (IRM) | Restrict access by authorized users and groups |
| Content Marking | Visual headers, footers, and watermarks |
| Trainable Classifiers | AI-powered document-type detection |

---

## Lab Scope

| Area | Status |
|---|---|
| Purview portal access (compliance.microsoft.com) | ✅ Verified |
| Default sensitivity label taxonomy reviewed | ✅ Verified |
| Custom sensitivity labels created | ✅ Configured |
| Label scope: Files and Emails | ✅ Configured |
| Protection settings: Encryption + Access Control | ✅ Configured |
| Label policy published to all users | ✅ Published |
| Auto-labeling policy: Credit Card detection | ✅ Configured |
| Auto-labeling label: Finance Confidential | ✅ Configured |
| Groups & Sites scope | ⚠️ Unavailable in lab tenant — requires additional Entra/M365 integration |
| Content marking (watermarks/headers) | ⚠️ Not enabled in foundational lab — kept simple |
| Cloud Discovery / MCAS integration | Out of scope for this repo |

---

## Sensitivity Label Taxonomy

| Label | Scope | Protection |
|---|---|---|
| Public | Files, Emails | No encryption |
| General | Files, Emails | No encryption |
| Confidential | Files, Emails | Encryption + access control |
| Highly Confidential | Files, Emails | Encryption + restricted permissions |
| Internal Projects | Files, Emails | Encryption for internal audience |
| Client Confidential | Files, Emails | Encryption + customer-scoped permissions |
| Finance Restricted | Files, Emails | Encryption + finance-scoped permissions |
| Executive Confidential | Files, Emails | Encryption + leadership-only permissions |

> **Auto-Labeling Target**: `Finance Confidential` label applied automatically when Credit Card Number (Sensitive Information Type) is detected.

---

## Enterprise Perspective

| Stage | Detail |
|---|---|
| **Business Problem** | Unclassified sensitive data across Microsoft 365 — exposed to accidental sharing and regulatory risk |
| **Business Requirement** | Consistent classification taxonomy + encryption-based protection across all M365 workloads |
| **Microsoft Solution** | Microsoft Purview Sensitivity Labels + Auto-Labeling Policies |
| **Configuration** | Label taxonomy created, policies published, auto-labeling rule for Credit Card Numbers |
| **Validation** | Label availability confirmed in Office apps; auto-label policy reviewed in Purview portal |
| **Outcome** | Sensitive content automatically classified and protected — reducing human error and governance gaps |

---

## Lab Architecture

```
Microsoft 365 Tenant (Patchthecloud.onmicrosoft.com)
│
├── compliance.microsoft.com (Microsoft Purview Portal)
│   └── Information Protection
│       ├── Sensitivity Labels
│       │   ├── Public / General (no encryption)
│       │   ├── Confidential / Highly Confidential (encryption)
│       │   ├── Internal Projects / Client Confidential
│       │   ├── Finance Restricted / Executive Confidential
│       │   └── Finance Confidential (auto-label target)
│       │
│       ├── Label Policies
│       │   └── Published to: All Users — "Require labeling" enabled
│       │
│       └── Auto-Labeling Policies
│           └── Rule: Detect Credit Card Number (≥1 instance)
│               └── Apply: Finance Confidential
│
├── Protected Workloads
│   ├── Exchange Online (email protection)
│   ├── SharePoint Online (file protection)
│   ├── OneDrive (document protection)
│   ├── Microsoft Teams (collaboration protection)
│   └── Office Apps (Word, Excel, PowerPoint, PDF)
│
└── downstream integrations
    ├── Microsoft Purview DLP (uses label as condition)
    ├── Microsoft Purview Audit (label activity logged)
    └── Microsoft Defender for Cloud Apps (label-aware CASB)
```

---

## Repository Structure

```
Microsoft-Purview-Information-Protection/
├── README.md
├── .gitignore
├── LICENSE
├── GITHUB-METADATA.md
├── WEBSITE-PORTFOLIO-CARD.md
├── docs/
│   ├── 01-purview-information-protection-overview.md
│   ├── 02-sensitivity-labels-taxonomy.md
│   ├── 03-label-policies-publishing.md
│   ├── 04-manual-sensitivity-labels.md
│   ├── 05-automatic-sensitivity-labels.md
│   ├── 06-protection-settings-encryption.md
│   ├── 07-validation-testing.md
│   └── screenshots-placement-guide.md
├── scripts/
│   ├── New-SensitivityLabels.ps1
│   ├── New-AutoLabelingPolicy.ps1
│   └── Get-SensitivityLabelReport.ps1
└── architecture/
    └── purview-information-protection.md
```

---

## PowerShell Scripts

| Script | Purpose |
|---|---|
| `New-SensitivityLabels.ps1` | Creates full enterprise sensitivity label taxonomy via Microsoft Graph |
| `New-AutoLabelingPolicy.ps1` | Creates auto-labeling policy with Sensitive Information Type detection |
| `Get-SensitivityLabelReport.ps1` | Reports label usage, policy configuration, and labeling activity |

---

## MS-102 Exam Relevance

This lab covers the following **MS-102: Microsoft 365 Administrator** exam objectives:

- Configure and manage sensitivity labels in Microsoft Purview
- Publish sensitivity label policies to users and groups
- Configure auto-labeling policies using Sensitive Information Types
- Apply encryption and access control using sensitivity labels
- Understand label scopes: Files, Emails, Groups & Sites
- Differentiate manual vs. automatic vs. recommended labeling
- Understand Trainable Classifiers vs. Sensitive Information Types

---

## Zero Trust Alignment

| Zero Trust Principle | Implementation |
|---|---|
| **Verify Explicitly** | Every piece of content is classified before protection is applied |
| **Least Privilege** | Encryption restricts access to only authorized users and groups |
| **Assume Breach** | Labels persist with content — protection survives location changes |

---

## Related Projects

| Project | Technology | Link |
|---|---|---|
| P1 — Zero Trust Identity Perimeter | Conditional Access, MFA, SSPR | [View](../Project-1-Zero-Trust-Identity-Perimeter) |
| P3 — Zero Trust Email Security | Defender for Office 365, Safe Links | [View](../Project-3-Zero-Trust-Email-Security) |
| P6 — Entra ID Protection | Risk-based Conditional Access | [View](../Project-6-Entra-ID-Protection) |
| P7 — SaaS & Data Visibility | Defender for Cloud Apps | [View](../Project-7-SaaS-Data-Visibility-MDCA) |

---

## Blog Posts (TechCertGuide)

- [Microsoft Information Protection: Sensitivity Labels & Data Classification](https://techcertguide.blog/microsoft-information-protection-ms102/)
- [Manual Sensitivity Labels in Microsoft Purview](https://techcertguide.blog/manual-sensitivity-labels-in-microsoft-purview/)
- [Automatic Sensitivity Labels in Microsoft Purview](https://techcertguide.blog/automatic-sensitivity-labels-in-microsoft-purview/)

---

## Author

**Lokesh Karnam** — Senior Infrastructure Engineer | Microsoft 365 | 9+ years enterprise experience

[![GitHub](https://img.shields.io/badge/GitHub-lokeshm--it-181717?logo=github)](https://github.com/lokeshm-it)
[![Portfolio](https://img.shields.io/badge/Portfolio-lokeshm--it.github.io-0078D4?logo=microsoft)](https://lokeshm-it.github.io/Lokeshm-it/)
[![Blog](https://img.shields.io/badge/Blog-TechCertGuide-6B2D8B?logo=wordpress&logoColor=white)](https://techcertguide.blog)

---

*All configurations documented in this repository were implemented in a real Microsoft 365 E5 trial tenant (Patchthecloud.onmicrosoft.com). No configurations have been fabricated.*
