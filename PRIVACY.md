# Privacy

Charmfile Core and the bundled specialist skills do not operate a hosted
service and do not collect telemetry.

## Core configuration

The setup helper reads only:

- its bundled templates;
- the exact target `AGENTS.md` selected by the user;
- local command availability needed for `doctor`.

It writes only after explicit approval and only to the reported guidance target
and, when requested, the local `codex-secrets` executable path.

## Secret helper

`codex-secrets` stores values in macOS Keychain or Linux libsecret. Its local
registry contains variable names only. Charmfile does not receive, transmit, or
retain those values.

## Optional memory

Codex Obsidian Sidecar is a separate, local-first component with its own
configuration and documentation. It is designed to exclude raw transcripts,
internal reasoning, complete tool output, credentials, and private account
identifiers from durable notes.

## External tools

Specialist skills may instruct an agent to use services selected and
authorized by the user. Data handling then depends on that service and the
user's configuration. Charmfile itself does not proxy those requests.

Questions or privacy reports should be opened through the repository's public
issue tracker after publication.
