---
name: playwright-live-chrome
description: Use when Codex CLI or a terminal session must inspect, test, or operate the user's existing signed-in Google Chrome tabs through Microsoft Playwright CLI. Trigger for authenticated web apps, analytics, advertising platforms, live website administration, screenshots, browser QA, and approved live mutations that require the user's real Chrome profile. Do not use for ChatGPT desktop @Chrome work, connector-first data tasks, or isolated browser testing.
---

# Playwright Live Chrome

Use Microsoft Playwright CLI as the authenticated Chrome transport. Use the
upstream `playwright-cli` skill for the full command reference.

## Transport Rules

- Reuse the named session `chrome-live`.
- Attach through the official Playwright Extension by default.
- Never use `playwright-cli open` for work that requires existing logins.
- Never silently substitute Chrome for Testing, an isolated profile, the
  in-app browser, AppleScript, or another browser.
- Use Chrome DevTools MCP only when console, network, performance, memory, or
  protocol-level evidence is materially needed.
- Do not inspect or export cookies, local storage, passwords, or tokens unless
  the user explicitly requests that exact data operation.
- One Codex thread controls a live tab at a time. Subagents may review saved
  evidence but must not share the browser session concurrently.

## Connect

Run the helper from this skill directory:

```zsh
scripts/chrome-session.zsh status
scripts/chrome-session.zsh attach
```

The first extension connection may ask the user to approve the connection and
select a tab. If a Keychain token is configured, the approval handshake can be
automatic while tab control remains explicit.

If extension attachment is unavailable and Chrome remote debugging is already
enabled and approved, use:

```zsh
scripts/chrome-session.zsh attach-cdp
```

Do not enable remote debugging or change Chrome security settings silently.

## Operate

Always include the session:

```zsh
playwright-cli -s=chrome-live snapshot
playwright-cli -s=chrome-live find "Campaigns"
playwright-cli -s=chrome-live screenshot --filename=before.png
playwright-cli -s=chrome-live click e12
playwright-cli -s=chrome-live screenshot --filename=after.png
```

Use snapshot references for interaction. Refresh the snapshot after navigation
or meaningful state changes instead of reusing stale references.

For read-only work, report the selected tab, observed state, and evidence used.
For live mutations, capture the before-state, exact intended change, after-state,
rollback path, and next check-in. Stop if account, property, site, date range, or
target object is ambiguous.

Use screenshots for visual claims. A successful click or DOM response does not
prove that the rendered result is correct.

## Disconnect

Leave the external Chrome browser running. Detach only when the user asks or the
session is stale:

```zsh
scripts/chrome-session.zsh detach
```

Never run `close-all`, `kill-all`, or close unrelated tabs during live-account
work.
