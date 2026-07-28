# Install Charmfile on macOS

Charmfile is designed to be installed by an agent from a reviewed checkout.
Give Codex this repository and use:

```text
Use $install-charmfile to inspect this Mac and install the full Charmfile
Codex harness. Show me the exact plan and wait for approval. Preserve my
existing config, plugins, projects, secrets, browser profile, and unrelated
AGENTS.md guidance. After installation, run the full doctor and report
isolated Playwright and signed-in Chrome readiness separately.
```

The equivalent deterministic commands are:

```sh
./scripts/install-charmfile plan
./scripts/install-charmfile install --yes
./scripts/install-charmfile doctor
```

After a published Git-backed installation:

```sh
charmfile plan
charmfile update --yes
charmfile doctor
```

Open a new terminal and start a new Codex session after an install or update.

## Optional durable memory

The full Charmfile install adds the memory skills but does not select a vault
or activate Sidecar. Use a second plan-and-approval phase:

```text
Use $obsidian-sidecar-setup to install local durable memory for Charmfile.
Inspect this Mac and the exact Sidecar release first. Show the complete
read-only setup plan and wait for approval. Preserve my existing hooks, Basic
Memory projects, vault content, configuration, and services. Do not enable
cloud sync. After approval, verify the installation, have me trust the Stop
hook in a fresh Codex session, and require doctor plus the live benchmark to
pass.
```

Cloud sync and overnight maintenance are a third, separately approved phase.
They are never enabled by the base installer. Read
[Sidecar Cloud Sync](docs/SIDECAR_CLOUD_SYNC.md) for the mode choices, cloud
preflight, copy-paste prompt, proof requirements, and recovery boundaries.
