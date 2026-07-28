# Privacy

Charmfile Core and the bundled specialist skills do not operate a hosted
service and do not collect telemetry.

## Core configuration

The setup helper reads only:

- its bundled templates;
- the exact target `AGENTS.md` selected by the user;
- the Charmfile marketplace and installed-plugin status;
- local dependency and Chrome-extension presence needed for `doctor`.

It writes only after explicit approval and only to the reported managed
targets. The portable profile is separate from the user's base `config.toml`.
It contains no fixed model, personal path, project trust, private MCP endpoint,
credential, or account identifier.

The installer adds `~/.local/bin` through one bounded block in `.zprofile` and
preserves all unrelated shell configuration.

When the approved plan reports missing browser dependencies, the installer may
ask Homebrew to install Node.js, jq, or Google Chrome and npm to install the
pinned Playwright CLI. Those actions are listed before approval.

## Secret helper

`codex-secrets` stores values in macOS Keychain. Its local registry contains
variable names only. Charmfile does not receive, transmit, or retain those
values.

## Browser setup

The browser doctor checks command versions, the Google Chrome application, and
whether the official Playwright Extension directory exists in a local Chrome
profile. It does not read browser history, cookies, passwords, page content,
or storage.

The optional extension handshake token is stored in macOS Keychain. The user
approves the extension installation, connection, and selected tab. Playwright
artifacts remain local unless the user chooses to share them.

## Optional memory

Codex Obsidian Sidecar is a separate, local-first component with its own
configuration and documentation. It is designed to exclude raw transcripts,
internal reasoning, complete tool output, credentials, and private account
identifiers from durable notes.

Optional cloud sync creates another plaintext Markdown replica administered by
the user. Charmfile does not enable it automatically. Sync-only mode needs no
model credential. If the user enables overnight model analysis, the cloud
worker sends bounded note excerpts to the selected provider and keeps its
credential outside the vault, Git, generated reports, and Sidecar
configuration. See [Sidecar Cloud Sync](docs/SIDECAR_CLOUD_SYNC.md).

## External tools

Specialist skills may instruct an agent to use services selected and
authorized by the user. Data handling then depends on that service and the
user's configuration. Charmfile itself does not proxy those requests.

Questions or privacy reports should be opened through the repository's public
issue tracker after publication.
