# Website Portfolio Card — Microsoft Purview Information Protection

## Portfolio Card Specification

For use in `m365-admin.html` and the GitHub Pages portfolio site.

---

### Card Details

| Field | Value |
|---|---|
| Title | Microsoft Purview Information Protection |
| Subtitle | Sensitivity Labels · Auto-Labeling · Azure RMS Encryption |
| Category | Data Governance & Compliance |
| Tech Stack | Microsoft Purview · Azure RMS · PowerShell |
| Status | Live |
| GitHub URL | https://github.com/lokeshm-it/Microsoft-Purview-Information-Protection |
| Theme Color | Teal (#00B4D8) / Purple (#6B2D8B) |

---

### Card Description (Short — for portfolio grid)

```
Enterprise sensitivity label taxonomy with manual labeling, auto-labeling policies 
using Credit Card Number detection, and Azure RMS encryption. MS-102 portfolio lab 
covering Microsoft Purview Information Protection across Exchange, SharePoint, OneDrive, 
and Teams.
```

### Card Description (Long — for portfolio page)

```
This lab demonstrates a complete Microsoft Purview Information Protection deployment 
covering sensitivity label creation (Public, General, Confidential, Highly Confidential, 
Finance Restricted, Finance Confidential, Executive Confidential), label policy publishing 
with mandatory labeling enforcement, manual user-driven labeling in Office apps and Outlook, 
and an auto-labeling policy that detects Credit Card Numbers using Microsoft Purview 
Sensitive Information Types and automatically applies the Finance Confidential label. 
Azure RMS encryption restricts access to authorized groups only. Implemented in a real 
Microsoft 365 E5 trial tenant (Patchthecloud.onmicrosoft.com).
```

---

### Key Metrics for Card Display

| Metric | Value |
|---|---|
| Labels Created | 9 (default + custom) |
| Auto-Label Rules | 1 (Credit Card Number → Finance Confidential) |
| Workloads Protected | 5 (Exchange, SharePoint, OneDrive, Teams, Office Apps) |
| Encryption Method | Azure RMS (AES-256) |
| Policy Mode | Simulation → Automatic |
| Mandatory Labeling | Enabled |

---

### Zero Trust Tags

```
Verify Explicitly · Least Privilege · Assume Breach · Data Protection
```

### Blog Post References

- [MIP Overview](https://techcertguide.blog/microsoft-information-protection-ms102/)
- [Manual Labeling](https://techcertguide.blog/manual-sensitivity-labels-in-microsoft-purview/)
- [Auto-Labeling](https://techcertguide.blog/automatic-sensitivity-labels-in-microsoft-purview/)
