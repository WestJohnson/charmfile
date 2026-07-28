# Server Audit Checklist

Collect:

1. Hostname, OS, kernel, uptime.
2. Disk usage by mount and largest directories.
3. Memory, swap, CPU, and load average.
4. Running services and listening ports.
5. Docker containers, images, volumes, and compose projects if Docker is installed.
6. Process manager apps such as pm2, systemd services, nginx/apache sites, cron jobs.
7. Recent failed services and high-volume logs.
8. Firewall and SSH basics.
9. Backup presence if relevant.

Cleanup rule: list candidates first unless the user explicitly marked them disposable.
