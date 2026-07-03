# Label Policies and Publishing

## Why Label Policies Exist

Creating a sensitivity label in the Microsoft Purview portal does not automatically make it visible to users. Labels must be **published** through a label policy before they appear in:

- The sensitivity bar in Office apps (Word, Excel, PowerPoint)
- The sensitivity option in Outlook
- SharePoint Online and OneDrive file properties
- Microsoft Teams file labels

Label policies control:
- **Which labels** are published
- **To whom** the labels are published (users, groups, administrative units)
- **Default label behavior** (e.g., require users to apply a label)
- **Policy justification** (require a reason when downgrading labels)

---

## Label Policy Configuration

### Navigation
```
compliance.microsoft.com → Information Protection → Label policies → Publish labels
```

### Policy Components

| Component | Purpose |
|---|---|
| **Labels to publish** | Select which sensitivity labels to include in this policy |
| **Users and groups** | Assign the policy to specific users, groups, or All users |
| **Default label (Email)** | Optionally set a default label for new emails |
| **Default label (Sites)** | Optionally set a default label for new SharePoint sites |
| **Default label (Meetings)** | Optionally set a default label for Teams meetings |
| **Require labeling** | Force users to apply a label before saving/sending |
| **Justification** | Require a reason when users remove or downgrade a label |
| **Help link** | Custom URL linking to internal classification guidelines |

---

## Lab Policy Configuration

### Policy: Purview Lab Policy

| Setting | Value |
|---|---|
| Labels published | All custom labels + Confidential + Highly Confidential |
| Published to | All users (tenant-wide) |
| Require labeling (Email) | Enabled |
| Require labeling (Files) | Enabled |
| Default label | None set — users select manually |
| Justification required | Enabled for label downgrade |

> **Note:** The "Require users to apply a label to their emails and documents" setting enforces classification as a mandatory step. Users cannot save a file or send an email in Office apps without first selecting a label.

---

## Publishing Process and Synchronization

After a label policy is published, there is a **synchronization period** before labels appear across Microsoft 365 services and Office applications.

| Service | Approximate Sync Time |
|---|---|
| Exchange Online (Outlook) | Up to 1 hour |
| SharePoint Online | Up to 24 hours |
| OneDrive | Up to 24 hours |
| Office apps (desktop) | Requires sign-out/sign-in or Office restart |
| Microsoft Teams | Up to 24 hours |

> **Important for lab environments:** In new Microsoft 365 trial tenants, label policy synchronization may take longer than in production environments. If labels do not appear immediately in Office apps after publishing, wait 24 hours and ensure the Office application has been restarted and the user has signed in with the correct account.

---

## Multiple Label Policies

Organizations can create multiple label policies for different user populations:

| Scenario | Policy Configuration |
|---|---|
| All employees | Publish Public, General, Confidential labels |
| Finance team | Add Finance Restricted, Finance Confidential labels |
| Legal team | Add Legal Confidential, Client Confidential labels |
| Executive leadership | Add Executive Confidential label |
| IT administrators | All labels including Highly Confidential sublabels |

When a user is subject to multiple label policies, the **policy with the highest priority** takes effect for conflicting settings (e.g., default label). All labels from all matching policies are combined and shown to the user.

---

## Policy Priority

Label policies have a priority order. When a user matches multiple policies:

- The policy with the **lowest priority number** (highest in the list) takes precedence for settings conflicts
- All **labels** from all matching policies are merged and visible to the user

Adjust policy priority in:
```
Information Protection → Label policies → [drag to reorder or use ↑↓ arrows]
```

---

## Mandatory Labeling — Why It Matters

Enabling "Require users to apply a label" changes labeling from optional to mandatory. This is the single most impactful policy setting for driving consistent classification coverage.

**Without mandatory labeling:**
- Users can save documents and send emails without any label
- Sensitive content goes unclassified and unprotected
- DLP policies have no label signal to act on

**With mandatory labeling:**
- Users must select a label before the action completes
- Every document and email is classified at creation time
- Classification coverage approaches 100% over time

**User experience:** Users receive a prompt: *"This document requires a sensitivity label. Please choose one to continue."* They can select any published label — including "General" or "Public" for low-sensitivity content — but cannot bypass the step entirely.

---

## Justification for Label Downgrade

When this policy setting is enabled, users who attempt to:
- Remove a label from a document
- Apply a lower-sensitivity label than the one currently applied

...are required to provide a written justification. The justification is logged in Microsoft Purview Audit, creating an accountability trail for label changes.

---

## Viewing Published Labels

To confirm which labels are published and to which users:

```
compliance.microsoft.com → Information Protection → Label policies
```

Each policy shows:
- Policy name
- Labels included
- Assigned users/groups
- Creation and last modified date

---

## Troubleshooting Label Visibility

If labels are not appearing for users after publishing:

| Issue | Resolution |
|---|---|
| Labels not in Office apps | Wait 24h, restart Office, re-sign in |
| Labels visible but no encryption | Confirm protection settings in label config |
| Groups & Sites labels missing | Check Entra/M365 Groups integration settings |
| Labels appear for admins but not users | Confirm users are in the policy scope |
| Wrong default label applied | Check policy priority — higher priority policy wins |

---

## Related Documentation

- [02 — Sensitivity Labels Taxonomy](02-sensitivity-labels-taxonomy.md)
- [04 — Manual Sensitivity Labels](04-manual-sensitivity-labels.md)
- [05 — Automatic Sensitivity Labels](05-automatic-sensitivity-labels.md)

---

![Label Policy configuration page showing published labels and policy settings in Microsoft Purview portal](../images/03-label-policies/05-publish-label-policy-settings.avif)
*Appendix A.2 — Label Policy configuration page — compliance.microsoft.com → Information Protection → Label policies*
