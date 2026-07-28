# Visual Verification Checklist

Use this checklist after frontend implementation. The goal is to confirm the actual rendered UI is production-quality, not merely that code compiles.

## Setup

- Use Chrome by default.
- Start or reuse the relevant dev server.
- Open the exact route, screen, modal, state, or flow changed.
- Use realistic content, including long labels, empty states, and error states when relevant.

## Required Viewports

Check the smallest practical set for the change:

- 320px mobile.
- 390px mobile.
- 768px tablet.
- 1024px desktop.
- 1440px desktop for full layouts when relevant.

For persuasive or discovery surfaces, capture the page at `390 × 844` from the top and verify that the product purpose and fully visible primary action fit inside the first viewport.

## Layout

- No overlapping text, controls, sticky bars, modals, dropdowns, or nav.
- No clipped labels, icons, inputs, cards, tables, or buttons.
- No horizontal scroll unless the design intentionally uses it.
- Text wraps cleanly and long words do not break containers.
- Fixed-format elements have stable dimensions.
- Loading, hover, focus, validation, and empty states do not shift the layout unexpectedly.
- Hero media does not consume the first mobile viewport unless that media is the product or primary proof.
- Primary touch targets are at least 40 × 40 CSS pixels and aim for 44 × 44.

## Mobile Navigation

- Open and close controls are visible and reachable.
- Menu content fits the viewport.
- Body scroll behavior is intentional.
- Focus and tap targets work.
- Menu does not trap users unless it is a modal pattern with a deliberate escape path.
- Active page, dropdown, and nested nav states are understandable.

## Interaction States

- Buttons and links have default, hover, focus, active, disabled, and loading states when relevant.
- Forms show helper, error, disabled, and success states.
- Modals/popovers are positioned correctly and do not render off-screen.
- Tooltips do not cover the target content in a way that blocks the task.

## Visual Quality

- The UI follows the existing design system or product style.
- A new surface follows its written direction contract rather than drifting toward a category template.
- The first viewport demonstrates the product, subject, or workflow instead of presenting only atmosphere.
- Spacing is consistent and purposeful.
- Typography hierarchy matches the density of the surface.
- Color palette is not a generic AI default.
- Icons are aligned, sized consistently, and from the existing icon set.
- Repeated items are scannable without looking like decorative card filler.
- Section composition varies with meaning instead of repeating one card or split-layout formula.

## Evidence

When practical, capture or describe:

- Desktop viewport checked.
- Mobile viewport checked.
- Any screenshots, browser observations, or console issues.
- Remaining visual risks.
