# Publishing

Charmfile is published from a self-hosted Git and artifact channel. GitHub is
a public mirror and provenance surface, not an installation dependency.

## Before publishing

1. Complete every local item in `RELEASE_CHECKLIST.md`.
2. Push the reviewed signed tag to the canonical bare repository on the VPS.
3. Repack the canonical bare repository and run `git update-server-info` so
   HTTPS clones resolve the new refs without fragile loose-object transfers.
4. Publish versioned artifacts before replacing any mutable index or latest
   pointer.
5. Verify the homepage, Git clone URLs, privacy, terms, support, release
   checksums, and repository URLs used in every plugin manifest.
6. Push the same commit and tag to GitHub as a public mirror.

## Release artifact

Build from a clean commit:

```sh
./scripts/build-release.sh
```

Publish the generated archive and `SHA256SUMS` together under
`/charmfile/releases/charmfile/VERSION/`. Do not build a release from an
uncommitted working tree.

## Marketplace testing

Before a public announcement:

```sh
./scripts/install-charmfile plan
./scripts/install-charmfile install --yes
./scripts/install-charmfile doctor
./scripts/install-charmfile plan --with-browser
./scripts/install-charmfile plan --preset full
```

Start a new conversation and test at least:

- a new global install;
- append to unrelated existing guidance;
- update of an existing managed block;
- preservation of compatible external helpers;
- rejection of unmanaged conflicting targets;
- Core, standard, Browser, and full preset selection;
- isolated Playwright and signed-in Chrome as separate states when Browser is selected;
- preservation of the installed pack set across an update;
- Git-backed `charmfile update --yes`;
- backup restoration;
- one representative prompt per optional pack.

## Memory dependency

Push the reviewed Sidecar commits and signed `v0.6.1` tag to the self-hosted
bare repository, publish the versioned wheel, rollback wheel, checksums, and
`index.json`, then verify update and rollback without PyPI before presenting
`charmfile-memory` as generally available.

## Universal plugin directory

Directory submission happens only after the self-hosted release, GitHub
mirror, and public policy URLs resolve. Re-check current OpenAI plugin
requirements immediately before submission.
