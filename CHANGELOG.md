# Changelog

## 0.2.0-rc.1 - 2026-08-01

- Added a portable `.charmfile/project.toml` identity with plan-first,
  approval-gated `charmfile init` creation and no automatic overwrite.
- Added read-only `charmfile resume` output that combines the repository's Git
  state with sanitized project continuity from Charmfile Memory.
- Added read-only `charmfile status` output for installed layers, cached Memory
  health, Cloud configuration, continuity freshness, and proposed decisions.
- Added isolated lifecycle coverage for credential stripping, idempotence,
  existing-manifest preservation, unavailable states, and read-only guarantees.
- Changed the canonical source, dependency, and installation references to the
  `charmfile.com` release channel.

## 0.1.0-rc.6 - 2026-08-01

- Consolidated the product contract around lightweight Core configuration,
  default durable-memory capability, and optional user-owned cloud operation.
- Changed new installs to the `standard` Core plus Memory preset while keeping
  `core`, `--with-browser`, individual `--with PACK`, and the original
  eight-pack `full` selection available.
- Changed updates to preserve the currently installed Charmfile pack set
  instead of expanding every installation to the complete marketplace.
- Changed the doctor to validate the installed pack set and report Browser and
  Sidecar activation independently.
- Added product, Memory, Cloud, and capability-pack documentation with the
  Sidecar positioned as the separately versioned Charmfile Memory engine.
- Added isolated lifecycle coverage for core, standard, browser, and full
  installs, update preservation, invalid selections, and Sidecar health gates.

## 0.1.0-rc.5 - 2026-08-01

- Added `charmfile doctor --after-update`, which validates the effective stable
  Codex workflow features and enforces the optional Sidecar health gate when
  Sidecar is installed.
- Added installed-Codex compatibility checks for every stable feature pinned by
  the managed profile so unsupported releases fail visibly after an update.
- Updated the portable profile with pragmatic communication, Git branch status,
  and explicit stable goals, plugin, multi-agent, personality, and unified-exec
  feature pins.
- Added lifecycle regressions for successful post-update verification and the
  required failure when Sidecar health falls below 80.

## 0.1.0-rc.4 - 2026-07-28

- Updated the optional memory pack to the checksum-verified Sidecar `0.6.1`
  release.
- Added deterministic long-thread recovery: saturated curator output discards
  only the oldest checkpoint-only carry-forward items, never current-turn
  evidence or canonical vault history.
- Kept proposals, informational records, and ambiguous duplicate candidates
  searchable but explicitly non-authoritative so they do not become freshness
  failures or force users through a manual review backlog.
- Added release guidance that distinguishes required health maintenance from
  optional decision-inbox cleanup.

## 0.1.0-rc.3 - 2026-07-27

- Made the West Hawaii HTTPS release channel canonical for Git, checksummed
  archives, policy documents, Sidecar wheels, update metadata, and rollback;
  GitHub remains a public mirror.
- Made the public package and lifecycle explicitly macOS-only.
- Added a source-visible agentic installer with plan, install, update, and
  full-doctor workflows.
- Added the `charmfile-browser` pack with the Microsoft Playwright CLI skill,
  reproducible isolated automation, and explicit signed-in Chrome attachment.
- Added separate readiness reporting for isolated Playwright and live Chrome.
- Added a managed, conservative `charmfile.config.toml` profile and
  `charmfile-codex` launcher without modifying the base user config.
- Added a bounded `.zprofile` block so the installed launchers work without
  manual PATH repair.
- Added updateable lifecycle launchers and Git-marketplace refresh behavior.
- Made first-run installation create a missing Codex home and verify Codex
  marketplace and plugin confirmations instead of accepting false-success CLI
  output.
- Preserved compatible existing Playwright and secret helpers.
- Added an LLM-oriented Sidecar cloud-sync guide, explicit local/sync/cloud
  mode boundaries, verification contracts, and copy-paste installation prompts.
- Expanded isolated tests for the eight-pack marketplace, browser modes,
  profile safety, full installation, and local updates.

## 0.1.0-rc.1 - 2026-07-27

- Introduced the Charmfile name and plugin marketplace.
- Added a plan-first core installer and setup doctor.
- Added conservative public `AGENTS.md` guidance.
- Added optional Keychain credential injection.
- Packaged durable memory, frontend, marketing, research, infrastructure, and
  Three.js skills as independently installable plugins.
- Removed personal absolute paths and implicit `.env` discovery.
- Excluded account-specific workflows and personal configuration.
- Added validation, privacy, security, attribution, and publishing gates.
