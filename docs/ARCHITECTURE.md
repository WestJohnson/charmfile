# Architecture

Charmfile is a macOS-only, local-first configuration and durable-memory
product assembled from small skills-first plugins. It is not an agent runtime.

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

## Product boundaries

- The default installation is Core plus Memory; Core remains useful by itself.
- Installing the Memory pack exposes a setup workflow but does not select a
  vault, install Sidecar, or enable a hook.
- The separately versioned Obsidian Sidecar is the engine behind Charmfile
  Memory rather than a second user-facing product layer.
- Browser and specialist capability packs remain independently selectable and
  do not require Memory.
- Updates preserve the installed Charmfile pack set instead of expanding every
  user to the complete marketplace.
- Local memory, vault replication, and overnight cloud maintenance are three
  separate approval boundaries. Charmfile configures none of them silently.
- The supported headless cloud pattern uses a normal Syncthing Markdown
  replica with fenced writers; Obsidian Sync and iCloud remain user-managed
  personal-device choices, not Charmfile cloud-worker transports.
- The Browser pack owns Playwright installation and keeps isolated automation
  separate from explicit signed-in Chrome attachment.
- The marketplace bundles no MCP runtime and requests no authentication. The
  optional profile registers only the public OpenAI documentation MCP.

See [Product Contract](PRODUCT_CONTRACT.md) for the normative layer and release
boundaries.

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
