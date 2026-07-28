---
name: browser-setup
description: Plan, install, update, or health-check Charmfile's Playwright browser setup on macOS. Use when a user needs isolated browser automation, authenticated control of an existing signed-in Chrome tab, the official Playwright Extension connection, or a diagnosis of Node.js, jq, Chrome, CLI, extension, or session readiness.
---

# Charmfile Browser Setup

Use the deterministic helper to keep isolated automation and signed-in Chrome
as two explicit browser modes.

## Workflow

1. Read [references/browser-modes.md](references/browser-modes.md).
2. Run `scripts/charmfile-browser plan`.
3. Show every dependency and the manual Chrome-extension step.
4. Obtain explicit approval before installing dependencies or the CLI.
5. Run `scripts/charmfile-browser install --yes`.
6. Run `scripts/charmfile-browser doctor`.
7. If signed-in Chrome is required, install the official extension manually
   and rerun `scripts/charmfile-browser doctor --require-live-chrome`.

## Commands

```sh
scripts/charmfile-browser plan
scripts/charmfile-browser install --yes
scripts/charmfile-browser doctor
scripts/charmfile-browser doctor --require-live-chrome
```

After the doctor:

- use `$playwright-cli` for public sites, local previews, and isolated testing;
- use `$playwright-live-chrome` only for an existing signed-in Chrome tab.

## Safety

- This packaged setup supports macOS only.
- `plan` and `doctor` are read-only.
- Never add `--yes` without approval of the dependency plan.
- Never install or enable a Chrome extension silently.
- Never silently substitute an isolated profile for signed-in Chrome.
- Never attach through CDP unless remote debugging is already enabled and the
  user explicitly approves that transport.
- Do not close the user's Chrome, unrelated tabs, or external browser sessions.
- Do not read cookies, passwords, local storage, or tokens unless the user
  explicitly requests that exact data operation.
