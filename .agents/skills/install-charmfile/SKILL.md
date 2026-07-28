---
name: install-charmfile
description: Install, update, plan, or health-check the complete Charmfile Codex harness on macOS. Use when a user asks an agent to adopt Charmfile from this repository, refresh an existing Charmfile installation, inspect its dependencies, preserve an existing Codex configuration while adding the portable profile, or verify the Core, Browser, Memory, and specialist packs.
---

# Install Charmfile

Use the repository lifecycle command as the control plane. The full install
includes eight plugin packs, managed global guidance, a conservative Codex
profile, macOS Keychain secret injection, and the Playwright browser setup.

## Workflow

1. Confirm the host is macOS and read
   [references/install-contract.md](references/install-contract.md).
2. Run `./scripts/install-charmfile plan`.
3. Show the user the exact targets, existing-state findings, dependencies,
   browser modes, backup behavior, and any manual Chrome-extension step.
4. Wait for explicit approval.
5. Run `./scripts/install-charmfile install --yes`.
6. Run `./scripts/install-charmfile doctor`.
7. Report isolated Playwright readiness and signed-in Chrome readiness
   separately.
8. Open a new terminal and start a new Codex session so the managed PATH and
   newly installed or updated plugins are loaded.
9. If the user requests durable memory, start
   `$obsidian-sidecar-setup` as a separate local plan. Cloud sync or overnight
   maintenance is a third, explicitly requested phase governed by that skill's
   cloud-sync contract.

For an existing installation:

```sh
charmfile plan
charmfile update --yes
charmfile doctor
```

## Boundaries

- This release supports macOS only. Stop on any other operating system.
- `plan` and `doctor` are read-only.
- Never add `--yes` without the user's approval of the displayed plan.
- Preserve unrelated `AGENTS.md`, `config.toml`, plugins, marketplaces,
  projects, MCP servers, credentials, and browser profiles.
- Install the portable settings in `~/.codex/charmfile.config.toml`; never
  merge private settings into `~/.codex/config.toml`.
- Do not copy a fixed model, unrestricted sandbox, disabled approvals,
  project trust, private MCP endpoints, machine paths, or installed-plugin
  state from another user.
- Never install a Chrome extension silently. Give the official extension link
  and let the user approve it in Chrome.
- Do not claim signed-in Chrome readiness merely because isolated Playwright
  works.
- Do not automatically configure an Obsidian vault. Use
  `$obsidian-sidecar-setup` as a second plan-and-approval phase when requested.
- Do not install Syncthing, choose a cloud host, open a port, or enable a model
  during the Charmfile install. Cloud operation requires a separate discovery
  plan and approval after local Sidecar verification passes.
