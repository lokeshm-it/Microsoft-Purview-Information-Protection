# Manual Sensitivity Labels

## What Is Manual Labeling?

Manual sensitivity labeling is the process by which users or administrators **explicitly select and apply** a sensitivity label to a document, email, or other Microsoft 365 content. The user takes a deliberate action — choosing the classification level that best describes the content they are creating or editing.

Manual labeling is the foundation of any Microsoft Purview Information Protection deployment. It establishes the classification culture within an organization before more advanced capabilities (automatic labeling, DLP, eDiscovery) are layered on top.

---

## Why Manual Labeling First?

Best practice across enterprise deployments is to begin with manual labeling before enabling automatic labeling:

| Reason | Detail |
|---|---|
| **User awareness** | Users learn what labels mean and why classification matters |
| **Accuracy validation** | Administrators verify label names and descriptions are user-friendly |
| **Adoption measurement** | Activity Explorer shows whether users are engaging with labels |
| **Policy testing** | Edge cases surface before automated enforcement creates user friction |
| **Lower risk** | Manual errors are individual; auto-label errors scale |

---

## Manual Labeling Workflow

```
User Creates Content
        ↓
Office App / Outlook displays Sensitivity bar
        ↓
User selects appropriate sensitivity label
        ↓
Label metadata embedded in file / email headers
        ↓
Protection settings applied (encryption, permissions, marking)
        ↓
Protected content travels with label
```

---

## Where Users Apply Labels

### Office Desktop Apps (Word, Excel, PowerPoint)
Location: **Home tab → Sensitivity** button  
The sensitivity bar appears below the ribbon, showing the current label.

### Outlook (Desktop)
Location: **New Message → Sensitivity** button (or Message tab)  
The sensitivity option appears in the message composition toolbar.

### Office on the Web (Word Online, Excel Online)
Location: **Sensitivity** button in the ribbon  
Requires label policy sync to complete before labels are visible.

### SharePoint Online
Location: **File properties → Sensitivity label** column  
Labels can be applied directly from SharePoint document libraries.

### Microsoft Teams
Location: File labels appear in the Files tab within a Teams channel

---

## Enterprise Label Scenarios

The following table documents realistic enterprise classification scenarios used in this lab:

| Business Scenario | Recommended Label | Protection Applied |
|---|---|---|
| Internal project planning document | Internal Projects | Encryption — internal users only |
| Client contract or proposal | Client Confidential | Encryption — named account team |
| Financial budget spreadsheet | Finance Restricted | Encryption — Finance group |
| Board presentation deck | Executive Confidential | Encryption — leadership group only |
| Public press release draft | Public | No encryption |
| Internal team meeting notes | General | No encryption |
| Document containing credit card data | Finance Confidential | Encryption — auto-label also targets this |

---

## Step-by-Step Lab: Creating and Publishing a Manual Label

### Step 1 — Open Microsoft Purview Portal
Navigate to `compliance.microsoft.com` and sign in as Global Administrator or Compliance Administrator.

![Microsoft Purview portal home page — compliance.microsoft.com](../images/01-overview/01-purview-portal-home.avif)
*Appendix A.3 — Microsoft Purview portal home page (compliance.microsoft.com)*

### Step 2 — Navigate to Sensitivity Labels
```
Information Protection → Sensitivity labels
```
Review the existing label taxonomy, including default labels and any previously created custom labels.

![Sensitivity Labels page showing the full label list in Information Protection](../images/02-sensitivity-labels/01-sensitivity-labels-list.avif)
*Appendix A.4 — Sensitivity Labels page — Information Protection → Sensitivity labels*

### Step 3 — Create a New Label
Select **Create a label**.

Configure:
- **Name**: `Finance Restricted` (internal)
- **Display name**: `Finance Restricted`
- **Description for users**: "Apply to financial records, budget files, and audit documents. Restricted to the Finance team."
- **Color**: Purple

![Create sensitivity label — basic properties screen showing name and description fields](../images/02-sensitivity-labels/12-create-label-basic-info.avif)
*Appendix A.5 — Create sensitivity label — basic properties (name, display name, description)*

### Step 4 — Configure Label Scope
Enable:
- ✅ Files and other data assets
- ✅ Emails

> Groups & Sites scope is not available in this lab tenant. This is a known limitation for trial environments requiring additional Entra/M365 integration.

![Label scope selection page — Files, Emails, and Groups & Sites options](../images/02-sensitivity-labels/13-label-scope-selection.avif)
*Appendix A.6 — Label scope selection — Files and other data assets, Emails*

### Step 5 — Configure Protection Settings
Enable **Access control**.

Select: **Assign permissions now**

Configure:
- Add users or groups: `Finance@patchthecloud.onmicrosoft.com` (or equivalent Finance group)
- Permission level: **Co-Author** (can read, edit, save, print — cannot change permissions)
- Content expiration: None (for this lab)

![Access control configuration showing permission assignment for Finance group](../images/02-sensitivity-labels/15-assign-permissions-groups.avif)
*Appendix A.7 — Access control — assign permissions, Finance group, Co-Author level*

### Step 6 — Content Marking (Optional)
For this foundational lab, content marking is **not enabled** to keep the configuration simple and focused on manual sensitivity label deployment.

Organizations that require visual classification indicators should enable:
- Watermarks (e.g., "FINANCE RESTRICTED" stamped on every page)
- Headers (e.g., "CONFIDENTIAL" at the top of each page)
- Footers (e.g., classification level and handling instructions)

### Step 7 — Publish the Label
Navigate to:
```
Information Protection → Label policies → Publish labels
```

Select:
- Labels to publish: `Finance Restricted` (add to existing policy or create new)
- Assign to: Finance group users (or all users if tenant-wide)
- Enable: Require users to apply a label

![Label policy configuration showing Finance Restricted label included and policy settings](../images/03-label-policies/05-publish-label-policy-settings.avif)
*Appendix A.8 — Label policy settings — Finance Restricted label, mandatory labeling enabled*

### Step 8 — Wait for Policy Synchronization
After publishing, allow up to 24 hours for synchronization across Microsoft 365 services. In Office desktop apps, restart the application and sign in again to trigger label refresh.

### Step 9 — Apply the Label
Open Microsoft Word (desktop or web). Create a new document.

Select: **Sensitivity** → **Finance Restricted**

The document is now:
- Classified as Finance Restricted
- Encrypted using Azure RMS
- Restricted to Finance team members

![Microsoft Word with Finance Restricted sensitivity label applied in the sensitivity bar](../images/04-manual-labels/03-label-applied-word.avif)
*Appendix A.9 — Word document showing Finance Restricted label applied — Azure RMS encryption active*

### Step 10 — Test Protected Content
Save the document. Attempt to open it with a non-Finance account.

Expected result: Access denied — the user does not have permissions to open this document.

This confirms that the label's access control settings are functioning correctly.

---

## Best Practices for Manual Sensitivity Labels

### 1. Keep Label Names Simple
Users should immediately understand the classification level from the label name. Avoid technical jargon like "RMS-Encrypted-Level-3" — use plain-language names like "Finance Restricted".

### 2. Avoid Label Proliferation
Organizations with more than 8–10 visible labels see lower adoption rates. Consolidate similar classification needs into fewer, broader labels. Use sublabels to provide specificity without overcrowding the main list.

### 3. Start with Manual Labels Before Automation
Building classification culture through manual labeling first allows organizations to:
- Validate label names and descriptions with real users
- Identify common patterns that could later be automated
- Measure adoption before enforcement
- Train users before automation removes the decision from them

### 4. Use Realistic Business Scenarios
Enterprise-style labels like "Client Confidential" and "Finance Restricted" improve adoption because users recognize the business context. Abstract labels like "Level 3" do not convey meaning.

### 5. Test Policies Before Production Deployment
Always validate label behavior in a pilot group before organization-wide rollout. Confirm encryption works, authorized users can access content, and unauthorized users are blocked.

---

## Common Administrator Mistakes

| Mistake | Impact | Correct Approach |
|---|---|---|
| Creating overly complex label hierarchies | User confusion, low adoption | Maximum 2 levels; maximum ~8 visible labels |
| Applying maximum restrictions to all labels | Blocks collaboration, drives workarounds | Match restriction level to actual sensitivity |
| Skipping user training | Users apply labels incorrectly | Provide tooltips, help documentation, and training |
| Expecting instant synchronization | Testing fails prematurely | Wait 24h after policy publish before testing |
| Not testing with a non-admin account | Encryption issues only surface for normal users | Always test label behavior with a standard user account |

---

## MS-102 Exam Tip

Exam scenario: *"A company wants employees to manually classify and protect confidential emails and Office documents using Microsoft Purview."*

Correct answer: **Sensitivity Labels** (published via Label Policy, applied manually by users)

NOT: Retention Policies (govern lifecycle, not classification), Conditional Access (governs access, not content), Microsoft Defender XDR (threat protection, not labeling)

---

## Related Documentation

- [02 — Sensitivity Labels Taxonomy](02-sensitivity-labels-taxonomy.md)
- [03 — Label Policies and Publishing](03-label-policies-publishing.md)
- [05 — Automatic Sensitivity Labels](05-automatic-sensitivity-labels.md)
- [06 — Protection Settings and Encryption](06-protection-settings-encryption.md)

---

*All lab steps documented here reflect configurations performed in a real Microsoft 365 E5 trial tenant. No steps have been fabricated. Screenshots referenced as "Screenshot Required" indicate images not captured during the lab session.*
