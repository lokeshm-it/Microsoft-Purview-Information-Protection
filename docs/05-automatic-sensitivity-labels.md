# Automatic Sensitivity Labels

## The Problem with Manual-Only Classification

Manual sensitivity labeling depends on users making the correct classification decision every time they create or edit content. In practice:

- Users forget to apply labels when working under time pressure
- Users apply incorrect labels due to misunderstanding of classification tiers
- New employees may not have completed labeling training
- High-volume content (automated reports, bulk uploads) cannot be manually labeled at scale
- Sensitive information created months ago remains unclassified

**Result:** Classification coverage is incomplete, inconsistent, and cannot be relied upon as a governance signal for DLP, audit, or compliance controls.

---

## Automatic Sensitivity Labels — The Solution

**Automatic Sensitivity Labels** in Microsoft Purview allow the platform to automatically detect sensitive information patterns in Microsoft 365 content and apply — or recommend — a sensitivity label without user intervention.

This provides:
- **Consistent classification** across high-volume content
- **Zero-miss detection** for known sensitive information patterns (credit cards, passport numbers, healthcare identifiers)
- **Retroactive coverage** — auto-labeling policies can scan existing content in SharePoint and OneDrive
- **Scalable governance** — labels applied at platform level, not dependent on individual user actions

---

## How Auto-Labeling Works

Microsoft Purview uses a **content inspection and policy evaluation pipeline**:

```
Content Exists / Is Created
          ↓
Microsoft Purview Scans Content
(Sensitive Information Types, Keywords, Classifiers)
          ↓
Auto-Labeling Policy Evaluated
          ↓
Match Found?
    ├── YES → Apply label (Automatic mode) or Recommend label (Recommended mode)
    └── NO  → No action
          ↓
Protection Applied via Label
```

---

## Detection Methods

### 1. Sensitive Information Types (SITs)
Built-in pattern-based detectors that recognize structured sensitive data:

| Sensitive Information Type | Example Detected |
|---|---|
| Credit Card Number | 4111-1111-1111-1111 |
| Passport Number | UK/US/EU format passports |
| Bank Account Number | IBAN, SWIFT, routing numbers |
| Tax Identification Number | SSN, NI number, TFN |
| Healthcare Record Identifiers | NHS, Medicare numbers |
| EU National Identifiers | National ID card numbers |
| Personal Email Address | email@domain.com patterns |

Microsoft provides hundreds of built-in SITs. Custom SITs can be created for organization-specific patterns (employee IDs, project codes, proprietary data formats).

### 2. Trainable Classifiers
AI-powered classifiers that understand **document context and intent**, not just pattern matching:

| Classifier | Content Type Detected |
|---|---|
| Financial Documents | Spreadsheets with financial data |
| Contracts | Legal agreement documents |
| Resumes / CVs | Career profile documents |
| Source Code | Programming language files |
| HR Records | Employee-related documents |
| Business Plans | Strategy and planning documents |
| Customer Complaints | Support and feedback content |

Trainable Classifiers are more sophisticated than SITs but require Microsoft 365 E5 licensing and in some cases require training data.

### 3. Keywords and Keyword Lists
Simple keyword matching for custom detection scenarios:
- "TOP SECRET", "CLASSIFIED", "DO NOT FORWARD"
- Internal project codenames
- Specific terminology (e.g., "salary", "compensation", "merger")

### 4. Exact Data Match (EDM)
Schema-based exact matching against a known sensitive data set (e.g., a list of employee SSNs or customer account numbers). Used for high-precision detection where false positives are unacceptable.

---

## Auto-Labeling Lab: Finance Confidential Policy

### Lab Configuration Summary

For this lab, an auto-labeling policy was configured with the following parameters:

| Setting | Value |
|---|---|
| Policy name | Finance Confidential Auto-Label |
| Detection method | Sensitive Information Type: Credit Card Number |
| Minimum instance count | 1 (any single match triggers the policy) |
| Label applied | Finance Confidential |
| Labeling mode | Simulation / Review (lab environment) |
| Scope | Exchange Online, SharePoint Online, OneDrive |

> **Lab note:** The policy was created and reviewed in the Purview portal. Full simulation and automatic enforcement require content containing matching patterns to exist in the scanned workloads.

---

## Step-by-Step Lab: Creating an Auto-Labeling Policy

### Step 1 — Open Microsoft Purview Portal
Navigate to `compliance.microsoft.com` and sign in as Global Administrator or Compliance Administrator.

### Step 2 — Review Sensitive Information Types
```
Information Protection → Classifiers → Sensitive info types
```

Review built-in patterns. For this lab, locate: **Credit Card Number**

The Credit Card Number SIT uses Luhn algorithm validation + keyword proximity to detect valid credit card numbers across major card networks (Visa, Mastercard, Amex, Discover).

![Sensitive Information Types page showing Credit Card Number SIT selected](../images/05-auto-labels/05-sensitive-info-type-selection.avif)
*Appendix A.10 — Sensitive Information Types — Credit Card Number pattern selected*

### Step 3 — Create the Finance Confidential Label
If not already created (see [04 — Manual Sensitivity Labels](04-manual-sensitivity-labels.md)):
```
Information Protection → Sensitivity labels → Create a label
```
Label name: `Finance Confidential`
Protection: Encryption — Finance group permissions

![Finance Confidential sensitivity label configuration — auto-labeling settings enabled](../images/05-auto-labels/01-create-label-basic-settings.avif)
*Appendix A.11 — Finance Confidential label configuration — auto-labeling conditions*

### Step 4 — Create an Auto-Labeling Policy
```
Information Protection → Auto-labeling → Create auto-labeling policy
```

![Auto-labeling policy creation wizard in Microsoft Purview portal](../images/05-auto-labels/09-auto-labeling-policy-wizard.avif)
*Appendix A.12 — Auto-labeling policy wizard — Information Protection → Auto-labeling → Create policy*

### Step 5 — Configure Detection Rules
Select: **Custom policy** (or use a template)

Add condition:
- Detection type: **Sensitive Information Types**
- SIT selected: **Credit Card Number**
- Instance count: **1** (at least one match)
- Confidence: High confidence

### Step 6 — Select the Label
Apply label: **Finance Confidential**

### Step 7 — Select Labeling Mode

| Mode | Behavior | When to Use |
|---|---|---|
| **Simulation** | Detects matches but does not apply labels; results viewable in portal | First-run validation, testing detection accuracy |
| **Recommended** | Microsoft 365 suggests the label to users; users accept or reject | Transition period — building user awareness |
| **Automatic** | Label applied without user action | Production enforcement |

**Lab recommendation:** Begin in Simulation mode. Review matches before enabling automatic enforcement.

### Step 8 — Select Locations (Scope)
Enable:
- ✅ Exchange Online (emails)
- ✅ SharePoint Online (sites and files)
- ✅ OneDrive (personal files)

Optionally restrict to specific sites, accounts, or distribution groups.

### Step 9 — Review and Create
Review all policy settings:
- Detection rules
- Label to apply
- Mode (simulation/automatic)
- Locations

Select: **Create policy**

![Auto-labeling policy summary and review page showing Credit Card Number detection rule](../images/05-auto-labels/11-auto-labeling-policy-review.avif)
*Appendix A.13 — Auto-labeling policy review — Credit Card Number rule, Finance Confidential label, Exchange/SharePoint/OneDrive scope*

### Step 10 — Validate Auto-Labeling

**Simulation mode validation:**
1. After the policy runs its first simulation scan, navigate to the policy in the portal
2. Select: **View simulated results** (or Activity Explorer)
3. Review: Items that would be labeled, detection confidence scores, locations

**Automatic mode validation:**
1. Create a test document containing: `4111-1111-1111-1111` (test Visa number)
2. Upload to OneDrive or SharePoint
3. Wait for the auto-labeling policy scan cycle (typically within 24 hours)
4. Verify the **Finance Confidential** label is applied in file properties

---

## Recommended vs. Automatic Labeling

| Feature | Recommended Labeling | Automatic Labeling |
|---|---|---|
| User sees a prompt | Yes | No |
| User must approve | Yes | No |
| Fully automated | No | Yes |
| Audit event generated | Yes | Yes |
| User can change label | Yes | Yes (with justification if configured) |
| Best for | Initial rollout, user training | Mature environments, high-volume content |

**Best practice:** Start with Recommended mode during initial deployment. Move to Automatic after validating detection accuracy and user readiness.

---

## Licensing Requirements

| Capability | License Required |
|---|---|
| Sensitivity labels (manual) | Microsoft 365 E3 / Business Premium |
| Auto-labeling (Office apps, client-side) | Microsoft 365 E3 |
| Auto-labeling policies (service-side: SharePoint, OneDrive, Exchange) | **Microsoft 365 E5** or Microsoft Purview Information Protection add-on |
| Trainable Classifiers | **Microsoft 365 E5** |
| Exact Data Match (EDM) | **Microsoft 365 E5** |

> **Lab note:** Auto-labeling policies (service-side) require Microsoft 365 E5. Some Microsoft 365 E3 environments may not display the **Auto-labeling** section under Information Protection until the appropriate license is assigned. If the Auto-labeling menu is not visible, verify licensing in the Microsoft 365 Admin Center.

---

## Common Administrator Mistakes

| Mistake | Impact | Correct Approach |
|---|---|---|
| Skipping simulation mode | Incorrect labels applied at scale | Always run simulation first; review matches |
| Using overly broad keywords | High false positive rate | Use SITs with confidence scoring instead of bare keywords |
| Enabling automatic enforcement tenant-wide too early | User disruption at scale | Pilot with a small group or specific SharePoint site first |
| Not monitoring Activity Explorer | Detection accuracy drift | Review auto-label activity weekly during initial rollout |
| Expecting real-time labeling | Frustration during testing | Service-side auto-labeling runs on scan cycles — not instant |

---

## MS-102 Exam Tip

Exam scenario: *"A company wants Microsoft 365 to automatically classify and protect documents containing financial information without relying on users."*

Correct answer: **Automatic Sensitivity Labels (Auto-Labeling Policy)**

Key distinction from the exam perspective:
- **Auto-labeling in label settings** = client-side, per label, recommends/applies in Office apps
- **Auto-labeling policies** = service-side, scans existing content in SharePoint/OneDrive/Exchange at scale

---

## Related Documentation

- [02 — Sensitivity Labels Taxonomy](02-sensitivity-labels-taxonomy.md)
- [04 — Manual Sensitivity Labels](04-manual-sensitivity-labels.md)
- [06 — Protection Settings and Encryption](06-protection-settings-encryption.md)
- [07 — Validation and Testing](07-validation-testing.md)

---

*Auto-labeling policy created and reviewed in compliance.microsoft.com. Full simulation results require content matching the Credit Card Number SIT to exist in scanned workloads. No detection results have been fabricated.*
