# Accessibility Checklist

Use this checklist for frontend implementation that changes interactive UI, navigation, forms, dialogs, custom widgets, tables, or user flows.

Default target: WCAG 2.2 AA where practical.

## Essential Checks

- Page has one sensible `h1` and headings do not skip levels for visual styling.
- Landmarks are clear: header/banner, nav, main, footer/contentinfo where applicable.
- Interactive elements use native controls first: `button`, `a`, `input`, `select`, `textarea`, `dialog`.
- Every interactive element is reachable and operable by keyboard.
- Focus order follows the visual/user flow.
- Focus indicator is always visible and not clipped.
- Icon-only controls have accessible names.
- Form inputs have visible or programmatic labels.
- Required fields, helper text, and errors are announced and associated with the relevant fields.
- Color contrast is at least 4.5:1 for normal text and 3:1 for large text and essential UI graphics.
- Color is not the only way state is communicated.
- Images have appropriate alt text or are marked decorative.
- Dynamic status changes use appropriate live region/status behavior when users need to know about them.
- Motion respects `prefers-reduced-motion` when animation is substantial.

## Keyboard Patterns

- `Tab` reaches every interactive control.
- `Shift+Tab` reverses through controls predictably.
- `Enter` activates buttons and links.
- `Space` activates buttons, checkboxes, and similar controls.
- `Escape` closes dialogs, menus, popovers, and transient overlays.
- Dialogs trap focus while open and return focus to the trigger when closed.
- Menus, tabs, comboboxes, and accordions follow expected ARIA Authoring Practices when custom-built.

## Forms

- Labels use `for`/`id` or an equivalent framework-supported association.
- Errors appear near the field and are linked with `aria-describedby` or equivalent.
- Validation does not rely only on red borders.
- Submit buttons expose loading/disabled states without trapping users.
- Successful submission is confirmed visibly and programmatically when appropriate.

## Common Anti-Patterns

- Clickable `div` or `span` without keyboard handling.
- `aria-label` used to patch unclear visible copy instead of improving the visible label.
- `aria-hidden="true"` on focusable content.
- Custom select/menu/dialog components without keyboard parity.
- Placeholder text used as the only label.
- Focus removed with CSS and no replacement.
- Toast-only errors for form fields.
- Infinite spinners with no accessible label or timeout path.

## Verification

Run the strongest practical subset:

- Keyboard walkthrough of the changed flow.
- Chrome accessibility tree or DevTools inspection for labels and landmarks.
- Automated scan if the repo has axe, Lighthouse, Playwright accessibility checks, or similar.
- Manual mobile check for focus, touch target, and visible label issues.
