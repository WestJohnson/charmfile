# Vault Contract

## Ownership

- Repository files: canonical code and project documentation.
- Obsidian: durable work history, decisions, connections, and recall.
- Basic Memory: rebuildable search index over Obsidian Markdown.
- Codex generated memories: supplemental recall, not canonical vault content.

## Layout

```text
00 Inbox/
10 Projects/
20 Areas/
30 Knowledge/
40 Decisions/
50 Runbooks/
60 Sessions/
90 Archive/
_System/
```

## Required Managed Frontmatter

All managed notes require `title`, `type`, and
`managed_by: codex-obsidian-sidecar`. Work sessions additionally require
`project`, `date`, `session_id`, and `confidence`.

## Mutation Rules

- Use atomic writes and verify by reading the file back.
- Use `session_id` for idempotency.
- Preserve manual content outside sidecar marker blocks.
- Auto-fix metadata, formatting, links, and generated indexes only.
- Never auto-delete or semantically merge notes.
- Quarantine invalid output and stop after three failed attempts.

## Retrieval Quality

Search tests must cover exact and semantic queries. Passing requires at least
80/100 plus all critical safety gates.
