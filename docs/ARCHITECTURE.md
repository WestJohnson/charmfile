# Architecture

Charmfile is a marketplace of small skills-only plugins, not an agent runtime.

## Authority

Codex remains the operator. Charmfile supplies reusable instructions and a
deterministic configuration helper; it does not run a second orchestration
loop.

## Layers

1. **Prompt:** current-task constraints.
2. **Guidance:** durable user or repository conventions in `AGENTS.md`.
3. **Skills:** reusable workflows loaded only when relevant.
4. **Tools:** MCP servers and connectors selected by the user.
5. **Memory:** optional sanitized project continuity.
6. **Review:** explicitly requested independent agents.

## Plugin boundaries

- `charmfile-core` is useful by itself.
- Specialist packs do not require memory.
- The memory pack guides installation of the separately versioned Obsidian
  Sidecar rather than hiding it inside Core.
- The marketplace contains no bundled MCP server and requests no
  authentication.

## Safety boundaries

- Setup is plan-first and block-managed.
- Existing guidance receives an adjacent backup.
- Configuration examples are never applied automatically.
- Secret values stay in the operating system's secret store.
- Live account skills distinguish read-only evidence from approved mutation.
- The public package excludes personal paths, data, hosts, and Wix workflows.
