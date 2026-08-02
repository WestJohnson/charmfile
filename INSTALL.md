# Install Charmfile on macOS

Charmfile is designed to be installed by an agent from a reviewed checkout.
Clone the canonical repository:

```sh
git clone https://charmfile.com/git/charmfile.git
cd charmfile
```

Give Codex this repository and use:

```text
Use $install-charmfile to inspect this Mac and install the standard Charmfile
Core and Memory configuration. Show me the exact plan and wait for approval. Preserve my
existing config, plugins, projects, secrets, browser profile, and unrelated
AGENTS.md guidance. Do not activate a vault or cloud mode. After installation,
run the Charmfile doctor and tell me how to plan local Memory activation.
```

The equivalent deterministic commands are:

```sh
./scripts/install-charmfile plan
./scripts/install-charmfile install --yes
./scripts/install-charmfile doctor
```

The default `standard` preset installs Core and the Memory setup pack. Other
supported selections are:

```sh
./scripts/install-charmfile plan --preset core
./scripts/install-charmfile plan --with-browser
./scripts/install-charmfile plan --with research
./scripts/install-charmfile plan --preset full
```

Pass the same selection to `install --yes` after approving its plan. Updates
preserve the currently installed Charmfile packs and do not accept a preset
override.

After a published Git-backed installation:

```sh
charmfile plan
charmfile update --yes
charmfile doctor --after-update
```

Open a new terminal and start a new Codex session after an install or update.

## Activate Charmfile Memory

The standard Charmfile install adds the Memory skills but does not select a
vault or activate the Sidecar engine. Use a second plan-and-approval phase:

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
[Cloud](docs/CLOUD.md) and
[Sidecar Cloud Sync](docs/SIDECAR_CLOUD_SYNC.md) for the mode choices, cloud
preflight, copy-paste prompt, proof requirements, and recovery boundaries.
