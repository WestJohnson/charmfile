# Charmfile 0.1.0-rc.3 Release Checklist

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
- [x] One representative prompt is tested for every pack with isolated,
      read-only routing probes on 2026-07-27.
- [x] Third-party notices include Microsoft Playwright CLI.
- [x] Account-specific integration content is absent from `plugins/`.
- [x] The release archive secret, personal-path, and excluded-file scans are
      clean.
- [x] Sidecar documentation separates local memory, sync-only, and overnight
      cloud maintenance and gives agents explicit plan, approval, verification,
      privacy, and rollback contracts.

## Sidecar dependency

- [x] Review and push the Sidecar release commits through `8ede4ed`.
- [x] Run the Sidecar deterministic suite: 152 tests passed on 2026-07-27,
      followed by a green macOS/Linux Python 3.11/3.13 CI matrix.
- [x] Verify the current `0.6.0` artifact checksums and clean-install smoke
      test.
- [x] Rebuild from the reviewed release commit, then run upgrade, rollback,
      artifact secret-scan, and live benchmark gates. The isolated
      `0.5.1 -> 0.6.0 -> 0.5.1 -> 0.6.0` cycle passed; local benchmarks scored
      100 twice and the cloud benchmark scored 90 with no failed critical gate.
- [ ] Push the locally verified signed `v0.6.0` tag.
- [ ] Publish the `0.6.0` wheel, source archive, agent bundle, and checksums.
- [ ] Verify installation without using a local filesystem path.

## Public repository

- [x] Re-check the Charmfile name across GitHub, npm, and PyPI on 2026-07-27.
- [x] Create `https://github.com/WestJohnson/charmfile`.
- [x] Push the reviewed release commit.
- [x] Confirm README, privacy, terms, support, and security URLs resolve.
- [x] Enable private vulnerability reporting.
- [ ] Publish the release archive and `SHA256SUMS`.
- [x] Verify agentic installation from the public Git source in a clean,
      isolated Codex home on macOS.
- [x] Verify the Git-backed Charmfile marketplace upgrade path.

## Plugin submission

- [ ] Re-check the current official plugin submission requirements.
- [ ] Verify publisher identity.
- [ ] Confirm manifest names and descriptions are accurate and non-promotional.
- [ ] Confirm no plugin implies OpenAI endorsement.
- [ ] Submit only after the public install path and policies are live.
