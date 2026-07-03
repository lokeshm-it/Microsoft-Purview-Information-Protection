# Microsoft Purview Information Protection — Overview

## Business Context

Modern organizations handle sensitive data across dozens of Microsoft 365 workloads simultaneously. Emails containing financial records, SharePoint sites with client contracts, OneDrive documents with employee data, and Teams messages with strategic plans all exist in the same environment — often without any classification or protection applied.

Without a formal information protection framework:

- Sensitive data is shared accidentally (wrong recipients, external access)
- Regulatory exposure increases under GDPR, ISO 27001, and industry standards
- IT teams lack visibility into what sensitive data exists and where it lives
- Protection is inconsistent — some files encrypted, most are not
- Downstream governance controls (DLP, audit, eDiscovery) have no reliable signal to act on

Microsoft Purview Information Protection solves this by providing a **unified classification, labeling, and protection platform** that integrates across Microsoft 365 services.

---

## What is Microsoft Purview Information Protection?

Microsoft Purview Information Protection (MIP) is the data governance and protection layer in Microsoft 365 and the Microsoft Purview compliance portal. It provides:

- A **sensitivity label taxonomy** — named classification tiers that define what data is and how it should be treated
- **Label policies** — publishing rules that control which users see which labels
- **Protection enforcement** — encryption, access control, permissions, and content marking tied to labels
- **Manual labeling** — users apply labels in Office apps and Outlook
- **Automatic labeling** — Microsoft Purview detects sensitive content and applies labels without user action
- **Persistent protection** — labels and encryption travel with content, regardless of location

MIP is not a standalone product. It is a capability layer that integrates with Exchange Online, SharePoint Online, OneDrive, Microsoft Teams, Office apps, Microsoft Defender for Cloud Apps, Microsoft Purview DLP, and Microsoft Purview Audit.

---

## How Microsoft Information Protection Works

```
Content Created → Content Inspected → Label Applied → Protection Enforced → Protection Travels
```

1. **Content Created** — A user writes an email, opens a Word document, uploads a file to SharePoint
2. **Content Inspected** — Purview evaluates the content (manual prompt, auto-labeling scan, or policy-triggered detection)
3. **Label Applied** — A sensitivity label is manually selected by the user, recommended by policy, or automatically applied by an auto-labeling rule
4. **Protection Enforced** — The label's protection settings activate: encryption keys applied, permissions set, watermarks added
5. **Protection Travels** — The label metadata and encryption persist in the file's properties — even if the file is downloaded, moved, or shared externally

---

## Microsoft Purview Portal Access

| Portal | URL | Purpose |
|---|---|---|
| Microsoft Purview Compliance | `compliance.microsoft.com` or `purview.microsoft.com` | Primary admin interface for MIP |
| Microsoft 365 Admin Center | `admin.microsoft.com` | Licensing and service management |
| Microsoft Entra Admin Center | `entra.microsoft.com` | Identity integration for label scopes |

**Required Roles:**
- Global Administrator
- Compliance Administrator
- Information Protection Administrator

---

## Microsoft 365 Workloads Covered

| Workload | Protection Capability |
|---|---|
| Exchange Online | Encrypted emails, labeled outbound messages |
| SharePoint Online | Labeled site contents, protected libraries |
| OneDrive | File-level labels, encryption on personal documents |
| Microsoft Teams | Labels on Teams channels, meetings, and files |
| Office Apps (Word, Excel, PowerPoint) | In-app label picker, sensitivity bar |
| PDF files | Adobe Acrobat + AIP reader compatible labels |

---

## Information Protection Framework: Three Pillars

### 1. Know Your Data
Before you can protect data, you need to understand what sensitive data exists and where it lives.

Microsoft Purview provides:
- **Sensitive Information Types (SITs)** — pattern-based detectors (credit card numbers, passport numbers, healthcare identifiers)
- **Trainable Classifiers** — AI-powered classifiers that understand document context (contracts, resumes, source code)
- **Content Explorer** — shows where labeled and sensitive content exists across the tenant
- **Activity Explorer** — tracks labeling events, label changes, policy matches

### 2. Protect Your Data
Once identified, sensitive content is protected using sensitivity labels.

Labels can apply:
- **Encryption** — using Azure Rights Management (Azure RMS)
- **Access control** — specify who can open, edit, copy, print, or forward content
- **Content marking** — headers, footers, and watermarks embedded in documents
- **Label persistence** — protection survives relocation, download, and external sharing

### 3. Prevent Data Loss
Labels integrate with Microsoft Purview DLP to enforce policy when sensitive labeled content is attempted to be shared in violation of organizational policy. (Covered in separate DLP repository.)

---

## Tenant: Patchthecloud.onmicrosoft.com

| Item | Detail |
|---|---|
| Tenant | Patchthecloud.onmicrosoft.com |
| Licensing | Microsoft 365 E5 Trial |
| Portal | compliance.microsoft.com |
| Admin role used | Global Administrator |
| Lab date | January–June 2026 |

---

## Lab Scope and Limitations

| Configuration | Status | Notes |
|---|---|---|
| Sensitivity label taxonomy | ✅ Created | Public, General, Confidential, Highly Confidential + enterprise labels |
| Label policies published | ✅ Published | All users scope, require labeling enabled |
| Manual labeling | ✅ Validated | Labels visible in Office apps after sync |
| Auto-labeling policy | ✅ Configured | Credit Card Number → Finance Confidential |
| Groups & Sites scope | ⚠️ Unavailable | Lab tenant — requires additional Entra/M365 integration |
| Content marking | ⚠️ Not enabled | Foundational lab — kept intentionally simple |
| Trainable Classifiers | ℹ️ Not configured | Requires M365 E5 + training data |
| DLP integration | Out of scope | Separate repository |

> **Note:** Groups & Sites protection settings may appear unavailable in new Microsoft 365 lab or trial tenants until additional Microsoft Entra and Microsoft 365 integration settings are configured. This is a known lab environment limitation and does not affect the Files and Emails scope.

---

## Zero Trust Alignment

This implementation supports the **Data** pillar of the Zero Trust framework:

| Principle | Implementation |
|---|---|
| **Verify Explicitly** | Content is classified before protection is applied — labels provide context for all downstream controls |
| **Least Privilege** | Encryption grants only specified permissions (read-only, co-author, owner) to specified identities |
| **Assume Breach** | Labels and encryption persist with content outside the tenant boundary — breach does not mean exposure |

---

## Related Documentation

- [02 — Sensitivity Labels Taxonomy](02-sensitivity-labels-taxonomy.md)
- [03 — Label Policies and Publishing](03-label-policies-publishing.md)
- [04 — Manual Sensitivity Labels](04-manual-sensitivity-labels.md)
- [05 — Automatic Sensitivity Labels](05-automatic-sensitivity-labels.md)
- [06 — Protection Settings and Encryption](06-protection-settings-encryption.md)
- [07 — Validation and Testing](07-validation-testing.md)

---

*All portal configurations documented here were performed in a real Microsoft 365 E5 trial tenant. No configurations have been fabricated.*
