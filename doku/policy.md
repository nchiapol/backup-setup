Policy
======
  * external disk is connected by usb but not mounted
  * main backups are run daily
    (/root/backup/scripts/backup_home.sh)
    - run as root user
      - originally: from cron-job at 21:00 (if a backup-disk is available)
      - since 2025: when backup-disk is plugged in
    - backing up /home/nchiapol
  * backup disk is exchanged once every month
    - before doing so additional backups are run from a script with user
      interaction (/root/backup/scripts/backup_disk-switch.sh):
      - Backup: /etc, /root and further slow changing directories
      - prune unneeded generations
      - sync archive using git-annex
  * 'borg check' is run manually every n-month, as this needs a LOT of time

