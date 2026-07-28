---
name: ads-live-operator
description: Use this skill when the user asks Codex to investigate, audit, optimize, or safely change live advertising accounts such as Google Ads, Meta Ads, Microsoft Ads, or other paid media platforms. Trigger for ROAS drops, CPA spikes, campaign audits, search term cleanup, conversion tracking warnings, budget or bidding checks, live Chrome-backed ad platform work, and approved live ad account changes. Do not use for generic marketing brainstorming, website SEO, GA4-only analysis, or ad copy only.
---

# Ads Live Operator

Use this workflow for live advertising account work.

## Workflow

1. Confirm the business, account, date range, objective, and whether live changes are allowed.
2. Pick the access path: API/export/connector when available; `@Chrome` in the ChatGPT desktop app or `playwright-live-chrome` in Codex CLI for signed-in ad platforms and web checks; and `@Browser` only if the user explicitly requests it or approves fallback.
3. Pull live evidence before making recommendations.
4. Separate read-only findings from mutation candidates.
5. Diagnose patterns without hard-coding account-specific fixes.
6. Rank actions by impact, confidence, reversibility, and risk.
7. Stop before live changes unless the user approved a specific action.
8. Before mutation, capture before-state.
9. Apply only the approved change.
10. Verify after-state.
11. Record what changed, why, rollback path, and next check-in date.

## Evidence Rules

- Read `references/evidence-checklist.md` before live account analysis.
- Read `references/browser-workflow.md` before Chrome-backed ad platform work.
- Read `references/diagnostic-patterns.md` when interpreting performance changes.
- Read `references/change-safety.md` before any live mutation.
- Treat live UI screenshots, exported reports, and account settings as evidence.
- Treat specialist or model opinions as review input, not evidence.
- For GA4-only work, use `analytics-live-analyst`. For Ads plus GA4 or booking/revenue reconciliation, use `cross-channel-performance-diagnosis`.

## Output Shape

Return:

- evidence summary
- ranked action queue
- approved or blocked changes
- verification performed
- remaining risks
- next check-in timing
