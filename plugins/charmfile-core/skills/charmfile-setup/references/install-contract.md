# Charmfile Install Contract

## Scope

Charmfile Core supports macOS only and manages one marked guidance block:

- User scope: `$CHARMFILE_TARGET_HOME/.codex/AGENTS.md`, falling back to the
  current user's home directory when `CHARMFILE_TARGET_HOME` is unset.
- Repository scope: `<repo>/AGENTS.md`.

When `--with-path` is selected, Core also manages one bounded block in
`$CHARMFILE_TARGET_HOME/.zprofile` that adds `~/.local/bin` only when it is not
already present.

It never edits the base `config.toml`, selects a model, trusts projects,
copies plugin state, or imports private MCP servers.

## Plan

`plan` is read-only. It reports:

- the exact target;
- whether the managed block would be created, appended, updated, or left alone;
- whether the optional secret helper was requested;
- whether the portable profile and launchers were requested;
- whether the shell PATH block was requested;
- the backup naming pattern.

## Apply

`install` requires `--yes`.

- A missing target receives a small heading and the managed block.
- An existing target without Charmfile markers receives the block at the end.
- A target with one valid marker pair receives an in-place block update.
- Missing, duplicated, or inverted markers stop the operation.
- Existing files are copied to
  `<target>.backup.<UTC timestamp>` before replacement.
- Writes use a temporary sibling followed by an atomic rename.

The optional `--with-profile` path installs a fully managed
`charmfile.config.toml`, `charmfile-codex`, and lifecycle launcher. An
unmanaged file at one of those targets blocks the operation. The profile uses
safe approval and sandbox defaults and intentionally contains no fixed model,
project path, credential, private MCP endpoint, or plugin state.

The optional `--with-secrets` path installs `codex-secrets` under
`$CHARMFILE_TARGET_HOME/.local/bin`. It supports macOS Keychain and never
creates plaintext secret files. A compatible existing helper is preserved.

The optional `--with-path` operation preserves all unrelated shell setup,
backs up an existing `.zprofile`, and refuses malformed or duplicate marker
pairs.

## Verification

`doctor` checks the managed block, selected profile and launchers, Codex
profile loading, Git, ripgrep, the optional Keychain helper, and the
optional Obsidian Sidecar. Missing optional components are informational;
damaged requested components are failures.

## Rollback

Restore the most recent adjacent backup to the original target. Charmfile never
deletes backups automatically.
