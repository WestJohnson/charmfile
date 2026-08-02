# Charmfile 0.2.0-rc.3 Release Checklist

## Resume Kit contract

- [x] `.charmfile/project.toml` contains only portable project identity and
      vault-relative Memory routing.
- [x] `charmfile init` is plan-first, approval-gated, atomic, idempotent, and
      refuses to overwrite a differing manifest.
- [x] `charmfile resume` combines Git and durable project context without
      writing to the repository, Sidecar configuration, or vault.
- [x] `charmfile status` reports installed layers, cached Memory health, Cloud
      configuration presence, continuity freshness, and proposed decisions
      without running live repair or cloud checks.
- [x] Missing or inactive Memory produces an explicit unavailable state.

## Product boundaries

- [x] Core, Memory, Cloud, and optional capability-pack boundaries remain
      explicit.
- [x] The default preset remains Core plus Memory without vault or cloud
      activation.
- [x] Updates continue to preserve the installed Charmfile pack set.
- [x] Sidecar remains the separately versioned engine behind Charmfile Memory.

## Package verification

- [x] Repository, plugin, skill, privacy, credential, and shell validation pass.
- [x] Portable init, resume, status, preservation, and unavailable-state tests
      pass in an isolated environment.
- [x] Core, standard, Browser, individual-pack, and full installs pass in
      isolated Codex homes.
- [x] Existing rc.5 full installation updates without losing any pack.
- [x] Sidecar cached health below 80 remains a visible degraded state and the
      strict post-update doctor continues to fail below that threshold.
- [ ] The 0.2.0-rc.3 archive is built from the clean signed release commit and
      passes checksum, secret, personal-path, and excluded-integration scans.

## Publication

- [ ] Push the reviewed Charmfile commit and signed `v0.2.0-rc.3` tag to the
      canonical self-hosted Git repository and GitHub mirror.
- [ ] Publish the immutable archive and checksum before updating the mutable
      Charmfile release index.
- [ ] Update the production website through a timestamped rollback bundle.
- [ ] Verify homepage, policies, Git refs, archive, checksum, clean install,
      managed update, desktop/mobile UI, and rollback inputs over HTTPS.

Publication evidence is recorded only after every public check completes.
