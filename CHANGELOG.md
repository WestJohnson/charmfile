# Changelog

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
