# Charmfile Packs

Charmfile keeps the product core small and loads specialist guidance only when
the user selects it.

## Default

| Pack | Purpose |
| --- | --- |
| `charmfile-core` | Portable profile, guidance, lifecycle, doctor, and secret helper |
| `charmfile-memory` | Local durable-memory setup, retrieval, health, and optional cloud planning |

## Optional

| Pack | Purpose |
| --- | --- |
| `charmfile-browser` | Isolated Playwright plus explicit signed-in Chrome attachment |
| `charmfile-frontend` | Responsive and accessible frontend implementation and QA |
| `charmfile-marketing` | Ads, analytics, DataForSEO, reconciliation, and launch review |
| `charmfile-research` | Source-backed technical and product research |
| `charmfile-infrastructure` | VPS health, capacity, backups, and operations review |
| `charmfile-threejs` | Focused Three.js workflows loaded by topic |

Use `--with-browser` for the Browser pack, `--with PACK` for one additional
pack, or `--preset full` for the original eight-pack setup. Updating preserves
the currently installed Charmfile pack set.
