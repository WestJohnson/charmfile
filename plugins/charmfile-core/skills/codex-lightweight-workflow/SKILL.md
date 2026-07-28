---
name: codex-lightweight-workflow
description: Use when the user wants a lightweight Codex-native workflow, wants to avoid heavyweight agent orchestration, needs real work done with simple logging, or asks how to structure tasks with skills, MCP tools, memory, or subagents.
---

# Codex Lightweight Workflow

Default to the smallest workflow that gets real work done.

## Layer Rules

- Codex is the operator and final decision maker.
- Use a skill for reusable instructions.
- Use MCP tools for small deterministic actions or live external access.
- Use subagents only when the user explicitly wants parallel review or the work clearly benefits from independent specialists.
- Use memory for durable preferences and facts, not transient metrics.
- Do not create multi-agent ceremony for simple tasks.

## Basic Loop

For ordinary tasks:

1. Clarify the objective only if needed.
2. Gather the minimum evidence needed.
3. Make the change directly.
4. Verify the result.
5. Record a short note only when the decision should survive the thread.

For larger tasks:

1. Create or maintain a small work packet with objective, context, acceptance criteria, constraints, and checks.
2. Keep the packet short and update it only at meaningful checkpoints.
3. Use the normal Codex tools for real work: shell, files, Chrome, connectors, APIs, or browser surfaces explicitly requested by the user.
4. Ask for subagents only for independent reviews that would materially improve the result.

## When The Lightweight Bridge Is Available

Use these MCP tools if surfaced in the session:

- `codex_toolbelt_status` to confirm the local bridge is available.
- `codex_create_work_packet` for non-trivial multi-step work.
- `codex_record_note` for durable decisions, follow-ups, or workflow observations.
- `codex_list_notes` and `codex_list_work_packets` for recent local context.

If those tools are not available, continue with normal files or concise in-thread notes.

## Anti-Patterns

- Do not turn every task into an agent team.
- Do not ask advisory agents to do work they cannot actually execute.
- Do not treat persona output as live evidence.
- Do not store campaign metrics, date-window reads, or one-off fixes as durable memory.
- Do not build a new framework when a prompt, skill, or small helper script would do.
