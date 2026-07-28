---
name: cross-channel-performance-diagnosis
description: Use this skill when the user asks Codex to reconcile performance across ads, GA4, booking systems, ecommerce revenue, CRM, spreadsheets, or other marketing data sources. Trigger for Ads versus GA4 mismatches, ROAS or revenue drops with multiple data sources, paid traffic quality questions, attribution discrepancies, and business-level marketing performance diagnosis. Do not use for single-platform ad mutations or website-only launch review.
---

# Cross-Channel Performance Diagnosis

Use this workflow when no single platform can answer the business question.

## Workflow

1. Confirm the business outcome, source systems, date range, comparison range, and decision needed.
2. Collect platform evidence separately before reconciling.
3. Normalize metrics, attribution assumptions, currency, timezone, conversion date basis, and naming.
4. Build a source-by-source truth table.
5. Identify disagreements and explain which are expected versus suspicious.
6. Rank root-cause hypotheses by evidence strength and business impact.
7. Produce a next-action queue split into read-only checks, safe changes, and changes requiring explicit approval.

## References

- Read `references/reconciliation-checklist.md` before comparing platforms.

## Output Shape

Return:

- normalized metric table
- source disagreement summary
- ranked diagnosis
- next evidence needed
- action queue
- confidence and caveats
