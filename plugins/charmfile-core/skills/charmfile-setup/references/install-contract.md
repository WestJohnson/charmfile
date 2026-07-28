# Charmfile Install Contract

## Scope

Charmfile Core manages one marked guidance block:

- User scope: `$CHARMFILE_TARGET_HOME/.codex/AGENTS.md`, falling back to the
  current user's home directory when `CHARMFILE_TARGET_HOME` is unset.
- Repository scope: `<repo>/AGENTS.md`.

It does not edit `config.toml`, select a model, change sandbox permissions,
install MCP servers, or enable a plugin automatically.

## Plan

`plan` is read-only. It reports:

- the exact target;
- whether the managed block would be created, appended, updated, or left alone;
- whether the optional secret helper was requested;
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

The optional `--with-secrets` path installs `codex-secrets` under
`$CHARMFILE_TARGET_HOME/.local/bin`. It supports macOS Keychain and Linux
libsecret when `secret-tool` is available. It never creates plaintext secret
files.

## Verification

`doctor` checks the managed block, Codex availability, Git, ripgrep, the
optional secret backend, and the optional Obsidian Sidecar. Missing optional
components are informational; damaged guidance is a failure.

## Rollback

Restore the most recent adjacent backup to the original target. Charmfile never
deletes backups automatically.
