# Charmfile Contributor Guidance

- Keep Charmfile lightweight: prompts for one-off constraints, `AGENTS.md` for
  durable rules, skills for reusable workflows, deterministic tools for
  actions, and memory for sanitized continuity.
- Keep the primary agent as operator and final decision maker.
- Do not add account-specific instructions, credentials, private vault data,
  personal hostnames, absolute user paths, raw transcripts, or temporary
  metrics.
- Do not add Wix-specific workflows to this repository.
- Preserve the explicit approval boundary in `charmfile-setup`; `plan` and
  `doctor` stay read-only, and `install` must require `--yes`.
- Keep the default configuration conservative. Do not install unrestricted
  sandboxing, disabled approvals, a fixed model, MCP servers, or memory without
  a user's explicit choice.
- Attribute adapted third-party material in `THIRD_PARTY_NOTICES.md`.
- Run `./scripts/validate-release.sh` before committing release changes.
- Before publishing, complete `RELEASE_CHECKLIST.md`, verify every public URL,
  build from a clean commit, scan the archive, and test installation in a new
  Codex conversation.
