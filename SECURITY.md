# Security Policy

## Supported version

Security fixes are prepared for the latest release line.

## Reporting

Do not include credentials, private vault content, customer data, live account
identifiers, or raw transcripts in a public issue.

Before the public repository is created, report security concerns privately to
the maintainer. After publication, use the repository's private security
advisory flow.

## Security model

- Core installation is plan-first and requires `--yes`.
- Existing guidance is backed up before replacement.
- Only the marked Charmfile block is managed.
- The shell PATH change is isolated to a second marked block in `.zprofile`.
- Malformed or duplicate markers stop installation.
- The base `config.toml` is never edited. The opt-in profile uses on-request
  approval and workspace-write sandboxing and contains no fixed model or
  private MCP endpoint.
- Unmanaged files at profile, launcher, or CLI-wrapper targets are preserved
  or block installation.
- Secret values stay in the operating system's secret store.
- The Playwright Extension remains a user-approved Chrome installation.
- Live Chrome attachment does not authorize a live-account mutation.
- Public validation rejects personal absolute paths, credential-shaped
  strings, scaffold placeholders, and excluded integration content.

## Out of scope

Charmfile cannot make unrestricted agent permissions safe. Users remain
responsible for their Codex sandbox, approval policy, connected accounts, and
the actions they authorize.
