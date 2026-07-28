# Architecture

Charmfile is a macOS-only marketplace of small skills-first plugins, not an
agent runtime.

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

The portable profile is a named Codex layer selected through
`charmfile-codex`. It overlays the user's base configuration without mutating
it.

## Plugin boundaries

- `charmfile-core` is useful by itself.
- Specialist packs do not require memory.
- The memory pack guides installation of the separately versioned Obsidian
  Sidecar rather than hiding it inside Core.
- The Browser pack owns Playwright installation and keeps isolated automation
  separate from explicit signed-in Chrome attachment.
- The marketplace bundles no MCP runtime and requests no authentication. The
  optional profile registers only the public OpenAI documentation MCP.

## Safety boundaries

- Setup is plan-first and block-managed.
- Existing guidance receives an adjacent backup.
- The PATH launcher directory is added through one bounded `.zprofile` block.
- The base Codex configuration is never modified.
- The managed profile is portable, conservative, and selected explicitly.
- Secret values stay in the operating system's secret store.
- Compatible external Playwright and secret helpers are preserved.
- Chrome extensions and live-tab attachment remain user-approved.
- Live account skills distinguish read-only evidence from approved mutation.
- The public package excludes personal paths, data, hosts, and account-specific
  workflows.
