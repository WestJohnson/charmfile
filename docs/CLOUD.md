# Charmfile Cloud

Charmfile works locally by default. Cloud compatibility extends Charmfile
Memory to a user-owned VPS or server without making that server a requirement.

| Mode | Server | Model API | Shared-vault writes |
| --- | --- | --- | --- |
| Local Memory | No | No | Local Sidecar only |
| Vault sync | Optional | No | User-selected sync system |
| Maintenance worker | Yes | Optional | Fenced, connected runs only |

The tested maintenance topology uses Syncthing to provide a complete Markdown
replica on Linux. The worker runs unprivileged, uses independent Git and
versioned backups, refuses conflicts or incomplete replication, and writes
only bounded derived output. Model-backed analysis is optional and has its own
secret, budget, and approval boundary.

Charmfile does not silently install packages, authorize peers, choose a host,
change a firewall, open a port, enable a model, or select retention policy.
Cloud discovery is read-only; deployment requires an explicit plan and
approval after local Memory is healthy.

See [Sidecar Cloud Sync](SIDECAR_CLOUD_SYNC.md) for the complete installation,
verification, fencing, offline staging, backup, and recovery contract.
