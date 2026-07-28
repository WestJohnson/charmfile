# Charmfile Contributor Guidance

- Keep Charmfile lightweight: prompts for one-off constraints, `AGENTS.md` for
  durable rules, skills for reusable workflows, deterministic tools for
  actions, and memory for sanitized continuity.
- Keep the primary agent as operator and final decision maker.
- Do not add account-specific instructions, credentials, private vault data,
  personal hostnames, absolute user paths, raw transcripts, or temporary
  metrics.
- Do not add Wix-specific workflows to this repository.
- Keep the public lifecycle macOS-only unless the package is deliberately
  redesigned and retested for another platform.
- Use `.agents/skills/install-charmfile/SKILL.md` as the source of truth for
  agentic install and update work.
- Preserve the explicit approval boundary in `charmfile-setup`; `plan` and
  `doctor` stay read-only, and `install` must require `--yes`.
- Keep the default configuration conservative. Do not install unrestricted
  sandboxing, disabled approvals, a fixed model, MCP servers, or memory without
  a user's explicit choice.
- Never merge public defaults into a user's base `config.toml`; update the
  managed `charmfile.config.toml` profile instead.
- Keep isolated Playwright and signed-in Chrome as separate readiness states.
  Never automate extension installation or browser-profile substitution.
- When changing the Playwright CLI pin, update attribution, browser tests, the
  dependency contract, and release evidence together.
- Attribute adapted third-party material in `THIRD_PARTY_NOTICES.md`.
- Run `./scripts/validate-release.sh` before committing release changes.
- Before publishing, complete `RELEASE_CHECKLIST.md`, verify every public URL,
  build from a clean commit, scan the archive, and test installation in a new
  Codex conversation.
