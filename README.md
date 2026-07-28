# Charmfile

**A small agent setup that works like magic.**

Charmfile is a macOS-only, installable configuration for Codex. It gives the
primary agent clear operating rules, verification habits, dependable
Playwright automation, safe secret handling, optional durable memory, and
focused specialist skills without adding a second agent runtime.

Charmfile is an independent community project. It is not affiliated with or
endorsed by OpenAI.

## Why it feels different

Each concern lives in the smallest layer that can own it:

```text
one-off constraint  -> prompt
durable convention  -> AGENTS.md
reusable workflow   -> skill
deterministic action -> tool
project continuity  -> sanitized memory
independent review  -> explicit subagent
```

## Full setup

| Package | Contents |
|---|---|
| `charmfile-core` | Managed guidance, portable Codex profile, launchers, doctor, and optional Keychain helper |
| `charmfile-browser` | Reproducible Playwright CLI plus explicit signed-in Chrome attachment |
| `charmfile-memory` | Obsidian Sidecar setup and operation |
| `charmfile-frontend` | Responsive, accessible, anti-generic frontend implementation and Chrome QA |
| `charmfile-marketing` | Ads, analytics, cross-channel diagnosis, DataForSEO, and launch review |
| `charmfile-research` | Source-backed technical and product research |
| `charmfile-infrastructure` | VPS health, capacity, backup, and operations review |
| `charmfile-threejs` | Ten focused Three.js skills loaded by topic |

Personal credentials, hostnames, account identifiers, vault content, fixed
models, trusted-project lists, private MCP endpoints, unrestricted sandbox
settings, and disabled approvals are not included.

## Agentic install

Requirements:

- macOS;
- Codex CLI with plugin support;
- Git;
- Homebrew if Node.js 18+, jq, or Google Chrome is missing;
- the official Playwright Extension for signed-in Chrome work.

Give Codex this reviewed checkout and say:

```text
Use $install-charmfile to inspect this Mac and install the full Charmfile
Codex harness. Show me the exact plan and wait for approval. Preserve my
existing config, plugins, projects, secrets, browser profile, and unrelated
AGENTS.md guidance. After installation, run the full doctor and report
isolated Playwright and signed-in Chrome readiness separately.
```

See [INSTALL.md](INSTALL.md). The deterministic path is:

```sh
./scripts/install-charmfile plan
./scripts/install-charmfile install --yes
./scripts/install-charmfile doctor
```

The installer registers the repository marketplace, installs all eight packs,
adds one marked guidance block, installs the portable profile and launchers,
adds one marked `~/.local/bin` PATH block, prepares Playwright, and runs the
doctors. Existing compatible Playwright and secret helpers are preserved.
Unmanaged files at Charmfile-owned targets block replacement instead of being
overwritten.

Open a new terminal and start a new Codex session after installation.

## Portable Codex profile

Charmfile never copies another user's `~/.codex/config.toml`. It installs
`~/.codex/charmfile.config.toml` and a launcher:

```sh
charmfile-codex
```

The profile carries the portable parts of the original setup: safe approval
and sandbox defaults, live search, useful TUI notifications and status items,
Codex memory controls, a four-thread concurrency ceiling, and the public
OpenAI developer documentation MCP. It intentionally omits the model,
entitlements, projects, machine paths, private tools, credentials, and plugin
state.

Normal `codex` remains unchanged. `charmfile-codex` opts into the profile.

## Playwright, without browser ambiguity

`charmfile-browser` keeps two modes separate:

- isolated Playwright for public sites, local previews, screenshots,
  responsive QA, and disposable browser tests;
- signed-in live Chrome only when the task needs an existing authenticated
  tab.

The CLI and Chromium runtime are installed in a Charmfile-owned directory.
Signed-in mode uses Microsoft's official Playwright Extension and always
requires the user's Chrome approval. Charmfile does not silently launch a new
profile, enable remote debugging, or substitute another browser transport.

```sh
charmfile doctor --require-live-chrome
```

## Updates

After the public Git marketplace is installed:

```sh
charmfile plan
charmfile update --yes
charmfile doctor
```

The update refreshes a Git-backed marketplace, reinstalls the packs declared
by the new release, updates only managed files, and reruns the health checks.
A local marketplace uses the current checkout. Open a new terminal and start a
new Codex session after every update.

## Durable memory

`charmfile-memory` guides installation and operation of
[Codex Obsidian Sidecar](https://github.com/WestJohnson/codex-obsidian-sidecar).
The Sidecar:

- curates sanitized, evidence-backed outcomes into normal Markdown;
- retains compact private checkpoints for long conversations;
- attaches freshness envelopes to canonical knowledge;
- previews decision blast radius;
- indexes notes through Basic Memory;
- exposes deterministic health and benchmark gates.

Raw transcripts, internal reasoning, complete tool output, and credentials do
not belong in the vault. Vault selection and Sidecar activation remain a
separate plan-and-approval phase.

Public memory installation remains gated on publishing the Sidecar `0.6.0`
release; see [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md).

Cloud operation is a second, opt-in phase. Charmfile never silently installs
Syncthing, chooses a server, opens a port, or enables a paid model. The tested
headless-worker topology uses a Syncthing filesystem replica, fenced writer
leases, derived reports, versioned backups, and separate local/cloud health
gates. See [Sidecar Cloud Sync](docs/SIDECAR_CLOUD_SYNC.md) for the user and
LLM installation prompts.

## Secret handling

The optional `codex-secrets` helper uses macOS Keychain:

```sh
codex-secrets set EXAMPLE_API_KEY
codex-secrets run EXAMPLE_API_KEY -- your-command
```

`run` injects selected values only into the child process. The local registry
stores variable names, never values. Charmfile does not create plaintext
`.env` files.

## Validation

Contributors need Python 3.11 or newer in addition to the runtime requirements:

```sh
./scripts/validate-release.sh
```

The gate checks plugin and skill structure, marketplace consistency, personal
path and credential leaks, excluded integration content, shell syntax,
macOS-only boundaries, safe profile behavior, Playwright readiness states,
eight-pack installation, update behavior, and managed-file backups.

## Project status

`0.1.0-rc.3` release candidate. The repository is prepared for local
marketplace testing but has not been published or submitted to the universal
plugin directory.

See:

- [Architecture](docs/ARCHITECTURE.md)
- [Publishing](docs/PUBLISHING.md)
- [Privacy](PRIVACY.md)
- [Security](SECURITY.md)
- [Third-party notices](THIRD_PARTY_NOTICES.md)
- [Release checklist](RELEASE_CHECKLIST.md)

## License

Apache License 2.0. Bundled or adapted third-party skills retain their original
notices and licenses.
