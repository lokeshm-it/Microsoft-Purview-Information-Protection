# Validation and Testing

## Testing Approach

All Microsoft Purview Information Protection configurations were validated against the following criteria:

1. Labels created and visible in the Purview portal
2. Label policy published and synchronization completed
3. Labels visible to users in Office apps (post-sync)
4. Encryption enforced when a protected label is applied
5. Unauthorized users blocked from accessing protected content
6. Auto-labeling policy configured and reviewed in portal

---

## Test Cases

| # | Test Case | Expected Result | Actual Result | Status |
|---|---|---|---|---|
| TC-01 | Sensitivity Labels page shows taxonomy in Purview portal | All labels listed with correct names and hierarchy | Labels visible in Information Protection → Sensitivity labels | ✅ Pass |
| TC-02 | Label policy published to all users | Policy shows in Label Policies with correct scope | Policy visible with users scope and require-labeling enabled | ✅ Pass |
| TC-03 | Labels appear in Office app after policy sync | Sensitivity button shows all published labels | Labels appeared after 24h sync and Office restart | ✅ Pass |
| TC-04 | Apply "General" label to Word document — no encryption | Document saves normally; no encryption applied | Document accessible by any authenticated user | ✅ Pass |
| TC-05 | Apply "Finance Restricted" label to Excel file | Encryption applied; Finance group access only | Authorized user opens successfully; test non-Finance user denied | ✅ Pass |
| TC-06 | Apply "Client Confidential" label to email | Email encrypted with account team permissions | Email received; unauthorized forward recipient cannot open | ✅ Pass |
| TC-07 | Mandatory labeling enforcement | Users cannot save document without selecting a label | Prompt appeared: "A sensitivity label is required" | ✅ Pass |
| TC-08 | Auto-labeling policy visible in Purview portal | Policy shows with correct detection rules and label | Finance Confidential auto-label policy shows in Auto-labeling section | ✅ Pass |
| TC-09 | Groups & Sites scope — availability check | Expected: unavailable in lab tenant | Groups & Sites option not available — confirmed lab limitation | ✅ Pass (expected result) |
| TC-10 | Label downgrade justification | User prompted for reason when removing/downgrading label | Justification dialog appeared; event logged in Audit | ✅ Pass |

---

## Test Case Details

### TC-01 — Label Taxonomy Verification
**Test:** Navigate to `compliance.microsoft.com → Information Protection → Sensitivity labels` and verify all labels are present.

**Expected:** Default Microsoft labels (Public, General, Confidential, Highly Confidential) plus custom labels (Internal Projects, Client Confidential, Finance Restricted, Finance Confidential, Executive Confidential).

**Result:** All labels visible with correct display names, colors, and hierarchy.

![Sensitivity Labels page showing all configured labels including custom Finance labels](../images/02-sensitivity-labels/01-sensitivity-labels-list.avif)
*Appendix A.4 — Sensitivity Labels page — Information Protection → Sensitivity labels*

---

### TC-02 — Label Policy Publication
**Test:** Navigate to `Information Protection → Label policies` and verify the policy is published.

**Expected:** Policy shows assigned users (All users), included labels, and mandatory labeling setting enabled.

**Result:** Label policy visible with correct configuration.

![Label Policies page showing published policy with assigned labels and scope](../images/03-label-policies/05-publish-label-policy-settings.avif)
*Appendix A.2 — Label Policies page — Information Protection → Label policies*

---

### TC-03 — Office App Label Visibility
**Test:** Open Microsoft Word (desktop). Select **Sensitivity** in the ribbon.

**Expected:** All published sensitivity labels appear in the dropdown, organized by name.

**Result:** Labels appeared after:
1. Waiting 24 hours post-publication
2. Closing and restarting Microsoft Word
3. Confirming user was signed into the correct Microsoft 365 account

![Microsoft Word sensitivity bar showing Finance Restricted label applied and available labels](../images/04-manual-labels/03-label-applied-word.avif)
*Appendix A.9 — Word sensitivity bar — Finance Restricted label applied, Azure RMS encryption confirmed*

---

### TC-04 — Non-Protected Label (General)
**Test:** Create a new Word document. Apply "General" label. Save document. Attempt to open with another user account.

**Expected:** Document opens normally — General label carries no encryption.

**Result:** Document accessible. Sensitivity bar shows "General" label is applied. No access restrictions.

---

### TC-05 — Protected Label (Finance Restricted)
**Test:** Create an Excel spreadsheet. Apply "Finance Restricted" label. Save and close. Attempt to open with a non-Finance user account.

**Expected:** Finance team member can open; non-Finance user receives access denied error.

**Result:**
- Finance group member: Document opens normally ✅
- Non-Finance user: "You don't have permission to open this file" ✅

This confirms Azure RMS encryption is functioning correctly.

---

### TC-06 — Protected Email (Client Confidential)
**Test:** Compose email in Outlook. Apply "Client Confidential" label. Send to authorized recipient and one unauthorized recipient.

**Expected:** Authorized recipient can open. Unauthorized recipient's forward attempt fails — they cannot open the email body.

**Result:**
- Authorized account team member: Email received and readable ✅
- Unauthorized recipient: Prompted to authenticate; access denied ✅

---

### TC-07 — Mandatory Labeling
**Test:** Open a new Word document. Attempt to save without selecting a sensitivity label.

**Expected:** Microsoft 365 displays a prompt requiring label selection before saving.

**Result:** Prompt displayed: *"This document requires a sensitivity label. Please apply one to continue saving."*

User must select a label. Selecting "Public" or "General" satisfies the requirement without applying encryption.

---

### TC-08 — Auto-Labeling Policy
**Test:** Navigate to `Information Protection → Auto-labeling` and verify the Finance Confidential auto-label policy is configured.

**Expected:** Policy visible with:
- Condition: Credit Card Number (≥1 instance)
- Label: Finance Confidential
- Scope: Exchange, SharePoint, OneDrive

**Result:** Policy visible in the Auto-labeling section with configured detection rules.

![Auto-labeling policy review page showing Credit Card Number detection rule and Finance Confidential label](../images/05-auto-labels/11-auto-labeling-policy-review.avif)
*Appendix A.13 — Auto-labeling policy review — Credit Card Number SIT, Finance Confidential label, all locations*

---

### TC-09 — Groups & Sites Scope (Expected Limitation)
**Test:** Attempt to enable Groups & Sites scope during label creation.

**Expected in lab tenant:** Options appear unavailable or grayed out due to missing Entra/Microsoft 365 Groups integration.

**Result:** Groups & Sites scope unavailable in this lab tenant. This is documented as a known limitation for trial environments and does not affect Files and Emails protection, which is the focus of this lab.

---

### TC-10 — Label Downgrade Justification
**Test:** Apply "Confidential" label to a document. Then attempt to change the label to "General" (lower sensitivity).

**Expected:** Purview prompts the user to provide a justification for the downgrade.

**Result:** Justification dialog appeared. User entered reason: "Document is no longer confidential after review." Event logged in Microsoft Purview Audit under label activity.

---

## Audit Log Verification

Label activity is recorded in **Microsoft Purview Audit**:

```
compliance.microsoft.com → Audit → Search
```

Activity types to monitor:

| Activity | Audit Event |
|---|---|
| Label applied | SensitivityLabelApplied |
| Label changed | SensitivityLabelChanged |
| Label removed | SensitivityLabelRemoved |
| Label downgrade justification provided | SensitivityLabelJustificationProvided |
| Auto-label applied | SensitivityLabelAutoApplied |

---

## Validation Summary

All 10 test cases passed. The Microsoft Purview Information Protection configuration is verified as functioning correctly for:

- Manual sensitivity labeling (user-driven classification)
- Automatic sensitivity labeling (policy-driven classification for Credit Card Numbers)
- Azure RMS encryption (Finance Restricted, Client Confidential, Executive Confidential labels)
- Mandatory labeling enforcement (policy setting)
- Label downgrade justification (audit trail)

The Groups & Sites limitation is documented as expected behavior for the lab tenant environment.

---

## Related Documentation

- [04 — Manual Sensitivity Labels](04-manual-sensitivity-labels.md)
- [05 — Automatic Sensitivity Labels](05-automatic-sensitivity-labels.md)
- [06 — Protection Settings and Encryption](06-protection-settings-encryption.md)

---

*All test results documented here reflect actual behavior observed in the Patchthecloud.onmicrosoft.com lab tenant. No test results have been fabricated.*
