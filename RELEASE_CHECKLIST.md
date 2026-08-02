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
- [x] The 0.2.0-rc.3 archive is built from the clean signed release commit and
      passes checksum, secret, personal-path, and excluded-integration scans.

## Publication

- [x] Push the reviewed Charmfile commit and signed `v0.2.0-rc.3` tag to the
      canonical self-hosted Git repository and GitHub mirror.
- [x] Publish the immutable archive and checksum before updating the mutable
      Charmfile release index.
- [x] Update the production website through a timestamped rollback bundle.
- [x] Verify homepage, policies, Git refs, archive, checksum, clean install,
      managed update, desktop/mobile UI, and rollback inputs over HTTPS.

## Publication evidence

- Signed release commit: `1d7be190e760d9cb3be61d518f18585324161129`.
- Signed tag object: `c1a48008b8a6fb6afce88222db39808728f14d5c`.
- Archive SHA-256: `00dcb16f8fd6e936e9625bf3de45bcbdd9cb8a085cc59f267e5ef0ec620b6662`.
- Deployed site source: `15eb2fb3d308bb55c95fe8e3d7f318606afc41d7`.
- Production bundle:
  `/var/www/open-generative-ai-showcase/charmfile-0.2.0-rc.3-site-v1`.
- Rollback backup:
  `/root/charmfile-deploy-backups/20260802T011448Z-charmfile-0.2-rc3`.
- A clean HTTPS Git-backed standard install selected only Core and Memory in
  six seconds, kept `~/.gitconfig` absent, and a managed update completed in
  nine seconds with a healthy Sidecar score of 95.
- `0.2.0-rc.1` and `0.2.0-rc.2` remain immutable historical artifacts. The
  release index advances to rc.3 because clean-home verification exposed and
  then resolved a Git 2.54 HTTP/2 transport stall.
