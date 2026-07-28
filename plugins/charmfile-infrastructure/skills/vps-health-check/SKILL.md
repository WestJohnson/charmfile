---
name: vps-health-check
description: Use this skill when the user asks Codex to audit, inspect, clean up, or assess capacity on a VPS or server. Trigger for disk space, RAM, CPU, running services, Docker/container health, logs, backups, security posture, unused project cleanup, and whether a new project can be hosted. Do not use for local Codex configuration unless the user asks about servers.
---

# VPS Health Check

Use this workflow for VPS/server audits and cleanup.

## Workflow

1. Confirm target host and access method.
2. Inspect OS, uptime, disk, memory, CPU, load, and running services.
3. Identify active projects, ports, containers, cron jobs, and process managers.
4. Check logs for repeated failures.
5. Check backups, firewall, SSH posture, and package update status when in scope.
6. Separate safe cleanup from destructive removal.
7. Remove only items the user approved or clearly marked as disposable.
8. Summarize remaining capacity and hosting fit for the proposed project.

## Reference

- Read `references/server-audit-checklist.md` before performing the audit.

## Output Shape

Return:

- health summary
- resource capacity
- active services/projects
- cleanup performed or proposed
- risks
- hosting recommendation
