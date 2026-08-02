# Product Contract

Charmfile is a lightweight, local-first Codex configuration and durable-memory
system. It gives one primary Codex agent a portable operating profile, safe
workflow guidance, and an optional human-visible memory engine. A user-owned
VPS or server may extend that memory system, but no server is required.

## Product Layers

1. **Charmfile Core** owns the portable Codex profile, launchers, managed
   guidance, Keychain helper, lifecycle command, and health checks.
2. **Charmfile Memory** owns the guided installation and operation of the
   separately versioned Codex Obsidian Sidecar engine.
3. **Charmfile Cloud** is an opt-in Memory mode for vault replication,
   recovery, and optionally scheduled maintenance on a reviewed Linux host.
4. **Capability packs** add focused browser, frontend, marketing, research,
   infrastructure, or Three.js workflows without changing the core product.

## Portable Project Continuity

A repository may carry `.charmfile/project.toml`, a small portable identity
that maps the project to its canonical Charmfile Memory note. The manifest may
contain a project ID and name, a public repository identity, and a vault-relative
memory reference. It must not contain credentials, local absolute paths, vault
contents, hosts, or machine state.

`charmfile init` is plan-first and creates the manifest only after explicit
`--yes` approval. It never overwrites a differing manifest. `charmfile resume`
and `charmfile status` are read-only: they may combine the manifest with local
Git state, the configured local Memory note, installed pack metadata, and the
cached Sidecar health result, but they do not repair, sync, index, or mutate
those sources.

The Sidecar remains a separate repository and release because it is a Python
runtime with its own safety and rollback contract. It is presented to users as
the engine behind Charmfile Memory rather than as a competing product.

## Installation Contract

The default `standard` preset installs `charmfile-core` and
`charmfile-memory`. It makes the Memory setup workflow available but does not
choose a vault, install the Sidecar runtime, or enable a hook.

- `core` installs only Charmfile Core.
- `standard` installs Core and Memory and is the default.
- `full` preserves the original eight-pack installation.
- `--with-browser` or `--with PACK` adds explicitly selected capabilities.

Updates preserve the installed Charmfile pack set. They do not expand a
minimal installation to the full marketplace or remove packs from an existing
full installation.

## Local-First Memory

Memory activation is a separate plan-and-approval phase because it selects a
private vault and installs a background service. Local Memory must work without
a VPS, a paid model, or a proprietary sync service. The vault remains normal
Markdown, the repository remains authoritative for code, and raw transcripts,
internal reasoning, complete tool output, and credentials are excluded.

## Optional Cloud Compatibility

Cloud support has three outcomes: local-only Memory, user-selected vault sync,
or a reviewed headless maintenance worker. Charmfile must keep those outcomes
distinct and must never silently choose a host, install Syncthing, open a port,
enable a model, or place credentials in the vault.

The supported maintenance design uses a complete Markdown replica, fenced
writers, conflict detection, versioned backups, and independent local and cloud
health gates. A disconnected server may stage analysis but may not mutate the
shared vault.

## Non-Goals

Charmfile is not a second agent runtime, a general deployment platform, a
business-data store, or a bundle of account-specific automation. It does not
install fixed models, unrestricted sandboxing, disabled approvals, personal
hosts, private MCP endpoints, or user credentials.

## Release Standard

A release is complete only after the selected-pack lifecycle, existing-install
preservation, clean archive, self-hosted Git and artifact channel, GitHub
mirror, public policy URLs, HTTPS install/update path, and rollback inputs are
verified. Memory and cloud readiness are reported independently from Core.
