# Protection Settings and Encryption

## Overview

When a sensitivity label includes protection settings, Microsoft Purview applies **Azure Rights Management (Azure RMS)** encryption to the content. This is the encryption engine that powers Microsoft Information Protection — a cloud-based cryptographic service built into Microsoft 365.

Protection settings in a sensitivity label define:
- **Who** can access the content (authorized users and groups)
- **What** they can do (read, edit, copy, print, forward)
- **When** access expires (optional)
- **Whether** offline access is permitted

---

## Azure Rights Management (Azure RMS)

Azure RMS is the underlying encryption service that Microsoft Purview uses to protect labeled content.

Key characteristics:

| Property | Detail |
|---|---|
| Encryption standard | AES-256 for content encryption |
| Key management | Microsoft-managed (default) or customer-managed (BYOK) |
| Protection scope | Files and emails, regardless of location |
| Protection persistence | Encryption travels with content — protected even outside Microsoft 365 |
| Key storage | Azure Key Vault (customer-managed BYOK option) |
| Client support | Office apps, Azure Information Protection unified label client, Adobe Acrobat |

> **Important:** Azure RMS encryption applied by sensitivity labels is **persistent**. Even if a protected document is downloaded, emailed to an external party, or copied to a USB drive, the encryption remains. Only authorized users can open the content, regardless of where it is stored.

---

## Protection Settings in Label Configuration

### Access Control

Access control is the primary protection mechanism in a sensitivity label. When enabled:

```
Label Configured With Access Control
          ↓
Content Encrypted with Azure RMS
          ↓
Authorized identities listed in RMS key
          ↓
User opens content → Azure RMS verifies identity
          ↓
Authorized? → Access granted
Not authorized? → Access denied
```

### Assigning Permissions

When configuring access control in a label, administrators choose one of two approaches:

**Option 1: Assign permissions now (admin-defined)**
The administrator defines exactly who can access the content and at what permission level.

| Permission Level | Rights Granted |
|---|---|
| **Viewer** | View only — cannot edit, copy, or print |
| **Reviewer** | View and annotate — cannot edit content |
| **Co-Author** | Read, edit, save, copy, print — cannot change permissions |
| **Co-Owner** | Full rights including the ability to change permissions and remove protection |

**Option 2: Let users assign permissions**
Users select from a prompt when applying the label:
- "Only me" — protected for the label applier only
- "Anyone authenticated" — any authenticated Microsoft 365 user can access
- "Specific people" — users can specify individual recipients

---

## Lab Label Protection Configurations

### Finance Restricted Label

| Setting | Value |
|---|---|
| Access control | Enabled |
| Permissions assigned by | Administrator |
| Authorized group | Finance team |
| Permission level | Co-Author |
| Expiration | None |
| Offline access | Allowed (7 days) |

### Finance Confidential Label (Auto-Label Target)

| Setting | Value |
|---|---|
| Access control | Enabled |
| Permissions assigned by | Administrator |
| Authorized group | Finance team |
| Permission level | Co-Author |
| Expiration | None |
| Offline access | Allowed (7 days) |

### Client Confidential Label

| Setting | Value |
|---|---|
| Access control | Enabled |
| Permissions assigned by | Administrator |
| Authorized group | Account management team |
| Permission level | Co-Author |
| Expiration | Optional — 90 days for time-limited engagements |
| Offline access | Allowed (7 days) |

### Executive Confidential Label

| Setting | Value |
|---|---|
| Access control | Enabled |
| Permissions assigned by | Administrator |
| Authorized group | Leadership group |
| Permission level | Co-Author |
| Expiration | None |
| Offline access | Allowed (24 hours — short window for sensitive content) |

---

## Content Marking

Content marking is a **visual** protection mechanism — it does not apply encryption but adds visual classification indicators to documents and emails.

| Marking Type | Where Applied | Example |
|---|---|---|
| **Header** | Top of each page in Word/Excel/PowerPoint | "CONFIDENTIAL — Internal Use Only" |
| **Footer** | Bottom of each page | "Document Classification: Finance Restricted" |
| **Watermark** | Diagonal text across each page | "DRAFT — DO NOT DISTRIBUTE" |
| **Email marking** | Prepended to email subject | "[CONFIDENTIAL]" |

### Lab Note
Content marking was **not enabled** in this foundational lab to keep the configuration simple and focused on sensitivity label deployment and encryption. Enterprise deployments should enable content marking for Confidential and Highly Confidential labels at minimum, as the visual marking reinforces classification awareness.

---

## Encryption Behavior by Workload

| Workload | Encryption Applied | Additional Behavior |
|---|---|---|
| Word / Excel / PowerPoint | File encrypted via Azure RMS | Cannot be opened without authorization |
| Outlook email | Email body + attachments encrypted | Cannot be forwarded by unauthorized recipients |
| SharePoint Online | File encrypted in library | SharePoint search indexes encrypted content (with appropriate keys) |
| OneDrive | File encrypted in personal drive | Encrypted even when synced to device |
| Microsoft Teams | File attachments encrypted | Accessible only to authorized members |
| PDF | Encryption supported | Requires AIP Reader or compatible PDF viewer |

---

## Do Not Forward and Encrypt-Only

Two special protection options are available for email labels:

| Option | Behavior |
|---|---|
| **Do Not Forward** | Recipients cannot forward, print, copy, or save the email or its attachments |
| **Encrypt-Only** | Content is encrypted; recipients can forward but encryption persists |

These are available as dedicated email-only labels or can be incorporated into broader label configurations.

---

## Certificate and Key Management

By default, Microsoft manages the Azure RMS encryption keys on behalf of the organization. For organizations requiring full cryptographic control, two options are available:

| Key Management Model | Description |
|---|---|
| **Microsoft-managed keys** (default) | Microsoft handles key lifecycle; simplest deployment |
| **Customer-managed keys (CMK)** | Organization manages keys via Azure Key Vault |
| **Hold Your Own Key (HYOK)** | On-premises key management; used for air-gap scenarios |
| **Double Key Encryption (DKE)** | Two keys required — one Microsoft-managed, one customer-managed |

For the lab environment, **Microsoft-managed keys** (default) are used.

---

## Offline Access

When a user opens a labeled document, Azure RMS issues a **use license** — a cached credential that allows offline access for a configurable period.

| Offline Access Setting | Behavior |
|---|---|
| **Always** (not recommended) | Content accessible without re-checking authorization |
| **Number of days** (1–30) | License cached for specified period; then requires online re-verification |
| **Never** | Every access requires online authorization — maximum security, minimum usability |

**Lab default:** 7 days offline access for most labels. Executive Confidential set to 24 hours.

---

## Related Documentation

- [02 — Sensitivity Labels Taxonomy](02-sensitivity-labels-taxonomy.md)
- [04 — Manual Sensitivity Labels](04-manual-sensitivity-labels.md)
- [05 — Automatic Sensitivity Labels](05-automatic-sensitivity-labels.md)
- [07 — Validation and Testing](07-validation-testing.md)

---

![Label protection settings configuration showing access control and permission assignment](../images/02-sensitivity-labels/02-sensitivity-labels__14-protection-access-control.avif)
*Appendix A.14 — Label protection settings — access control, assign permissions, Azure RMS encryption*
