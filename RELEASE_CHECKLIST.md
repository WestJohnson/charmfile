# Charmfile 0.1.0-rc.1 Release Checklist

## Complete locally

- [x] `./scripts/validate-release.sh` passes from a clean checkout.
- [x] Every plugin passes the current official plugin validator.
- [x] Every skill passes the current skill validator.
- [x] All seven plugins install from the repository marketplace in an isolated
      Codex home.
- [x] The archive secret and personal-path scan is clean.
- [x] Core install, append, update, backup, restoration guidance, and doctor
      tests pass.
- [x] Optional secret helper passes simulated macOS and Linux backend tests plus
      a native macOS doctor check.
- [ ] One representative prompt is tested for every optional pack.
- [x] Third-party notices and licenses are reviewed.
- [x] Wix-specific content is absent from `plugins/`.

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
- [ ] Verify installation from the public Git source in a clean environment.

## Plugin submission

- [ ] Re-check the current official plugin submission requirements.
- [ ] Verify publisher identity.
- [ ] Confirm manifest names and descriptions are accurate and non-promotional.
- [ ] Confirm no plugin implies OpenAI endorsement.
- [ ] Submit only after the public install path and policies are live.
