# Browser mode contract

## Isolated Playwright

Use isolated Playwright for public pages, local previews, disposable sessions,
responsive QA, screenshots, and browser tests that do not require the user's
existing logins.

Charmfile installs:

- `@playwright/cli` at the version pinned by the release;
- a Chromium runtime through Playwright;
- a small managed `playwright-cli` wrapper under `~/.local/bin`;
- the runtime under `~/.local/share/charmfile/playwright-cli`.

This avoids mutating a user's global npm packages.

## Signed-in live Chrome

Use live Chrome only when a task requires an existing authenticated session.
The transport is Microsoft Playwright CLI attached through the official
Playwright Extension:

<https://chromewebstore.google.com/detail/playwright-extension/mmlmfjhmonkocbjadbfplnigmagldckm>

The user installs the extension and approves the connection or selected tab.
Charmfile discovers the extension under the user's Chrome profiles; it does not
ship a profile path or an extension build.

The optional handshake token may be stored in macOS Keychain through
`scripts/chrome-session.zsh set-token`. The token is never printed or written
to a repository file.

## Readiness

The browser doctor reports:

- isolated readiness: Node.js, npm, jq, Chrome, the pinned CLI, wrapper, and
  installed Playwright Chromium;
- signed-in readiness: all isolated requirements plus the official extension.

An extension approval dialog or tab picker can still appear on the first live
attachment. Readiness does not grant permission to mutate a live account.
