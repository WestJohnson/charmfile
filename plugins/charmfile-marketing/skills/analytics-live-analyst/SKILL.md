---
name: analytics-live-analyst
description: Use this skill when the user asks Codex to investigate or audit Google Analytics, GA4, Looker Studio, or other analytics data. Trigger for traffic drops, revenue drops, funnel issues, source/medium analysis, landing page performance, ecommerce or booking analytics, key event or conversion tracking checks, and Chrome-backed analytics reads. Do not use for live ad platform mutations or generic SEO brainstorming.
---

# Analytics Live Analyst

Use this workflow for analytics investigation and read-only diagnostics.

## Workflow

1. Confirm business, analytics property/report, date range, comparison range, and business question.
2. Pick the access path: connector/export/API when available, `@Chrome` in the ChatGPT desktop app or `playwright-live-chrome` in Codex CLI for signed-in GA4 or Looker Studio, and local files when the user provides exports.
3. Capture report context before interpreting: account/property, date basis, filters, segments, channel grouping, and metric definitions.
4. Pull evidence at the smallest useful grain: channel, campaign, source/medium, landing page, device, location, event, item, funnel step, or user path.
5. Separate observed facts from hypotheses.
6. Rank likely causes by evidence strength, business impact, and next verification step.
7. Do not mutate analytics settings unless the user approves the exact change.

## References

- Read `references/ga4-evidence-checklist.md` before analytics analysis.
- Read `references/analytics-diagnostics.md` when interpreting changes or anomalies.

## Output Shape

Return:

- evidence summary
- root-cause hypotheses ranked by confidence
- checks performed
- recommended next reads or exports
- any blocked settings changes
- remaining risks
