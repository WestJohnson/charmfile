# Project Resume

The Charmfile Resume Kit gives a repository one portable identity and a small,
read-only re-entry surface. It uses the existing Git repository and Charmfile
Memory rather than adding another daemon, database, or agent runtime.

## Initialize a project

From the repository root, inspect the plan first:

```sh
charmfile init
```

Charmfile derives a lowercase project ID from the repository directory, uses
the directory name as the display name, and sanitizes the Git `origin` into a
portable repository identity when possible. To choose the identity explicitly:

```sh
charmfile init \
  --id example-project \
  --name "Example Project" \
  --repository https://example.com/team/example-project.git
```

After reviewing the plan, create the manifest:

```sh
charmfile init --yes
```

The only target is `.charmfile/project.toml`. Creation is atomic, the default
mode is `0644`, and a differing existing file blocks the operation. Charmfile
does not overwrite or merge that file automatically.

## Portable manifest

The manifest records only portable routing data:

```toml
# Charmfile portable project identity.
schema = 1
managed_by = "charmfile"

[project]
id = "example-project"
name = "Example Project"
canonical_id = "project:example-project"

[repository]
canonical = "https://example.com/team/example-project.git"

[memory]
project = "codex-vault"
path = "10 Projects/example-project/Project.md"
uri = "memory://codex-vault/10-projects/example-project/project"
```

Do not put credentials, local absolute paths, private hosts, vault contents,
or machine-specific state in the manifest. The Memory path is vault-relative;
the private vault location stays in the local Sidecar configuration.

## Resume work

```sh
charmfile resume
```

`resume` reads the manifest, local Git state, and the mapped Markdown project
note. It reports the current phase, latest outcome, recommended resume point,
freshness, proposed-decision count, and open work. If Memory is unavailable,
it prints the expected memory URI and an explicit unavailable state rather
than installing, activating, repairing, or syncing anything.

## Inspect health

```sh
charmfile status
```

`status` reads installed Charmfile pack metadata, the cached Sidecar health
result, local Cloud configuration presence, and project continuity freshness.
It deliberately does not run a Sidecar doctor, contact a cloud host, refresh a
marketplace, or change configuration. Use `charmfile doctor` for live Core and
selected-pack validation, and use the Sidecar's explicit doctor commands when
fresh Memory or Cloud evidence is required.

Both commands accept `--repo PATH` when invoked outside the project. `resume`
and `status` reject `--yes` and all initialization metadata because they are
strictly read-only.
