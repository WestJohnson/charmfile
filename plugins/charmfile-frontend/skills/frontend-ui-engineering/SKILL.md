---
name: frontend-ui-engineering
description: Use this skill when building or modifying user-facing interfaces, frontend components, layouts, navigation, responsive behavior, interaction states, or visual UX. Trigger when the output needs to look production-quality, mobile-ready, accessible, and aligned with the existing design system. Do not use for backend-only work, live ad account changes, GA4-only analysis, or final website launch review.
---

# Frontend UI Engineering

Build production-quality interfaces that look deliberate, work across devices, and hold up under real user interaction. This skill is for implementation and iteration, not just critique.

Adapted from Addy Osmani's `frontend-ui-engineering` agent skill, with local additions for Chrome-first verification, mobile QA, and Codex workflow boundaries.

The art-direction workflow is informed by Impeccable 4.0.2 and adapted to keep this skill lightweight, implementation-first, and compatible with established product design systems.

## Scope

Use this skill for:

- New UI components, pages, views, dashboards, forms, navigation, modals, and app shells.
- Changes to user-facing layouts, visual hierarchy, responsive behavior, interaction states, or frontend state.
- Fixing UI bugs such as broken mobile navigation, clipping, overlapping text, layout shift, inaccessible controls, missing states, and generic AI-looking layouts.
- Frontend work that needs real browser verification.

Do not use this skill for:

- Backend-only implementation.
- Final production readiness review. Use `web-launch-review` for full launch QA, SEO, performance, paid-traffic continuity, and conversion checks.
- Live ad account or analytics mutations.
- Pure design brainstorming with no implementation target.

## Operating Rules

1. Inspect the existing app before designing new patterns.
2. Use the repo's existing framework, component library, spacing scale, typography, color tokens, icon system, routing, state management, and test tools.
3. Prefer simple, composable components over large configuration-heavy abstractions.
4. Use real or realistic content so wrapping, empty states, long labels, and mobile behavior are visible.
5. Build loading, empty, error, disabled, active, hover, focus, and success states when they are natural for the workflow.
6. Make UI accessible by default, not as a cleanup pass.
7. Verify in Chrome unless the user explicitly asks for another browser surface.
8. Keep changes scoped to the requested UI unless a nearby fix is required for the feature to work.
9. For a new surface or major redesign, establish a compact direction contract before writing UI code.
10. For an extension or refinement, preserve the incumbent visual system rather than inventing a competing identity.

## Component Architecture

Prefer focused components with clear ownership:

- Presentation components render UI and accept explicit props.
- Container components handle data loading, mutations, permissions, and routing context.
- Hooks own reusable stateful behavior only when it is shared or complex enough to justify the abstraction.
- Types stay close to the component unless they are shared across modules.

Use colocated files when the repo supports it:

```text
src/components/ThingPanel/
  ThingPanel.tsx
  ThingPanel.test.tsx
  ThingPanel.stories.tsx
  use-thing-panel.ts
  types.ts
```

Avoid:

- Components that exceed roughly 200 lines without a strong reason.
- Passing props through several components that do not use them.
- Creating a global store for local UI state.
- Introducing a new component library, styling system, or animation stack unless the repo already uses it or the user explicitly asks.

## State Management

Choose the smallest state layer that fits:

- Local state: one component owns the state.
- Lifted state: two or three nearby components share it.
- URL state: filters, pagination, tabs, and shareable view state.
- Context: theme, auth, locale, feature flags, or read-heavy shared state.
- Server-state library: remote data, caching, background refresh, optimistic mutations.
- Global store: complex client state used across distant app areas.

Keep server data, optimistic UI, validation, and rollback behavior explicit. Do not hide mutation failure paths.

## Design Quality

Avoid generic AI UI patterns:

- Purple/indigo default palettes when they do not match the brand.
- Decorative gradient blobs, oversized cards, generic hero sections, and stock-looking grids.
- Excessive shadows, excessive border radius, and arbitrary spacing values.
- Placeholder copy that hides real layout problems.
- One-note color palettes where every surface is a variation of the same hue.

Prefer:

- Content-first layouts that match the domain and user workflow.
- Dense but readable information architecture for dashboards and operational tools.
- Established design tokens and semantic colors.
- Clear hierarchy using size, weight, spacing, alignment, and grouping.
- Icons from the existing icon library for icon-sized controls.

## Direction Before Code

For a new screen, landing page, app shell, or major redesign, read `references/art-direction-checklist.md` before implementation.

Resolve five things in no more than 120 words:

- **Thesis:** the one idea the surface owns and the category-default arrangement it refuses.
- **World:** the palette, typography, material, and component language that make it recognizable without its copy.
- **Story:** what the user understands, believes, and does in sequence.
- **First viewport:** the exact product proof, reading order, and primary action visible at the target viewport.
- **Form:** the composition and interaction pattern chosen because it fits this product, not because it is fashionable.

Treat this as a working contract, not a mood board. Build against it, then use it during visual verification to find timid or generic execution.

## Responsive Behavior

Design mobile-first, then expand.

Minimum viewports to consider:

- 320px narrow mobile.
- 390px common mobile.
- 768px tablet.
- 1024px small desktop.
- 1440px desktop.

Check:

- Navigation opens, closes, and remains usable on mobile.
- Text does not overflow buttons, cards, tables, tabs, or nav items.
- Controls have stable dimensions and do not resize the layout on hover, focus, loading, or validation.
- Primary touch targets aim for at least 44 × 44 CSS pixels and do not fall below 40 × 40 without a documented platform reason.
- Tables, grids, charts, and toolbars have deliberate mobile behavior.
- Sticky/fixed elements do not cover content or controls.
- On persuasive or discovery surfaces at 390 × 844, the user can identify the product and reach the fully visible primary action in the first viewport.
- Hero media earns its height by demonstrating the product or subject; decorative media must not push the useful interface below the first mobile viewport.

## Accessibility Baseline

Default target: WCAG 2.2 AA where practical.

Always cover:

- Semantic HTML before ARIA.
- Keyboard access for every interactive control.
- Visible focus states.
- Programmatic labels for icon-only controls and form fields.
- Sufficient contrast.
- Logical heading structure.
- Clear errors tied to their fields.
- Announced loading/status changes when they affect user progress.
- Reduced-motion support for substantial animation.

Read `references/accessibility-checklist.md` when adding or changing interactive UI, forms, dialogs, navigation, custom widgets, or accessibility-sensitive behavior.

## Visual Verification

Frontend work is not complete until the rendered UI has been checked.

Use Chrome for browser QA by default. For local apps, start or reuse the local dev server, open the relevant route, and verify the actual rendered state.

Read `references/visual-verification-checklist.md` when:

- Building a new screen.
- Changing mobile navigation.
- Changing layout or visual hierarchy.
- Fixing a visible UI bug.
- Preparing UI that will be used by customers or paid traffic.

## Implementation Loop

1. Identify the target route, component, user flow, and existing design patterns.
2. Inspect surrounding code and current rendered behavior.
3. Implement the smallest coherent change.
4. Run the repo's relevant checks: typecheck, lint, unit/component tests, build, or focused app tests.
5. Verify in Chrome at the relevant desktop and mobile widths.
6. Compare the render with the direction contract and fix generic, timid, or over-decorated execution.
7. Fix visual/accessibility regressions found during verification.
8. Summarize changed files, checks run, browser verification, and remaining risk.

## Output Shape

Return:

- What changed.
- Files touched.
- Verification run.
- Chrome desktop/mobile result.
- Accessibility or visual risks that remain.
