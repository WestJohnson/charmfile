# Publishing

Charmfile is prepared as a repo marketplace for local testing. Publishing is a
separate external action.

## Before creating the public repository

1. Complete every local item in `RELEASE_CHECKLIST.md`.
2. Confirm the `WestJohnson/charmfile` repository name is still available.
3. Create the public repository without generated starter files.
4. Add the new remote and push the reviewed clean commit.
5. Verify the homepage, privacy, terms, support, and repository URLs used in
   every plugin manifest.

## Release artifact

Build from a clean commit:

```sh
./scripts/build-release.sh
```

Publish the generated archive and `SHA256SUMS` together. Do not build a release
from an uncommitted working tree.

## Marketplace testing

Before a public announcement:

```sh
./scripts/install-charmfile plan
./scripts/install-charmfile install --yes
./scripts/install-charmfile doctor --require-live-chrome
```

Start a new conversation and test at least:

- a new global install;
- append to unrelated existing guidance;
- update of an existing managed block;
- preservation of compatible external helpers;
- rejection of unmanaged conflicting targets;
- isolated Playwright and signed-in Chrome as separate states;
- Git-backed `charmfile update --yes`;
- backup restoration;
- one representative prompt per optional pack.

## Memory dependency

Push the two local Sidecar commits, create a signed `0.6.0` tag, publish the
wheel and checksums, and verify a clean install before presenting
`charmfile-memory` as generally available.

## Universal plugin directory

Directory submission happens only after the GitHub release and public policy
URLs resolve. Re-check current OpenAI plugin requirements immediately before
submission.
