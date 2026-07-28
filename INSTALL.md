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
