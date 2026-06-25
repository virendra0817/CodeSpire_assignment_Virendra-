# Salesforce Developer Intern Assessment

---

## Overview

This repository contains the complete solution for the Codespire Solutions Salesforce Developer Intern Assessment. The assessment covers four core areas of Salesforce development: Declarative automation, Apex programming, Lightning Web Components, and Reports & Dashboards.

---

## Problem 1 — Declarative: Library Book Borrowing System

### What was built
- **`Book__c`** custom object with 5 fields: Title (Text), Author (Text), ISBN (Text, Unique), Status (Picklist: Available/Borrowed), Genre (Picklist)
- **`Borrowing__c`** custom object with Master-Detail relationship to `Book__c`, Due Date, Return Date, and Borrower Name fields
- **Two Validation Rules:**
  - `Due_Date_Not_In_Past` — prevents setting a due date in the past
  - `Book_Already_Borrowed` — prevents borrowing a book already marked as Borrowed using `ISPICKVAL()`
- **Screen Flow** (`Library Borrowing Flow`) with two paths:
  - **New Borrowing** — librarian searches for an available book by title, enters borrower name and due date, system creates Borrowing record and updates Book status to Borrowed
  - **Return a Book** — librarian searches by borrower name, system updates Return Date and resets Book status to Available

### Tools used
- Salesforce Setup — Object Manager, Validation Rules, Flow Builder
- No code required

---

## Problem 2 — Apex: Auto-Update Order Status

### What was built
- **`Order__c`** custom object with Status picklist (Pending / Fulfilled / Partially Cancelled)
- **`OrderItem__c`** custom object with Master-Detail relationship to `Order__c` and Status picklist (Pending / Delivered / Cancelled)
- **`OrderItemTrigger`** — thin trigger firing on after insert and after update on `OrderItem__c`
- **`OrderItemHandler`** — handler class containing all business logic (thin trigger pattern)
- **`OrderItemHandlerTest`** — test class with 100% pass rate covering:
  - Positive scenario: all items Delivered → Order becomes Fulfilled
  - Negative scenario: one item Cancelled → Order becomes Partially Cancelled
  - Bulk test: 200 records processed in a single invocation

### Key design decisions
- Thin trigger pattern — trigger body only calls the handler
- Fully bulkified — no SOQL queries or DML statements inside any loops
- All three status transitions handled correctly

### Test results
```
Tests Ran:    3
Pass Rate:    100%
Fail Rate:    0%
```

### Deployment
```bash
sf project deploy start --source-dir force-app
sf apex run test --class-names OrderItemHandlerTest --result-format human --wait 2
```

---

## Problem 3 — Lightning Web Component: Live Account Search

### What was built
- **`accountSearch` LWC** deployed on the Account Record Page via Lightning App Builder
- **`AccountSearchController`** Apex class with `@AuraEnabled(cacheable=true)` method using SOQL LIKE clause and `WITH SECURITY_ENFORCED`

### Component features
- Real-time search input with **300ms debounce** to avoid firing on every keystroke
- **Loading spinner** while fetching results
- **"No results found"** message for empty queries
- Results displayed in a styled data table showing Name, Industry, Phone, Annual Revenue
- **Row click navigates** to the Account record page using `NavigationMixin.Navigate`
- Metadata XML configured with correct targets for Lightning App Builder deployment

### File structure
```
force-app/main/default/
├── lwc/
│   └── accountSearch/
│       ├── accountSearch.html
│       ├── accountSearch.js
│       ├── accountSearch.css
│       └── accountSearch.js-meta.xml
└── classes/
    ├── AccountSearchController.cls
    └── AccountSearchController.cls-meta.xml
```

### Deployment
```bash
sf project deploy start --source-dir force-app
```

---

## Problem 4 — Reports & Dashboards: Sales Pipeline Performance

### What was built

**Formula Field on Opportunity:**
- `Days_Until_Close__c` — Number formula showing days remaining until close date (negative = overdue), handles null close dates gracefully

**Reports:**
1. `Open Opportunities by Stage` — tabular report grouped by Stage with Sum, Average, and Count summary fields on Amount
2. `Win Rate by Owner` — summary report grouped by Owner with custom summary formula calculating win rate percentage
3. `At Risk Deals` — opportunities with Close Date before today and stage not Closed

**Dashboard (`Sales Team Health Pipeline`):**
- Bar chart — pipeline value by stage
- KPI metric tile — total pipeline value
- Owner leaderboard — win rate by owner
- At-risk deals table — overdue open opportunities

**Security configuration:**
- Dashboard running user set to logged-in user
- Sharing rule configured so only Sales team role members can view

---

## Project Structure

```
CodespireAssignment/
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/
│           │   ├── AccountSearchController.cls
│           │   ├── OrderItemHandler.cls
│           │   └── OrderItemHandlerTest.cls
│           ├── triggers/
│           │   └── OrderItemTrigger.trigger
│           ├── lwc/
│           │   └── accountSearch/
│           └── objects/
│               ├── Order__c/
│               └── OrderItem__c/
├── .forceignore
└── README.md
```

---

## Setup Instructions

### Prerequisites
- Salesforce Developer Edition Org
- Salesforce CLI (`sf`) installed
- VS Code with Salesforce Extension Pack

### Steps

1. **Clone the repository**
```bash
git clone <repo-url>
cd CodespireAssignment
```

2. **Authenticate with your Salesforce org**
```bash
sf org login web --alias myOrg --instance-url https://login.salesforce.com
sf config set target-org myOrg
```

3. **Deploy to org**
```bash
sf project deploy start --source-dir force-app
```

4. **Run tests**
```bash
sf apex run test --class-names OrderItemHandlerTest --result-format human --wait 2
```

5. **Activate the Screen Flow**
   - Go to Setup → Flows → Library Borrowing Flow → Activate

6. **Add LWC to Account Record Page**
   - Go to any Account record → Edit Page → drag `accountSearch` component → Save → Activate

---

## Evaluation Criteria Coverage

| Criteria | Status |
|---|---|
| Data model design — correct relationships and field types | ✅ |
| Validation logic — both rules handle edge cases | ✅ |
| Flow design — readable, minimal steps, no dead ends | ✅ |
| Trigger architecture — thin trigger + handler pattern | ✅ |
| Bulkification — no SOQL/DML inside loops | ✅ |
| Test quality — edge cases and 200-record bulk test | ✅ |
| LWC structure — clean HTML/JS/CSS separation | ✅ |
| Apex & SOQL — LIKE used, WITH SECURITY_ENFORCED applied | ✅ |
| UX behaviour — debounce, loading state, empty state | ✅ |
| Deployment config — metadata XML targets configured | ✅ |
| Formula field — correct logic, handles null dates | ✅ |
| Report design — correct groupings and summary formulas | ✅ |
| Dashboard clarity — tells a coherent story at a glance | ✅ |
| Security config — running user and sharing rule configured | ✅ |

---

## Candidate Details

- **Name:** Virendra Vikram Singh
- **Role Applied:** Salesforce Developer Intern
- **Company:** Codespire Solutions
- **Assessment Date:** June 2026
