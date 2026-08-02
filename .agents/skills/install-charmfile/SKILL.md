---
name: install-charmfile
description: Install, update, plan, select packs for, or health-check Charmfile on macOS. Use when a user asks an agent to adopt Charmfile from this repository, refresh an existing installation without expanding its pack set, inspect dependencies, preserve an existing Codex configuration, or choose between Core, standard Core plus Memory, Browser, and full presets.
---

# Install Charmfile

Use the repository lifecycle command as the control plane. The default
`standard` install includes Core and the Memory setup pack, managed global
guidance, a conservative Codex profile, and macOS Keychain secret injection.
Browser automation and specialist packs are selected explicitly; the `full`
preset retains the original eight-pack installation.

## Workflow

1. Confirm the host is macOS and read
   [references/install-contract.md](references/install-contract.md).
2. Run `./scripts/install-charmfile plan`.
3. Show the user the exact targets, selected preset and packs, existing-state
   findings, dependencies, backup behavior, and any requested browser mode.
4. Wait for explicit approval.
5. Run `./scripts/install-charmfile install --yes`.
6. Run `./scripts/install-charmfile doctor`.
7. When Browser was selected, report isolated Playwright readiness and
   signed-in Chrome readiness separately.
8. Open a new terminal and start a new Codex session so the managed PATH and
   newly installed or updated plugins are loaded.
9. Explain that the installed Memory pack makes `$obsidian-sidecar-setup`
   available but does not activate a vault. Start that separate local plan only
   when requested. Cloud sync or overnight maintenance is a third, explicitly
   requested phase governed by that skill's cloud-sync contract.

Selection examples:

```sh
./scripts/install-charmfile plan                    # Core + Memory
./scripts/install-charmfile plan --preset core      # Core only
./scripts/install-charmfile plan --with-browser     # Core + Memory + Browser
./scripts/install-charmfile plan --with research    # Core + Memory + Research
./scripts/install-charmfile plan --preset full      # all eight packs
```

For an existing installation:

```sh
charmfile plan
charmfile update --yes
charmfile doctor
```

For repository continuity after the lifecycle is healthy:

```sh
charmfile init                 # inspect the portable manifest plan
charmfile init --yes           # create it after approval
charmfile resume               # Git state plus durable project context
charmfile status               # layers, cached health, and freshness
```

`init` never overwrites a differing `.charmfile/project.toml`. `resume` and
`status` are read-only and do not activate Memory, run live Cloud checks, or
repair local state.

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
- Updates preserve the currently installed Charmfile packs. Do not add a
  preset override to `update` or present an update as permission to expand the
  installation.
- Do not automatically configure an Obsidian vault. Use
  `$obsidian-sidecar-setup` as a second plan-and-approval phase when requested.
- Do not install Syncthing, choose a cloud host, open a port, or enable a model
  during the Charmfile install. Cloud operation requires a separate discovery
  plan and approval after local Sidecar verification passes.
