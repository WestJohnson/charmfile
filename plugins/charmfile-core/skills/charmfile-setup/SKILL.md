---
name: charmfile-setup
description: Install, update, plan, or health-check the Charmfile Core configuration on macOS. Use when someone asks to add its global or repository AGENTS.md guidance, install the portable Charmfile Codex profile and launchers, add the optional macOS Keychain secret helper, inspect what Core would change, or verify that the configuration remains intact.
---

# Charmfile Setup

Use the deterministic helper instead of hand-editing a user's existing guidance.
Charmfile must preserve unrelated instructions and must never install over an
existing file without a backup.

## Workflow

1. Read [references/install-contract.md](references/install-contract.md).
2. Run `scripts/charmfile plan --scope user` for global guidance or
   `scripts/charmfile plan --scope repo --repo PATH` for one repository.
3. Show the target, merge behavior, optional profile and secret-helper changes,
   and rollback path to the user.
4. Obtain explicit approval before running `install`.
5. Run the matching install command with `--yes`. Add `--with-path` for the
   managed `~/.local/bin` shell path. Add `--with-profile` for the portable
   profile and launchers. Add `--with-secrets` only when the user wants the
   macOS Keychain helper.
6. Run the matching `doctor` command and report every failed check.
7. Start a new Codex conversation when newly installed skills or plugins are
   not visible in the current session.

## Commands

```sh
# Read-only global plan and health check
scripts/charmfile plan --scope user
scripts/charmfile doctor --scope user

# Apply global guidance after approval
scripts/charmfile install --scope user --yes

# Also install the optional codex-secrets command
scripts/charmfile install --scope user --with-secrets --yes

# Install the portable profile, launchers, and secret helper
scripts/charmfile install \
  --scope user \
  --with-path \
  --with-profile \
  --with-secrets \
  --yes

# Repository-scoped guidance
scripts/charmfile plan --scope repo --repo /path/to/repository
scripts/charmfile install --scope repo --repo /path/to/repository --yes
scripts/charmfile doctor --scope repo --repo /path/to/repository
```

## Safety

- Treat `plan` and `doctor` as read-only.
- Stop on operating systems other than macOS.
- Never add `--yes` without explicit approval.
- Preserve all content outside the managed Charmfile marker block.
- Preserve all shell setup outside the managed PATH marker block.
- Refuse malformed or duplicate marker blocks instead of guessing.
- Back up an existing target before any successful change.
- Never edit the user's base `config.toml`. The optional profile is a separate,
  conservative layer selected with `charmfile-codex`.
- Do not install a model choice, unrestricted sandbox, or no-approval policy.
- Do not request or print secret values. Prefer
  `codex-secrets run NAME... -- COMMAND`.
- Do not claim that the Sidecar runtime, a vault, cloud mode, or specialist
  packs are active merely because Charmfile Core or the Memory setup pack is
  healthy.
