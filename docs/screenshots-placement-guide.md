# Screenshots Placement Guide — Microsoft Purview Information Protection

## Overview

38 Microsoft Purview portal screenshots extracted from the three source blog posts and organised into implementation phase subfolders under `images/`. All files are `.avif` format, sourced directly from techcertguide.blog.

Run `Move-MipImages.ps1` (repo root) after browser downloads complete to place files automatically.

---

## Folder Structure

```
images/
├── 01-overview/                          # Purview portal navigation
│   ├── 01-purview-portal-home.avif
│   ├── 02-information-protection-solution.avif
│   └── 03-sensitivity-labels-navigation.avif
├── 02-sensitivity-labels/                # Label creation wizard
│   ├── 01-sensitivity-labels-list.avif
│   ├── 02-create-label-name.avif
│   ├── 03-create-label-description.avif
│   ├── 04-label-scope-files-emails.avif
│   ├── 05-label-protection-settings.avif
│   ├── 06-label-access-control.avif
│   ├── 07-label-content-marking.avif
│   ├── 08-label-header-footer.avif
│   ├── 09-label-auto-labeling.avif
│   ├── 10-label-review-finish.avif
│   ├── 11-label-created-confirmation.avif
│   ├── 12-create-label-basic-info.avif
│   ├── 13-label-scope-selection.avif
│   ├── 14-protection-access-control.avif
│   └── 15-assign-permissions-groups.avif
├── 03-label-policies/                    # Publishing labels
│   ├── 01-publish-label-start.avif
│   ├── 02-publish-label-policy-name.avif
│   ├── 03-publish-label-choose-labels.avif
│   ├── 04-publish-label-scope-users.avif
│   ├── 05-publish-label-policy-settings.avif
│   └── 06-policy-synchronization-status.avif
├── 04-manual-labels/                     # Manual label application
│   ├── 01-purview-portal-admin-view.avif
│   ├── 02-sensitivity-labels-overview.avif
│   └── 03-label-applied-word.avif
├── 05-auto-labels/                       # Auto-labeling policy
│   ├── 01-create-label-basic-settings.avif
│   ├── 02-create-label-scope.avif
│   ├── 03-auto-labeling-enable.avif
│   ├── 04-auto-labeling-conditions.avif
│   ├── 05-sensitive-info-type-selection.avif
│   ├── 06-credit-card-sit-configuration.avif
│   ├── 07-auto-label-review-finish.avif
│   ├── 08-publish-auto-label-policy.avif
│   ├── 09-auto-labeling-policy-wizard.avif
│   ├── 10-auto-labeling-policy-scope.avif
│   └── 11-auto-labeling-policy-review.avif
└── 06-validation/                        # (reserved for validation screenshots)
```

---

## Appendix Map — Documentation References

| Appendix | Image File | Document | Section | Phase |
|---|---|---|---|---|
| A.1 | `02-sensitivity-labels/01-sensitivity-labels-list.avif` | `02-sensitivity-labels-taxonomy.md` | Label Taxonomy | Overview |
| A.2 | `03-label-policies/05-publish-label-policy-settings.avif` | `03-label-policies-publishing.md` | Label Policy Configuration | Label Policies |
| A.3 | `01-overview/01-purview-portal-home.avif` | `04-manual-sensitivity-labels.md` | Step 1 | Overview |
| A.4 | `02-sensitivity-labels/01-sensitivity-labels-list.avif` | `04-manual-sensitivity-labels.md`, `07-validation-testing.md` | Step 2 / TC-01 | Sensitivity Labels |
| A.5 | `02-sensitivity-labels/12-create-label-basic-info.avif` | `04-manual-sensitivity-labels.md` | Step 3 | Sensitivity Labels |
| A.6 | `02-sensitivity-labels/13-label-scope-selection.avif` | `04-manual-sensitivity-labels.md` | Step 4 | Sensitivity Labels |
| A.7 | `02-sensitivity-labels/15-assign-permissions-groups.avif` | `04-manual-sensitivity-labels.md` | Step 5 | Sensitivity Labels |
| A.8 | `03-label-policies/05-publish-label-policy-settings.avif` | `04-manual-sensitivity-labels.md` | Step 7 | Label Policies |
| A.9 | `04-manual-labels/03-label-applied-word.avif` | `04-manual-sensitivity-labels.md`, `07-validation-testing.md` | Step 9 / TC-03 | Manual Labels |
| A.10 | `05-auto-labels/05-sensitive-info-type-selection.avif` | `05-automatic-sensitivity-labels.md` | Step 2 | Auto Labels |
| A.11 | `05-auto-labels/01-create-label-basic-settings.avif` | `05-automatic-sensitivity-labels.md` | Step 3 | Auto Labels |
| A.12 | `05-auto-labels/09-auto-labeling-policy-wizard.avif` | `05-automatic-sensitivity-labels.md` | Step 5 | Auto Labels |
| A.13 | `05-auto-labels/11-auto-labeling-policy-review.avif` | `05-automatic-sensitivity-labels.md`, `07-validation-testing.md` | Step 9 / TC-08 | Auto Labels |
| A.14 | `02-sensitivity-labels/14-protection-access-control.avif` | `06-protection-settings-encryption.md` | Protection Settings | Sensitivity Labels |

---

## Source Blog Posts

| Post | URL | Screenshots |
|---|---|---|
| Post 1 — MIP Overview | techcertguide.blog/microsoft-information-protection-ms102/ | image.avif, image-2 to image-17 (16 images) |
| Post 2 — Manual Labels | techcertguide.blog/manual-sensitivity-labels-in-microsoft-purview/ | image-21 to image-32 (11 images) |
| Post 3 — Auto Labels | techcertguide.blog/automatic-sensitivity-labels-in-microsoft-purview/ | image-34 to image-46 (11 images) |

**Total: 38 portal screenshots extracted. 0 missing.**

---

## Image Reference Format in Docs

```markdown
![Description](../images/FOLDER/FILENAME.avif)
```

Example:
```markdown
![Sensitivity Labels list showing full label taxonomy in Microsoft Purview portal](../images/02-sensitivity-labels/01-sensitivity-labels-list.avif)
```

---

*Screenshots extracted from techcertguide.blog via browser rendering. All images show real Microsoft Purview portal configurations in tenant Patchthecloud.onmicrosoft.com.*
