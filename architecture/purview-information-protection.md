# Architecture Diagrams — Microsoft Purview Information Protection

## Diagram 1: High-Level Information Protection Architecture

```mermaid
flowchart TB
    subgraph CONTENT["📄 Microsoft 365 Content"]
        EXO["📧 Exchange Online<br/>(Emails)"]
        SPO["📁 SharePoint Online<br/>(Files & Sites)"]
        ODB["💾 OneDrive<br/>(Personal Files)"]
        TEAMS["💬 Microsoft Teams<br/>(Messages & Files)"]
        OFFICE["📝 Office Apps<br/>(Word, Excel, PPT)"]
    end

    subgraph PURVIEW["🔵 Microsoft Purview Information Protection"]
        direction TB
        LABELS["🏷️ Sensitivity Labels<br/>Public → General → Confidential<br/>→ Highly Confidential<br/>→ Finance Restricted<br/>→ Finance Confidential<br/>→ Executive Confidential"]
        POLICY["📋 Label Policies<br/>Published to: All Users<br/>Mandatory labeling: ON"]
        AUTOLABEL["🤖 Auto-Labeling Policies<br/>Credit Card Number → Finance Confidential<br/>Mode: Simulation → Production"]
        CLASSIFIERS["🔍 Classifiers<br/>Sensitive Information Types<br/>Trainable Classifiers"]
    end

    subgraph PROTECTION["🔒 Protection Layer"]
        RMS["🔑 Azure RMS<br/>AES-256 Encryption<br/>Key Management"]
        PERM["👥 Permissions<br/>Co-Author / Viewer<br/>Group-based access"]
        PERSIST["♾️ Persistent Labels<br/>Travel with content<br/>Outside M365 boundary"]
    end

    subgraph DOWNSTREAM["📊 Downstream Controls"]
        DLP["🛡️ Purview DLP<br/>Label-based policies"]
        AUDIT["📋 Purview Audit<br/>Label activity logs"]
        DEFENDER["☁️ Defender for Cloud Apps<br/>Label-aware CASB"]
    end

    CONTENT --> PURVIEW
    LABELS --> POLICY
    POLICY -->|Publish| CONTENT
    CLASSIFIERS -->|Detect| AUTOLABEL
    AUTOLABEL -->|Apply label| CONTENT
    LABELS --> PROTECTION
    RMS --> PERM
    PROTECTION -->|Enforced on| CONTENT
    CONTENT --> DOWNSTREAM

    style PURVIEW fill:#0078D4,stroke:#005a9e,color:#fff
    style PROTECTION fill:#107C10,stroke:#004B00,color:#fff
    style CONTENT fill:#2b2b2b,stroke:#555,color:#fff
    style DOWNSTREAM fill:#6B2D8B,stroke:#4a1e6e,color:#fff
```

---

## Diagram 2: Label Application Sequence — Manual Labeling

```mermaid
sequenceDiagram
    actor User
    participant Word as Microsoft Word
    participant Purview as Microsoft Purview
    participant RMS as Azure RMS
    participant Recipient as File Recipient

    User->>Word: Creates new document
    Word->>User: Displays Sensitivity bar
    User->>Word: Selects "Finance Restricted"
    Word->>Purview: Requests label metadata
    Purview->>Word: Returns label + protection config
    Word->>RMS: Requests encryption key
    RMS->>RMS: Generates document key<br/>tied to Finance group identity
    RMS->>Word: Returns encrypted key + permissions
    Word->>Word: Encrypts document<br/>Embeds label metadata
    Word->>User: Document saved with label
    
    Note over User,Word: Document shared with Finance team member

    Recipient->>Word: Opens document
    Word->>RMS: Presents identity + requests use license
    RMS->>RMS: Verifies Recipient ∈ Finance group
    RMS->>Word: Issues use license (Co-Author rights)
    Word->>Recipient: Document opens — edit rights granted

    Note over User,Recipient: Unauthorized user attempt

    rect rgb(180, 30, 30)
        Recipient->>Word: Non-Finance user opens same document
        Word->>RMS: Presents identity + requests use license
        RMS->>RMS: Verifies identity NOT in Finance group
        RMS->>Word: Access denied
        Word->>Recipient: "You don't have permission to open this file"
    end
```

---

## Diagram 3: Auto-Labeling Detection Flow

```mermaid
flowchart LR
    subgraph SCAN["🔍 Auto-Labeling Scan"]
        direction TB
        EXO["📧 Exchange Online"]
        SPO["📁 SharePoint Online"]
        ODB["💾 OneDrive"]
        TRIGGER["⚡ Scan Trigger<br/>(Periodic cycle)"]
    end

    subgraph DETECT["🧠 Detection Engine"]
        SIT["Sensitive Information Types<br/>───────────────────<br/>• Credit Card Number<br/>• Passport Number<br/>• Bank Account Number<br/>• Healthcare Identifiers"]
        TRAIN["Trainable Classifiers<br/>───────────────────<br/>• Financial Documents<br/>• Contracts<br/>• HR Records"]
        KEYWORDS["Keyword Lists<br/>───────────────────<br/>• Custom terms<br/>• Project codes"]
    end

    subgraph EVAL["📋 Policy Evaluation"]
        RULE["Rule: Credit Card Number<br/>Min instances: 1<br/>Confidence: ≥85%"]
        MATCH{Match<br/>Found?}
        LABEL["Apply: Finance Confidential"]
        NOACTION["No action"]
    end

    subgraph MODE["⚙️ Policy Mode"]
        SIM["Simulation<br/>→ Log matches only<br/>→ No label applied"]
        REC["Recommended<br/>→ Suggest label to user<br/>→ User approves"]
        AUTO["Automatic<br/>→ Apply without<br/>user intervention"]
    end

    TRIGGER --> SCAN
    EXO & SPO & ODB --> DETECT
    SIT & TRAIN & KEYWORDS --> RULE
    RULE --> MATCH
    MATCH -->|YES| LABEL
    MATCH -->|NO| NOACTION
    LABEL --> MODE
    SIM & REC & AUTO -->|Protection Enforced| SPO

    style DETECT fill:#0078D4,stroke:#005a9e,color:#fff
    style EVAL fill:#107C10,stroke:#004B00,color:#fff
    style MODE fill:#6B2D8B,stroke:#4a1e6e,color:#fff
```

---

## Diagram 4: Sensitivity Label Taxonomy Mindmap

```mermaid
mindmap
  root((Microsoft Purview<br/>Information<br/>Protection))
    Label Taxonomy
      Public
        No encryption
        Safe for external distribution
      General
        No encryption
        Standard internal content
      Confidential
        Sublabels available
        Encryption on specific configs
        All Employees
        Specific People
        Recipients Only
      Highly Confidential
        Maximum restriction
        Sublabels
        All Employees
        Specific People
      Custom Labels
        Internal Projects
          Finance Restricted
          Executive Confidential
        Finance Confidential
          AUTO-LABEL TARGET
          Credit Card Number detection
        Client Confidential
    Protection Features
      Azure RMS Encryption
        AES-256
        Key management
        Persistent
      Access Control
        Co-Author
        Viewer
        Co-Owner
      Content Marking
        Headers
        Footers
        Watermarks
    Detection Methods
      Sensitive Information Types
        Pattern matching
        Luhn validation
        Keyword proximity
      Trainable Classifiers
        AI-powered
        Context-aware
        Document types
      Keywords
        Custom lists
        Project codes
    Published To
      All Users
        Mandatory labeling ON
        Justification required
    Workloads
      Exchange Online
      SharePoint Online
      OneDrive
      Teams
      Office Apps
```

---

## Diagram 5: Deployment Methodology (Gantt)

```mermaid
gantt
    title Microsoft Purview Information Protection Deployment
    dateFormat  YYYY-MM-DD
    axisFormat  %b %d

    section Phase 1 — Foundation
    Review default label taxonomy           :done,    p1a, 2026-01-12, 1d
    Create custom sensitivity labels        :done,    p1b, 2026-01-12, 1d
    Configure protection settings (RMS)     :done,    p1c, 2026-01-13, 2d
    Publish label policy — all users        :done,    p1d, 2026-01-14, 1d

    section Phase 2 — Validation
    Wait for policy synchronization (24h)   :done,    p2a, 2026-01-15, 1d
    Validate labels in Office apps          :done,    p2b, 2026-01-16, 1d
    Test encryption — Finance Restricted    :done,    p2c, 2026-01-16, 1d
    Test mandatory labeling enforcement     :done,    p2d, 2026-01-17, 1d
    Test label downgrade justification      :done,    p2e, 2026-01-17, 1d

    section Phase 3 — Automation
    Review Sensitive Information Types      :done,    p3a, 2026-02-01, 1d
    Create Finance Confidential label       :done,    p3b, 2026-02-01, 1d
    Configure auto-labeling policy          :done,    p3c, 2026-02-02, 2d
    Run simulation mode — review results    :done,    p3d, 2026-02-04, 7d
    Activate automatic enforcement          :done,    p3e, 2026-02-11, 1d

    section Phase 4 — Documentation
    Document label taxonomy                 :done,    p4a, 2026-06-01, 2d
    Write lab guides (blog posts)           :done,    p4b, 2026-06-03, 7d
    Build GitHub portfolio repository       :done,    p4c, 2026-07-03, 1d
```
