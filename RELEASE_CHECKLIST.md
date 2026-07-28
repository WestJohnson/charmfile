# Charmfile 0.1.0 Release Checklist

## Complete locally

- [ ] `./scripts/validate-release.sh` passes from a clean checkout.
- [ ] Every plugin passes the current official plugin validator.
- [ ] Every skill passes the current skill validator.
- [ ] All seven plugins install from the repository marketplace in an isolated
      Codex home.
- [ ] The archive secret and personal-path scan is clean.
- [ ] Core install, append, update, backup, restoration guidance, and doctor
      tests pass.
- [ ] Optional secret helper passes simulated macOS and Linux backend tests plus
      a native macOS doctor check.
- [ ] One representative prompt is tested for every optional pack.
- [ ] Third-party notices and licenses are reviewed.
- [ ] Wix-specific content is absent from `plugins/`.

## Sidecar dependency

- [ ] Review and push local Sidecar commits `db85495` and `ef6f710`.
- [ ] Run the Sidecar deterministic suite, clean-install, upgrade, rollback,
      artifact scan, and live benchmark gates.
- [ ] Create and push a signed `0.6.0` tag.
- [ ] Publish the `0.6.0` wheel, source archive, agent bundle, and checksums.
- [ ] Verify installation without using a local filesystem path.

## Public repository

- [ ] Re-check the Charmfile name across GitHub and package registries.
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
