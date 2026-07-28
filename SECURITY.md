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
- Malformed or duplicate markers stop installation.
- No model, sandbox, approval policy, MCP server, or memory service is enabled
  automatically.
- Secret values stay in the operating system's secret store.
- Public validation rejects personal absolute paths, credential-shaped
  strings, TODO placeholders, and Wix-specific packaged content.

## Out of scope

Charmfile cannot make unrestricted agent permissions safe. Users remain
responsible for their Codex sandbox, approval policy, connected accounts, and
the actions they authorize.
