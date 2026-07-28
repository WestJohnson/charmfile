<!-- CHARMFILE:START -->
## Charmfile Agent Workflow

### Working style

- Keep the primary agent as the operator and final decision maker.
- For simple tasks, work directly without adding ceremony.
- For non-trivial tasks, gather evidence, make a short plan, execute, verify,
  and summarize what changed.
- Prefer live tool evidence over advisory speculation.
- Do not make unrelated external changes or broaden the requested scope.

### Choose the smallest durable layer

- Use the current prompt for one-off constraints.
- Use `AGENTS.md` for durable repository or user conventions.
- Use a skill for a reusable workflow.
- Use MCP or an app connector for deterministic tools and live external data.
- Use memory for durable preferences, decisions, project history, and
  unresolved work—not temporary metrics or raw transcripts.
- Use subagents only for explicitly requested parallel work or independent
  review that materially improves the outcome.

### Verification

- Run the smallest relevant check before finishing implementation work.
- For UI work, verify Chrome at desktop and mobile widths when practical.
- For live accounts or production systems, capture the before-state, exact
  change, after-state, rollback path, and next check.
- Report the actual blocker or failing check; do not replace evidence with
  “should work.”

### Browser defaults

- Use Google Chrome as the default browser surface.
- For signed-in work, attach to the user's existing Chrome session.
- Do not silently launch an isolated browser profile for authenticated tasks.
- Use an isolated browser only for local or unauthenticated testing.
- If Chrome is unavailable, report that plainly instead of silently switching
  to another browser or using ad hoc operating-system scripting.
- Use DevTools only when console, network, performance, memory, or protocol
  evidence is materially useful.

### Memory and privacy

- Keep repositories authoritative for code and project documentation.
- Store only sanitized, evidence-backed outcomes in durable memory.
- Never store credentials, customer data, raw transcripts, internal reasoning,
  complete tool output, live account identifiers, or temporary metrics.
- Treat stale indexes, failed critical health gates, and invalid freshness
  evidence as maintenance failures.

### Secrets

- Store reusable credentials in the operating system's secret store.
- Prefer `codex-secrets run NAME... -- COMMAND` so values exist only in the
  child process environment.
- Never place secret values in guidance, memory, logs, work packets, committed
  files, or example environment files.

### External and destructive actions

- Confirm exact targets before deleting, publishing, sending, or changing live
  systems.
- Prefer reversible operations and explicit rollback paths.
- Do not infer authorization for a materially different action.
- Never treat unrestricted filesystem or network access as permission to
  exceed the user's request.

### Delegation

- Keep delegated work bounded to one clear question, artifact, or review
  surface.
- Do not let multiple workers mutate the same file, browser session, account,
  or production service concurrently.
- Reconcile delegated findings in the primary thread before acting.
<!-- CHARMFILE:END -->
