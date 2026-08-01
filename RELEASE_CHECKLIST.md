# Charmfile 0.1.0-rc.6 Release Checklist

## Product contract

- [x] Core, Memory, Cloud, and optional capability-pack boundaries are explicit.
- [x] The default preset is Core plus Memory without vault or cloud activation.
- [x] Core-only, Browser, individual-pack, and full selections remain available.
- [x] Existing installations preserve their installed Charmfile packs on update.
- [x] Sidecar remains a separately versioned engine behind Charmfile Memory.

## Sidecar 0.6.1 dependency

- [x] Deterministic Sidecar suite and Ruff validation pass.
- [x] The reviewed `v0.6.1` commit and tag match the canonical self-hosted Git
      repository and GitHub mirror.
- [x] The public wheel, rollback wheel, checksums, and update index remain
      available and checksum-valid.
- [x] Local Sidecar doctor and benchmark remain healthy after the Charmfile
      consolidation.
- [x] Cloud doctor and benchmark are recorded separately and do not block
      local-only Charmfile installation.

Local Sidecar evidence: 164 tests and Ruff pass; doctor scores 95 with zero
critical failures; benchmark scores 100. Cloud doctor is healthy with a fully
synced replica. `cloud-benchmark` is a Linux deployment gate and cannot run on
this macOS release workstation because `systemctl` is unavailable; it remains
separate from the local-memory release gate.

## Charmfile package

- [x] Repository, plugin, skill, privacy, credential, and shell validation pass.
- [x] Core, standard, standard plus Browser, and full installs pass in isolated
      Codex homes.
- [x] Individual `--with PACK` selection and invalid-pack rejection pass.
- [x] Updates preserve each isolated installation's exact pack count.
- [x] Existing rc.5 full installation updates without losing any pack.
- [x] Sidecar health below 80 fails the strict post-update gate.
- [x] The rc.6 archive is built from a clean tagged commit and passes checksum,
      secret, personal-path, and excluded-integration scans.

## Publication

- [x] Push the reviewed Charmfile commit and `v0.1.0-rc.6` tag to the canonical
      self-hosted Git repository and GitHub mirror.
- [x] Publish the immutable rc.6 archive and checksums before updating the
      mutable Charmfile release index.
- [x] Update the production release site through a timestamped rollback bundle.
- [x] Verify homepage, docs, policies, Git refs, archive, checksum, standard
      install, full-install update preservation, and rollback inputs over HTTPS.

Release evidence: signed tag `v0.1.0-rc.6` resolves to `3d06730`; the published
archive SHA-256 is `1173c34fdcb97abd41889fedbca9bf9e6b36d9b462cba4346c2cab24203850f2`.
A clean live Git-backed standard installation selected exactly Core and Memory;
a live Git-backed full installation and managed update preserved all eight
packs. Production uses the rc.6 site bundle with rollback inputs at
`/root/charmfile-deploy-backups/20260801T202309Z-charmfile-rc6`.
