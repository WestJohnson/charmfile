---
name: obsidian-memory
description: Search and maintain the user's local Obsidian knowledge vault for durable context across Codex threads. Use when the user asks about prior work, project history, earlier decisions, unresolved tasks, recurring workflows, documentation continuity, what was previously built or configured, explicit durable recording, overnight vault tasks, vault health, Basic Memory retrieval, or memory-sidecar troubleshooting. Do not trigger for self-contained tasks that need no prior context.
---

# Obsidian Memory

Use the vault as durable, human-visible recall. Codex remains the operator and
the repository remains authoritative for source code and project documentation.

## Automation Boundary

Ordinary completed Codex work requires no special prompt or manual vault write.
The trusted `Stop` hook and background sidecar capture meaningful sessions.
Do not create a duplicate session note or invoke processing just because this
skill triggered. Use this skill for retrieval, explicit durable recording,
overnight tasks, health checks, and repair.

## Retrieve

1. Search before answering questions about prior work or decisions.
2. Prefer Basic Memory MCP `search_notes` or `build_context` against project
   `codex-vault`.
3. Read the most relevant notes; do not infer details from titles alone.
4. Confirm volatile facts against the live repository, service, account, or
   browser before acting.
5. State when a claim comes only from an older vault note.

CLI fallback when MCP is unavailable:

```sh
bm tool search-notes "query" --project codex-vault --local
bm tool read-note "memory://codex-vault/path/to/note" --project codex-vault --local
```

## Record

The background sidecar records meaningful completed sessions automatically.
Write directly only when the user explicitly asks to remember something or a
durable decision would otherwise be lost.

- Search first and update an existing note when it owns the topic.
- Ground claims in files, commands, tests, supplied evidence, or live state.
- Keep session summaries separate from canonical project documentation.
- Link project notes, decisions, runbooks, and related sessions.
- Put uncertain material in `00 Inbox/Needs Review`.
- Never store credentials, tokens, customer/private data, live account IDs,
  temporary metrics, raw transcripts, tool output, or internal reasoning.

Read [references/vault-contract.md](references/vault-contract.md) when creating
or reorganizing notes directly.

## Queue Overnight Work

When the user explicitly requests overnight vault analysis, create one atomic
Markdown task under `_System/Cloud Tasks/Pending`. Require `title`,
`type: cloud-task`, `status: pending`, and
`managed_by: codex-obsidian-sidecar`; keep instructions under 4,000 characters
and exclude credentials or private account data. Read the file back after
writing it. Do not queue ordinary Codex work or imply that the cloud worker may
rewrite, merge, or delete source notes.

## Maintain

Use the inexpensive checks for routine health:

```sh
obsidian-sidecar doctor
obsidian-sidecar cloud-doctor
```

Run the benchmark only after implementation changes, suspected regressions, or
an explicit end-to-end verification request:

```sh
obsidian-sidecar benchmark
```

Treat a score below 80, any critical failure, a failed safety gate, or stale
Basic Memory indexing as a real blocker. Formatting and index repairs may be
automatic. Primary Codex must adjudicate substantive merges, replacements, or
deletions. Do not treat `proposed`, `informational`, or `needs-review` decision
records as required cleanup: Sidecar keeps them non-authoritative and excludes
them from freshness penalties. High-confidence wording variants may reuse a
canonical record automatically; ambiguous records remain isolated and
searchable for optional later inspection.
