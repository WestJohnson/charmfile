---
name: web-launch-review
description: Use this skill when the user asks Codex to review, test, improve, or prepare a website or landing page for launch. Trigger for mobile UI issues, visual QA, SEO readiness, speed/performance checks, accessibility checks, conversion clarity, navigation bugs, paid-traffic landing page QA, and production-readiness review. Do not use for live ads account changes, GA4-only analysis, or VPS/server audits.
---

# Web Launch Review

Use this workflow for websites, landing pages, and production-ready marketing pages.

## Workflow

1. Identify target site, repo, or local dev URL.
2. Inspect the implementation and run the site when needed.
3. Use `@Chrome` in the ChatGPT desktop app or `playwright-live-chrome` in Codex CLI for browser QA, including local previews and screenshots, unless the user explicitly requests another browser surface.
4. Verify desktop and mobile layouts.
5. Check navigation, forms, links, calls to action, and visible content.
6. Check SEO basics and local/business relevance when applicable.
7. Check paid-traffic conversion continuity when the page is tied to ads.
8. Check performance and accessibility with available local tools.
9. Fix issues directly when the user asked for implementation.
10. Re-test changed behavior.

## References

- Read `references/mobile-ui-checklist.md` for mobile and visual QA.
- Read `references/seo-checklist.md` for SEO launch review.
- Read `references/paid-traffic-conversion-checklist.md` when the page receives paid traffic or is connected to ad account performance.

## Output Shape

Return:

- issues found
- fixes made or recommended
- desktop/mobile verification
- remaining risks
- production readiness verdict
