# Charmfile 0.1.0-rc.2 Release Checklist

## Complete locally

- [x] Every plugin and skill passes the repository structure validator.
- [x] All eight plugins install from the marketplace in an isolated Codex
      home.
- [x] Core install, append, update, backup, guidance and shell marker
      rejection, profile, and Codex profile-load tests pass.
- [x] Browser tests cover owned installation, compatible external CLI
      preservation, isolated readiness, extension readiness, and non-macOS
      rejection.
- [x] The full lifecycle test covers plan, approval, eight-pack installation,
      profile launch, doctor, and local update.
- [x] The macOS Keychain helper passes injection, registry, deletion,
      validation, platform rejection, and native doctor tests.
- [x] `./scripts/validate-release.sh` passes for the reviewed release source.
- [x] Every plugin passes the current official plugin validator.
- [x] Every skill passes the current official skill validator.
- [ ] One representative prompt is tested for every optional pack.
- [x] Third-party notices include Microsoft Playwright CLI.
- [x] Account-specific integration content is absent from `plugins/`.
- [x] The release archive secret, personal-path, and excluded-file scans are
      clean.
- [x] Sidecar documentation separates local memory, sync-only, and overnight
      cloud maintenance and gives agents explicit plan, approval, verification,
      privacy, and rollback contracts.

## Sidecar dependency

- [ ] Review and push local Sidecar commits `db85495` and `ef6f710`.
- [x] Run the Sidecar deterministic suite: 152 tests passed on 2026-07-27.
- [x] Verify the current `0.6.0` artifact checksums and clean-install smoke
      test.
- [ ] Rebuild from the reviewed release commit, then run upgrade, rollback,
      artifact secret-scan, and live benchmark gates.
- [ ] Create and push a signed `0.6.0` tag.
- [ ] Publish the `0.6.0` wheel, source archive, agent bundle, and checksums.
- [ ] Verify installation without using a local filesystem path.

## Public repository

- [x] Re-check the Charmfile name across GitHub, npm, and PyPI on 2026-07-27.
- [ ] Create `https://github.com/WestJohnson/charmfile`.
- [ ] Push the reviewed release commit.
- [ ] Confirm README, privacy, terms, support, and security URLs resolve.
- [ ] Enable private vulnerability reporting.
- [ ] Publish the release archive and `SHA256SUMS`.
- [ ] Verify agentic installation from the public Git source on a clean Mac.
- [ ] Verify `charmfile update --yes` against the public Git marketplace.

## Plugin submission

- [ ] Re-check the current official plugin submission requirements.
- [ ] Verify publisher identity.
- [ ] Confirm manifest names and descriptions are accurate and non-promotional.
- [ ] Confirm no plugin implies OpenAI endorsement.
- [ ] Submit only after the public install path and policies are live.
