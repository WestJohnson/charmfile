# Charmfile

**A small agent setup that works like magic.**

Charmfile is a lightweight, installable configuration for Codex. It gives the
primary agent clear operating rules, verification habits, browser defaults,
safe secret handling, optional durable memory, and focused specialist skills
without turning normal work into a heavyweight orchestration system.

Charmfile is an independent community project. It is not affiliated with or
endorsed by OpenAI.

## Why it feels different

The useful part is not a giant prompt. Each concern lives in the smallest layer
that can own it:

```text
one-off constraint  -> prompt
durable convention  -> AGENTS.md
reusable workflow   -> skill
deterministic action -> MCP or connector
project continuity  -> sanitized memory
independent review  -> explicit subagent
```

The result is intentionally boring to configure and surprisingly capable in
use.

## Packages

| Package | Contents | Default? |
|---|---|---|
| `charmfile-core` | Managed `AGENTS.md` guidance, setup doctor, browser and verification defaults, optional secret helper | Start here |
| `charmfile-memory` | Obsidian Sidecar setup and operation skills | Optional |
| `charmfile-frontend` | Responsive, accessible, anti-generic frontend implementation and Chrome QA | Optional |
| `charmfile-marketing` | Ads, analytics, cross-channel diagnosis, DataForSEO, and launch review | Optional |
| `charmfile-research` | Source-backed technical and product research | Optional |
| `charmfile-infrastructure` | VPS health, capacity, backup, and operations review | Optional |
| `charmfile-threejs` | Ten focused Three.js skills loaded by topic | Optional |

Wix-specific workflows, personal credentials, hostnames, account identifiers,
vault content, unrestricted sandbox settings, and no-approval defaults are not
included.

## Local release-candidate install

Requirements:

- Codex with plugin support
- Git
- Python 3 for repository validation
- macOS or Linux for the optional setup helper

From this repository:

```sh
codex plugin marketplace add .
codex plugin add charmfile-core@charmfile
```

Start a new conversation and invoke:

```text
$charmfile-setup
```

The setup workflow first produces a read-only plan. It does not change global
guidance until the user approves the exact target and the agent runs:

```sh
./scripts/charmfile install --scope user --yes
./scripts/charmfile doctor --scope user
```

The installer preserves unrelated guidance, manages only a marked block, and
backs up an existing target before a change.

Install an optional pack from the same marketplace:

```sh
codex plugin add charmfile-frontend@charmfile
codex plugin add charmfile-research@charmfile
```

## Durable memory

`charmfile-memory` guides installation and operation of
[Codex Obsidian Sidecar](https://github.com/WestJohnson/codex-obsidian-sidecar).
The Sidecar:

- queues a tiny event when work completes;
- curates sanitized, evidence-backed outcomes into normal Markdown;
- retains compact private checkpoints for long conversations;
- attaches freshness envelopes to canonical knowledge;
- previews decision blast radius without rewriting downstream artifacts;
- indexes notes through Basic Memory;
- exposes deterministic health and benchmark gates.

Raw transcripts, internal reasoning, complete tool output, and credentials do
not belong in the vault.

The memory pack is ready for local testing. Public installation remains gated
on publishing and tagging the Sidecar `0.6.0` release; see
[RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md).

## Secret handling

Charmfile includes an optional `codex-secrets` helper for macOS Keychain and
Linux libsecret:

```sh
./scripts/charmfile install --scope user --with-secrets --yes
codex-secrets set EXAMPLE_API_KEY
codex-secrets run EXAMPLE_API_KEY -- your-command
```

`run` injects selected values only into the child process. The registry stores
variable names, never values. Charmfile does not create plaintext `.env`
files.

## Validation

Run the complete local gate:

```sh
./scripts/validate-release.sh
```

It checks plugin and skill structure, marketplace consistency, personal-path
leaks, credential-shaped strings, Wix exclusion, shell syntax, and the
installer's create/update/backup behavior.

## Project status

`0.1.0` release candidate. The repository is prepared for local marketplace
testing but has not been published or submitted to the universal plugin
directory.

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
