# Charmfile macOS installation contract

## Managed surfaces

The installer may manage only these surfaces after an approved plan:

- the `charmfile` Codex plugin marketplace;
- the Charmfile plugin installations selected by the approved preset or pack
  flags;
- one marked block in `~/.codex/AGENTS.md`;
- one marked PATH block in `~/.zprofile`;
- `~/.codex/charmfile.config.toml`;
- `~/.local/bin/charmfile`;
- `~/.local/bin/charmfile-codex`;
- `~/.local/bin/codex-secrets`;
- `~/.local/share/charmfile/playwright-cli` only when Browser is selected;
- `~/.local/bin/playwright-cli` only when Browser is selected and the target is
  absent or already Charmfile-managed.

Existing managed files receive adjacent timestamped backups before a changed
replacement. An unmanaged file at a Charmfile-owned target blocks that part of
the install instead of being overwritten.

## System dependencies

- macOS;
- Codex CLI with plugin support;
- Git;
- Homebrew when jq or a selected pack dependency must be installed;
- jq;
- Google Chrome, Node.js 18 or newer, npm, and `@playwright/cli` only when the
  Browser pack is selected.

The official Playwright Extension is a manual Chrome install. Its absence does
not prevent isolated browser automation, but signed-in live Chrome remains
incomplete until the user installs the extension and approves tab attachment.

## Portable configuration

Charmfile does not copy another person's `config.toml`. It installs a named
profile and a `charmfile-codex` launcher. The profile contains conservative,
documented settings for:

- on-request approval and workspace-write sandboxing;
- live web search;
- useful TUI notifications and status information;
- opt-in-by-launcher Codex memory generation;
- a four-thread concurrency ceiling;
- the public OpenAI developer documentation MCP.

It intentionally omits models, entitlements, project trust, personal paths,
plugin state, marketplace state, hooks, credentials, private MCP servers, and
desktop-app-only settings.

## Update

`charmfile update --yes` records the currently installed Charmfile pack set,
refreshes a Git-backed marketplace, reinstalls only that pack set, replaces
only managed files, and runs the applicable doctors. A local marketplace is
treated as already refreshed; update uses its current checkout. Updates reject
preset overrides.

Plugin changes are loaded only in a new Codex session.

## Rollback

Restore the most recent adjacent backup for a changed managed file. Plugin
rollback uses a previously reviewed Git ref or release archive and then reruns
the same install command. Charmfile never deletes user backups automatically.
