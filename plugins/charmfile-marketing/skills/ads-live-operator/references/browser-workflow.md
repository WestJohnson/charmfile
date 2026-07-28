# Browser Workflow

Use the smallest access path that gives reliable evidence.

## Access Order

1. Use a platform API, export, or connector when it is already available and authenticated.
2. Use `@Chrome` in the ChatGPT desktop app or `playwright-live-chrome` in Codex CLI for signed-in ad platforms such as Google Ads, Meta Ads, Microsoft Ads, Merchant Center, and for web QA because the user's auth and working context live in Chrome.
3. Use `@Browser` only when the user explicitly asks for the in-app browser or approves fallback after Chrome is unavailable.
4. Use user-provided screenshots or CSV exports when live access is blocked, but mark the evidence limits.

## Chrome Read Rules

- Confirm the visible account, business, date range, comparison range, and columns before reading metrics.
- Avoid changing filters, settings, budgets, keywords, goals, or assets unless the user approved that exact action.
- If tables are paginated or sampled, export the report or explicitly state the visible row limit.
- Capture before-state for every setting that might be changed later.
- Prefer exported CSVs for search terms, change history, asset-level reports, product/category reports, and long campaign tables.
- If the selected Chrome transport cannot be reached, stop and report the connection issue instead of silently switching to another browser surface or an isolated profile.

## Mutation Rules

- Stop before clicking Save, Apply, Enable, Pause, Remove, Publish, or Submit unless the user approved the exact action.
- After saving an approved change, refresh or revisit the setting to verify the after-state.
- Record the exact path to revert the change.
