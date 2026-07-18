# Sensitivity Labels Taxonomy

## What Are Sensitivity Labels?

Sensitivity labels are classification markers that allow organizations to categorize Microsoft 365 content according to its sensitivity level. Once applied, a sensitivity label can enforce protection settings including encryption, access control, content marking, and permissions — and those settings persist with the content wherever it travels.

Sensitivity labels differ from retention labels:
- **Sensitivity labels** — classify and protect content (encryption, access, marking)
- **Retention labels** — govern content lifecycle (how long to keep or delete)

---

## Default Sensitivity Labels in Microsoft 365

Microsoft 365 provides a set of built-in default sensitivity labels that appear in the Purview portal for new tenants. These labels represent a standard enterprise taxonomy:

| Label | Sublabels | Purpose |
|---|---|---|
| **Public** | — | Content safe for public distribution |
| **General** | — | Standard internal content, no restrictions |
| **Confidential** | All Employees, Anyone (unrestricted), Specific People, Recipients Only | Confidential business content requiring access control |
| **Highly Confidential** | All Employees, Specific People, Recipients Only | Most sensitive content, restricted distribution |

These default labels can be used directly or supplemented with custom labels appropriate to the organization's classification requirements.

---

## Custom Labels Created in Lab

For this lab, additional enterprise-style labels were created to reflect realistic business classification scenarios:

| Label | Target Audience | Encryption | Use Case |
|---|---|---|---|
| **Internal Projects** | All internal users | Yes | Project documents, internal initiatives |
| **Client Confidential** | Named account team | Yes | Customer contracts, account data |
| **Finance Restricted** | Finance group | Yes | Financial records, budgets, audits |
| **Finance Confidential** | Finance group + auto-label target | Yes | Auto-labeled when credit card numbers detected |
| **Executive Confidential** | Leadership group | Yes | Board materials, M&A, strategic plans |

---

## Label Hierarchy and Sublabels

Microsoft Purview supports a two-level hierarchy:

```
Parent Label (e.g., Confidential)
├── Sublabel 1 (e.g., Confidential - All Employees)
├── Sublabel 2 (e.g., Confidential - Specific People)
└── Sublabel 3 (e.g., Confidential - Recipients Only)
```

**Best practice:** Use parent labels as category headers. Publish sublabels to users — they are more descriptive and drive the correct protection behavior.

---

## Label Scopes

Each sensitivity label is configured with a **scope** that determines which types of content the label can be applied to:

| Scope | What It Covers |
|---|---|
| **Files and other data assets** | Word, Excel, PowerPoint, PDF, SharePoint files, OneDrive |
| **Emails** | Outlook emails (Exchange Online) |
| **Meetings** | Microsoft Teams meetings |
| **Groups & Sites** | Microsoft 365 Groups, Teams, SharePoint sites |
| **Schematized data assets** | Azure SQL, Azure Synapse, Azure Purview data map |

> **Lab note:** Groups & Sites scope appeared unavailable in the lab tenant during this configuration. This is a known limitation in new Microsoft 365 trial tenants that require additional Microsoft Entra and Microsoft 365 integration settings. The label taxonomy in this lab targets **Files and Emails** scope only.

---

## Label Properties

Each sensitivity label is configured with the following properties:

| Property | Purpose |
|---|---|
| **Name** | Internal identifier (not shown to users) |
| **Display Name** | Label name visible to users in Office apps and Outlook |
| **Description (for users)** | Tooltip shown to users when they hover over the label |
| **Description (for admins)** | Internal documentation for administrators |
| **Label Color** | Visual identifier in the Office sensitivity bar |
| **Priority** | Order in the label list — higher priority = shown lower in list |

---

## Label Color Coding (Recommended Convention)

| Label | Recommended Color | Rationale |
|---|---|---|
| Public | Blue | Informational, non-sensitive |
| General | Grey | Standard, no special handling |
| Confidential | Orange | Caution — restricted access |
| Highly Confidential | Red | Stop — maximum restriction |
| Finance Restricted | Purple | Finance-specific classification |
| Executive Confidential | Black | Leadership-only — highest discretion |

---

## Creating a Sensitivity Label — Portal Steps

### Navigation
```
compliance.microsoft.com → Information Protection → Sensitivity labels → Create a label
```

### Configuration Steps

**Step 1 — Basic Properties**
- Enter label name (internal), display name, and description for users
- Select label color
- Configure sublabel (optional)

**Step 2 — Define Scope**
- Select: Files and other data assets
- Select: Emails
- (Groups & Sites — unavailable in lab tenant)

**Step 3 — Protection Settings for Files and Emails**
- Access control: On/Off
- Content marking: On/Off
- Auto-labeling for files and emails: On/Off (configured separately via policy)

**Step 4 — Access Control Settings** *(if enabled)*
- Assign permissions now, or let users assign permissions
- Specify: authorized users and groups
- Set: permission level (Viewer, Reviewer, Co-Author, Co-Owner)
- Configure: content expiration (optional)

**Step 5 — Content Marking** *(optional)*
- Add watermark
- Add header
- Add footer

**Step 6 — Auto-Labeling** *(within label)*
- Configure SIT-based auto-labeling for client-side Office apps
- Note: Service-side auto-labeling (SharePoint, OneDrive, Exchange) is configured separately via Auto-Labeling Policies

**Step 7 — Review and Create**
- Review all settings
- Select **Create label**

---

## Sensitivity Label Taxonomy: Enterprise Example

The following taxonomy represents an enterprise-grade classification structure suitable for a regulated organization:

```
TAXONOMY
├── Public
│   └── Content approved for external/public distribution
├── General
│   └── Internal content — no restrictions
├── Confidential
│   ├── Confidential - All Employees
│   ├── Confidential - Specific People
│   └── Confidential - Recipients Only
├── Highly Confidential
│   ├── Highly Confidential - All Employees
│   └── Highly Confidential - Specific People
├── Internal Projects       [Custom]
├── Client Confidential     [Custom]
├── Finance Restricted      [Custom]
├── Finance Confidential    [Custom — Auto-Label Target]
└── Executive Confidential  [Custom]
```

---

## MS-102 Exam Points

- Sensitivity labels and retention labels serve different purposes — do not confuse them on the exam
- Labels are published to users via **Label Policies** — creating a label does not automatically make it available to users
- Groups & Sites scope requires Microsoft Entra and Microsoft 365 Groups integration
- Label hierarchy supports a maximum of one level of sublabels
- Label **priority** determines which label wins when multiple labels could apply

---

## Related Documentation

- [01 — Overview](01-purview-information-protection-overview.md)
- [03 — Label Policies and Publishing](03-label-policies-publishing.md)
- [06 — Protection Settings and Encryption](06-protection-settings-encryption.md)

---

![Sensitivity Labels management page showing the full label taxonomy in Microsoft Purview portal](../images/02-sensitivity-labels/02-sensitivity-labels__01-sensitivity-labels-list.avif)
*Appendix A.1 — Sensitivity Labels management page — compliance.microsoft.com → Information Protection → Sensitivity labels*
