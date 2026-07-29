# Charmfile 0.1.0-rc.4 Release Checklist

## Sidecar 0.6.1 dependency

- [x] Deterministic Sidecar suite passes: 164 tests on 2026-07-28.
- [x] Ruff validation passes.
- [x] The saturated-checkpoint regression preserves current-turn evidence,
      compacts only `c1` carry-forward, writes successfully, and leaves no
      failed event.
- [x] Old proposals, informational records, and ambiguous duplicate candidates
      remain searchable without becoming freshness warnings.
- [x] The wheel, source archive, and agent bundle are built from clean commit
      `64ce54c`.
- [x] Artifact checksums, secret scan, and personal-data scan pass.
- [x] The isolated Python 3.11 release smoke test passes.
- [x] The isolated `0.5.1 -> 0.6.1 -> 0.5.1 -> 0.6.1` cycle passes.
- [ ] The exact update and rollback flow passes against the public self-hosted
      index without PyPI or a local checkout.
- [ ] Local `verify-install`, `doctor`, and two live benchmark runs pass after
      upgrade.
- [ ] Cloud doctor and cloud benchmark pass after the reviewed worker upgrade.

## Charmfile package

- [x] Every plugin and skill passes the repository structure validator.
- [x] All eight plugins install from the marketplace in an isolated Codex
      home.
- [x] Core install, append, update, backup, profile, browser, secret-helper,
      full-lifecycle, and local-update tests pass.
- [x] The memory pack resolves the checksum-verified Sidecar `0.6.1` release.
- [x] `./scripts/validate-release.sh` passes.
- [x] The release archive secret, personal-path, and excluded-integration scans
      are clean.
- [ ] A clean self-hosted Git install and managed update pass.

## Publication

- [ ] Push reviewed Sidecar commit and signed `v0.6.1` tag to the canonical
      self-hosted Git repository.
- [ ] Publish immutable Sidecar `0.6.1` artifacts and checksums before replacing
      the mutable release index.
- [ ] Push the same Sidecar commit and tag to the GitHub mirror.
- [ ] Push reviewed Charmfile commit and signed `v0.1.0-rc.4` tag to the
      canonical self-hosted Git repository and GitHub mirror.
- [ ] Publish the Charmfile rc.4 archive and checksums before replacing its
      mutable index.
- [ ] Update the production release tree through a timestamped rollback bundle,
      run `nginx -t`, and reload only after it passes.
- [ ] Verify homepage, privacy, terms, support, security, Git, release,
      checksum, install, update, and rollback URLs over HTTPS.
