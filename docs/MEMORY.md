# Charmfile Memory

Charmfile Memory is the durable-continuity layer of Charmfile. The
`charmfile-memory` pack is part of the default installation; the Codex Obsidian
Sidecar runtime is activated only through a separate reviewed plan.

## What It Preserves

- sanitized, evidence-backed session outcomes;
- project phase, resume context, and ranked open work;
- typed operator decisions, implemented choices, and proposed recommendations;
- freshness and provenance for state that can drift;
- compact private checkpoints for long-thread continuity.

The repository remains authoritative for code and project documentation. The
vault is the human-visible continuity layer. Private checkpoints are a bounded
cache, not a third source of truth.

## What It Excludes

Raw transcripts, internal reasoning, developer instructions, complete tool
output, credentials, customer data, and temporary metrics do not belong in the
vault. Low-confidence material is quarantined or sent to a review inbox rather
than promoted silently.

## Activation

After installing the default Charmfile preset, use
`$obsidian-sidecar-setup`. The skill resolves an exact checksum-verified
Sidecar release, inspects the Mac and vault, shows a read-only setup plan, and
waits for approval before applying it.

Completion requires `verify-install`, `doctor`, trusted hook state in a fresh
Codex session, Basic Memory retrieval, and a live benchmark score of at least
80 with every critical gate passing.

Cloud operation is a third approval boundary. See [Cloud](CLOUD.md) for the
user-facing modes and [Sidecar Cloud Sync](SIDECAR_CLOUD_SYNC.md) for the
operator contract.
