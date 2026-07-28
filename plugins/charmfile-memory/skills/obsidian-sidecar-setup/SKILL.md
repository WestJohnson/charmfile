---
name: obsidian-sidecar-setup
description: Install, configure, update, repair, migrate, or verify Codex Obsidian Sidecar on macOS, and scope its optional cloud replica. Use when an agent is asked to set up the sidecar from a release, connect an Obsidian vault, register Codex hooks or Basic Memory, install its launchd worker, diagnose an installation, apply a sidecar update, or plan explicitly requested cloud sync.
---

# Obsidian Sidecar Setup

Use the package's machine-readable commands as the control plane. Adapt paths
and optional integrations to the machine, but do not hand-author hooks, service
files, or config when `obsidian-sidecar setup` can do so.

## Workflow

1. Inspect the release files and read
   [references/install-contract.md](references/install-contract.md).
2. Confirm the host is macOS. Charmfile does not support this workflow on
   another operating system.
3. Install the exact wheel or package version with `uv tool install`.
   Never execute a network-fetched shell script.
4. Run `obsidian-sidecar preflight` and parse the JSON.
5. Resolve only missing decisions: vault path, Codex binary, model, and which
   optional integrations the user wants.
6. Run `obsidian-sidecar setup` without `--apply`. Treat the JSON plan as the
   proposed mutation set and show it to the user.
7. Obtain explicit approval before adding `--apply`.
8. Run `obsidian-sidecar verify-install`, then `obsidian-sidecar doctor`.
9. In a fresh Codex session, have the user review and trust the Stop hook.
10. Run `obsidian-sidecar benchmark` only after hook trust and live dependencies
    are available. Require at least 80 and every critical gate.

## Optional Cloud Sync

Cloud work is a separate phase and starts only when the user explicitly asks
for it. Read
[references/cloud-sync-contract.md](references/cloud-sync-contract.md), identify
whether the user wants sync only or overnight maintenance, and finish the local
workflow before planning cloud changes.

Perform read-only discovery on the Mac and reviewed Linux host. Show the
complete Syncthing, network, service, secret-storage, backup, verification, and
rollback plan, then wait for approval. Use the exact Sidecar release's cloud
documentation and systemd templates; do not copy a private host layout or
invent a different replication system.

Cloud completion requires healthy, complete, conflict-free replication plus
local and cloud benchmark scores of at least 80 with every critical gate.

## Safety Rules

- Never request, store, print, or move API keys during local setup.
- Never use root for the local sidecar.
- Preserve unrelated Codex hooks and Basic Memory projects.
- Keep config and service files user-only and retain generated backups.
- Do not enable cloud replication, Syncthing, SSH, or public ports as part of
  the default installation. An explicitly requested cloud phase still requires
  a separate plan and approval.
- Do not claim completion while a required verification check is failing.
- Do not bypass Codex hook trust.
- Keep automatic update mutation disabled. Update checks may be enabled, but an
  exact release requires explicit approval before installation.

## Updates

Run `obsidian-sidecar update-check`. If an update exists, report the current and
target versions, then run `obsidian-sidecar update --yes` only after approval.
The updater installs an exact package version from HTTPS and rolls back if the
new executable fails version verification.

For an offline release bundle, verify `SHA256SUMS` first and install the exact
wheel from that bundle. Re-run `verify-install`, `doctor`, and the deterministic
test procedure from the install contract after every update.

For version 0.4.0 or later, inspect `obsidian-sidecar knowledge-migrate` after
installation. The command is read-only by default. Obtain explicit approval
before adding `--apply`; apply only on the authoritative local vault, then
verify `freshness-status`, one representative `decision-impact`, Basic Memory
reindexing, and `doctor` before upgrading a cloud replica.

## Recovery

On setup failure, inspect the JSON error and generated backups. Correct the
specific prerequisite and rerun the read-only plan. Do not replace the user's
entire hooks file, vault, Basic Memory configuration, or service directory.
