# Charmfile

**A small agent setup that works like magic.**

Charmfile is a macOS-only, local-first Codex configuration and durable-memory
system. It gives the primary agent clear operating rules, verification habits,
safe secret handling, and human-visible project continuity without adding a
second agent runtime. Users may extend Memory to a reviewed VPS or server, but
no server is required.

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

## Product layers

| Package | Contents |
|---|---|
| `charmfile-core` | Managed guidance, portable Codex profile, launchers, doctor, and optional Keychain helper |
| `charmfile-memory` | Local durable-memory setup, retrieval, health, and optional cloud planning |
| Optional packs | Browser, frontend, marketing, research, infrastructure, and Three.js capabilities |

The default `standard` preset installs Core and Memory. Memory activation is a
separate plan because it selects a private vault and installs the separately
versioned Codex Obsidian Sidecar engine. Browser automation and specialist
packs are explicit choices. See the [product contract](docs/PRODUCT_CONTRACT.md)
and [pack catalog](docs/PACKS.md).

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

Clone the canonical self-hosted Git repository:

```sh
git clone https://charmfile.com/git/charmfile.git
cd charmfile
```

Give Codex this reviewed checkout and say:

```text
Use $install-charmfile to inspect this Mac and install the standard Charmfile
Core and Memory configuration. Show me the exact plan and wait for approval. Preserve my
existing config, plugins, projects, secrets, browser profile, and unrelated
AGENTS.md guidance. Do not activate a vault or cloud mode. After installation,
run the Charmfile doctor and tell me how to plan local Memory activation.
```

See [INSTALL.md](INSTALL.md). The deterministic path is:

```sh
./scripts/install-charmfile plan
./scripts/install-charmfile install --yes
./scripts/install-charmfile doctor
```

The installer registers the repository marketplace, installs Core and Memory,
adds one marked guidance block, installs the portable profile and launchers,
adds one marked `~/.local/bin` PATH block, and runs the selected-pack doctors.
Use `--with-browser`, `--with PACK`, or `--preset full` for additional packs.
Existing installations keep their selected packs during updates. Unmanaged
files at Charmfile-owned targets block replacement instead of being overwritten.

Open a new terminal and start a new Codex session after installation.

## Portable Codex profile

Charmfile never copies another user's `~/.codex/config.toml`. It installs
`~/.codex/charmfile.config.toml` and a launcher:

```sh
charmfile-codex
```

The profile carries the portable parts of the original setup: safe approval
and sandbox defaults, live search, pragmatic communication, useful TUI
notifications and status items including the current Git branch, Codex memory
controls, reviewed stable workflow features, a four-thread concurrency
ceiling, and the public OpenAI developer documentation MCP. It intentionally omits the model,
entitlements, projects, machine paths, private tools, credentials, and plugin
state.

Normal `codex` remains unchanged. `charmfile-codex` opts into the profile.

## Portable project continuity

A repository can carry a small `.charmfile/project.toml` identity that maps it
to normal Markdown in Charmfile Memory without embedding a private vault path:

```sh
charmfile init             # preview the manifest
charmfile init --yes       # create it after approval
charmfile resume           # Git state plus durable project context
charmfile status           # layers, cached health, and freshness
```

Initialization never overwrites a differing manifest. `resume` and `status`
are read-only and degrade explicitly when Memory has not been activated. They
do not run live Cloud checks or add another service. See
[Project Resume](docs/RESUME.md) for the manifest and command contract.

## Optional Playwright, without browser ambiguity

When selected, `charmfile-browser` keeps two modes separate:

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
charmfile doctor --after-update
```

The update refreshes a Git-backed marketplace, reinstalls the packs declared
by the new release, updates only managed files, and reruns strict post-update
health checks. That gate validates the reviewed Codex feature set and, when
Sidecar is installed, requires a Sidecar score of at least 80 with Basic Memory
healthy and no critical failures.
A local marketplace uses the current checkout. Open a new terminal and start a
new Codex session after every update.

## Charmfile Memory

The default Memory pack guides installation and operation of
[Codex Obsidian Sidecar](https://charmfile.com/git/codex-obsidian-sidecar.git).
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

The exact Sidecar `0.6.1` wheel, checksums, rollback wheel, and update metadata
are published through the self-hosted Charmfile release channel; see
[RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md).

Memory activation is a second, opt-in phase. Cloud operation is a third phase.
Charmfile never silently installs
Syncthing, chooses a server, opens a port, or enables a paid model. The tested
headless-worker topology uses a Syncthing filesystem replica, fenced writer
leases, derived reports, versioned backups, and separate local/cloud health
gates. See [Memory](docs/MEMORY.md), [Cloud](docs/CLOUD.md), and the advanced
[Sidecar Cloud Sync](docs/SIDECAR_CLOUD_SYNC.md) contract.

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
core, standard, browser, and full preset installation, selected-pack update
preservation, portable project init/resume/status behavior, and managed-file
backups.

## Project status

`0.2.0-rc.1` release candidate. The canonical Git repository, checksummed
archives, policy documents, and Sidecar update channel are self-hosted at
`charmfile.com`. GitHub remains a public mirror. Charmfile has not
been submitted to the universal plugin directory.

See:

- [Architecture](docs/ARCHITECTURE.md)
- [Product contract](docs/PRODUCT_CONTRACT.md)
- [Project resume](docs/RESUME.md)
- [Memory](docs/MEMORY.md)
- [Cloud](docs/CLOUD.md)
- [Pack catalog](docs/PACKS.md)
- [Publishing](docs/PUBLISHING.md)
- [Privacy](PRIVACY.md)
- [Security](SECURITY.md)
- [Third-party notices](THIRD_PARTY_NOTICES.md)
- [Release checklist](RELEASE_CHECKLIST.md)

## License

Apache License 2.0. Bundled or adapted third-party skills retain their original
notices and licenses.
