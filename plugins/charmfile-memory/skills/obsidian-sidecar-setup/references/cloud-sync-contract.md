# Optional Cloud Sync Contract

Cloud replication is a separate, explicitly approved phase. It is never a
prerequisite for local memory and must not be enabled during the default
Sidecar installation.

## Supported Modes

1. `local-only`: macOS Sidecar, Stop hook, launchd, and optional Basic Memory.
2. `sync-only`: local memory plus a user-administered vault sync provider.
3. `cloud-maintenance`: a Syncthing filesystem replica and a fenced Linux
   worker that writes derived reports and processed task records.

Charmfile does not administer Obsidian Sync or iCloud. The tested headless
worker uses Syncthing because the cloud runtime requires ordinary Markdown
files. Do not claim another sync provider is compatible with cloud maintenance
without release-specific evidence.

## Preconditions

- The user explicitly requests cloud sync or cloud maintenance.
- Local `verify-install` and `doctor` pass.
- The Stop hook is trusted in a fresh Codex session.
- The local benchmark scores at least 80 and passes every critical gate.
- An exact, checksum-verified Sidecar release is available.
- The Linux host, SSH access, storage, network boundary, and rollback location
  are known.

Stop when a prerequisite fails. Do not substitute an unreviewed branch, system
Python, a remote shell installer, a different host, or a broader network
exposure.

## Required Discovery

Resolve these values without requesting secret contents:

- requested mode;
- absolute local vault path;
- SSH host alias;
- server vault, state, configuration, and backup paths;
- Syncthing folder ID and both peer device IDs;
- direct sync address and the one approved transport port;
- model enablement, provider, exact model, and spending ceilings;
- backup retention and maintenance schedule;
- current services, firewall rules, listening sockets, free storage, and
  existing replicas.

For cloud maintenance, inspect the exact release's `docs/CLOUD_SYNC.md`,
`config.example.json`, and `deploy/systemd-cloud/` templates before planning.

## Plan Contract

Return a plan with:

1. Outcome and selected mode.
2. Current Mac, server, sync, and Sidecar evidence.
3. Exact package and checksum evidence.
4. Local mutations.
5. Server packages, users, directories, ownership, and files.
6. Syncthing device authorization, ignore rules, versioning, and connectivity.
7. Network changes, including bind addresses and the exact transport port.
8. Secret names and storage locations, never values.
9. Services, timers, schedule, retry behavior, and cost limits.
10. Verification commands and required results.
11. Rollback and conflict-recovery procedure.
12. Manual approval points and administrator actions.

Discovery and planning are read-only. Wait for explicit approval before any
package installation, device authorization, firewall change, privileged write,
service start, or cloud-model enablement.

## Deployment Boundaries

- Keep Syncthing GUI and REST APIs on loopback.
- Mutually authorize peer device certificates.
- Expose only the explicitly approved sync transport.
- Run the cloud worker as an unprivileged account.
- Keep configuration and credentials outside the synced vault.
- When a cloud model is enabled, use a root-owned mode-`0600` environment file
  loaded by systemd. Do not echo or persist the value elsewhere.
- Keep independent Git history and versioned backups on both replicas.
- Exclude Git internals, workspace state, trash, versions, quarantine, and
  transient cache files from replication.
- Use synchronized leases to prevent concurrent local and cloud maintenance.
- Default cloud output to derived reports. Do not rewrite source notes.
- When the peer is offline, stage output outside the vault and publish only
  after fingerprints match the reconnected authoritative replica.
- Fail closed on pending bytes, folder errors, conflicts, active writers,
  malformed leases, apparent secrets, critical health failures, or exhausted
  cost limits.

## Verification Contract

Report these independently:

- local Sidecar configured, installed, and running;
- Stop hook trusted;
- Basic Memory registered, indexed, and retrievable when selected;
- Syncthing connected, complete, conflict-free, and at zero pending bytes;
- cloud service installed and timer active;
- last maintenance and reconnect results;
- recent manifested backup and restore proof;
- local doctor and benchmark result;
- cloud doctor and benchmark result;
- exact rollback artifact and configuration backup.

Local and cloud benchmarks require at least 80 and every critical gate.
`cloud-doctor` being offline-safe does not mean the system is synchronized or
permitted to mutate the shared vault.

## Recovery

- Never force an override around a lease, conflict, or incomplete replica.
- Inspect both conflict copies before choosing or merging content.
- Stop Syncthing and maintenance timers before restoring.
- Extract backups into a temporary review directory first.
- Roll back with the exact previous release artifact and saved configuration.
- Re-run doctors and benchmarks after every repair, update, or rollback.
