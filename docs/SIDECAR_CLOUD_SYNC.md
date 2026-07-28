# Sidecar Cloud Sync

Charmfile treats durable memory and cloud operation as separate, opt-in
phases. A normal Charmfile installation adds the memory skills, but it does
not choose a vault, install the Sidecar runtime, configure Syncthing, connect
to a server, open a port, or enable a paid model.

This separation is intentional. A user should be able to use Charmfile without
memory, use Sidecar entirely on one Mac, or add a reviewed cloud replica later.

## Choose The Outcome First

| Outcome | What is installed | Linux host required | Model API required |
| --- | --- | --- | --- |
| Local memory | Sidecar, Codex Stop hook, launchd worker, optional Basic Memory | No | No |
| Vault sync only | Local memory plus a user-selected sync system | Depends on provider | No |
| Overnight maintenance | Local memory, Syncthing replica, Linux Sidecar worker, backups, timers, and health gates | Yes | Only when model analysis is enabled |

Obsidian Sync or iCloud may be suitable for a person's own Obsidian devices,
but Charmfile does not administer those services. The tested headless-worker
topology uses Syncthing because the Linux worker needs a normal Markdown
directory for validation, backups, Git checkpoints, and bounded analysis.

Charmfile does not currently ship a one-command Linux provisioner. The memory
skill supplies an installation contract so an LLM can inspect the exact
Sidecar release, prepare a complete plan, and perform the reviewed deployment
without inventing a private host layout.

## Release Gate

The Charmfile `0.1.0-rc.3` source includes the memory skills, but public runtime
installation remains gated on a published, checksum-verified Sidecar `0.6.0`
release. An installer must:

1. Resolve an exact Sidecar version and reviewed release artifact.
2. Verify its checksum before installation.
3. Stop and report the release blocker when the exact artifact is unavailable.
4. Never replace the release with an unreviewed branch, network-fetched shell
   script, or system Python installation.

## Recommended Installation Flow

### Phase 1: Local Memory

The LLM uses `$obsidian-sidecar-setup` and follows the local contract:

1. Confirm macOS, an existing vault, `uv`, and an authenticated Codex CLI.
2. Install the exact Sidecar release.
3. Run `obsidian-sidecar preflight`.
4. Show the read-only `obsidian-sidecar setup` plan.
5. Wait for approval before rerunning the plan with `--apply`.
6. Run `verify-install` and `doctor`.
7. Have the user trust the Stop hook in a fresh Codex session.
8. Run `benchmark`; require at least 80 and every critical gate.

Cloud work must not begin while local installation or hook trust is incomplete.

### Phase 2: Cloud Discovery

The LLM asks only for decisions it cannot discover safely:

- desired mode: sync only or overnight maintenance;
- SSH host alias for the reviewed Linux server;
- vault and backup locations;
- Syncthing folder and peer identities;
- whether direct TCP 22000 is acceptable;
- whether model-backed reports are enabled;
- provider, model, daily budget, monthly budget, and reserve when enabled;
- backup retention and maintenance schedule.

The plan must show:

- current Mac and server state;
- packages, users, directories, services, timers, and network changes;
- secret names and storage locations without values;
- exact release artifact and checksum evidence;
- before-state, completion proof, rollback, and recovery steps;
- every action requiring administrator privileges or manual approval.

Discovery is read-only. The LLM waits for approval before installing packages,
authorizing devices, changing a firewall, writing systemd configuration, or
starting replication.

### Phase 3: Reviewed Cloud Deployment

The tested architecture uses:

- a Send & Receive Syncthing folder on the Mac and Linux server;
- mutually authorized Syncthing device certificates;
- loopback-only Syncthing GUI and REST APIs;
- one explicitly approved TCP sync port;
- an unprivileged Linux runtime account;
- separate Git history and versioned backups on each replica;
- synchronized writer leases that prevent local and cloud maintenance from
  changing the vault concurrently;
- cloud output limited to derived reports and processed task records;
- staged, server-local output when the Mac is offline;
- a root-owned, mode-`0600` environment file only when a cloud model is
  enabled.

The cloud worker must refuse mutation when replicas are incomplete, a peer is
offline, pending bytes exist, a conflict copy exists, a writer lease is active,
vault health is critical, or a likely secret appears in candidate content.

### Phase 4: Completion Proof

Installation is complete only when the LLM reports each state separately:

```text
Local Sidecar: configured / installed / running
Hook trust: approved in a fresh Codex session
Basic Memory: registered / indexed / retrievable
Syncthing: connected / complete / zero pending bytes / no conflicts
Cloud worker: installed / timer active / last run successful
Backups: recent / checksum verified / restore tested
Local benchmark: score and critical-gate result
Cloud benchmark: score and critical-gate result
Rollback: exact prior release and configuration backup
```

Both benchmarks require at least 80 and every critical gate. A historical pass
does not prove a new installation.

## Copy-Paste Prompt For Local Memory

```text
Use $obsidian-sidecar-setup to install local durable memory for Charmfile.
Inspect this Mac and the exact Sidecar release first. Ask me to select the
Obsidian vault if more than one valid candidate exists. Show the complete
read-only setup plan and wait for approval before applying it. Preserve my
existing Codex hooks, Basic Memory projects, vault content, configuration, and
services. Do not enable cloud sync. After approval, verify the installation,
have me trust the Stop hook in a fresh Codex session, and require doctor plus
the live benchmark to pass.
```

## Copy-Paste Prompt For Optional Cloud Mode

```text
Use $obsidian-sidecar-setup and read its cloud-sync contract. My local Sidecar
must be healthy before cloud work begins. I want [sync only / overnight
maintenance] using the reviewed Linux host [SSH HOST ALIAS].

Perform discovery only first. Show me the exact Mac, server, Syncthing,
network, secret-storage, backup, service, timer, verification, and rollback
plan. Use an exact checksum-verified Sidecar release. Keep the Mac vault
authoritative, keep Syncthing control APIs loopback-only, and never place
credentials in the vault, repository, logs, or plan. Do not install packages,
open ports, authorize devices, enable a model, or change services until I
approve the plan.

After approval, require complete conflict-free replication, local and cloud
doctor checks, both benchmarks at 80 or better with every critical gate, a
recent verified backup, and a tested rollback path. Report configured,
installed, running, and synchronized states separately.
```

Replace the bracketed mode and SSH alias before giving the prompt to an agent.

## Secrets And Privacy

Sync-only mode needs no model credential. Model-backed overnight maintenance
uses the provider selected by the user and must keep its credential outside the
vault and repository. On a Linux worker, the expected boundary is a root-owned,
mode-`0600` environment file loaded by systemd into the unprivileged service.

The cloud model receives bounded note excerpts, not raw transcripts, internal
reasoning, complete tool output, credentials, or unrestricted filesystem
access. Its structured output is validated and rendered only into managed
derived-report locations.

## Recovery Rules

- Never force a cloud run past a failed lease, conflict, or incomplete replica.
- Inspect both copies of every sync conflict before resolving it.
- Stop the maintenance timer and Syncthing before restoring a backup.
- Extract a backup into a temporary review directory before replacing live
  files.
- Keep the previous exact Sidecar artifact and configuration backup as the
  rollback input.
- Re-run local and cloud doctors plus the relevant benchmark after recovery.

For the implementation details and systemd templates, use the exact Sidecar
release's `docs/CLOUD_SYNC.md` and `deploy/systemd-cloud/` directory. Release
documentation is authoritative over examples copied from another machine.
