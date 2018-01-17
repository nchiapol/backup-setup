Policy
======
  * external disk is connected to docking-station but not mounted
  * main backups are run daily
    (/root/backup/scripts/backup_home.sh)
    - run as root user, from cron-job at 21:00
    - only if a backup-disk is availabel
    - backing up /home/nchiapol
  * backup disk is exchanged once every month
    - before doing so additional backups are run from a script with user
      interaction (/root/backup/scripts/backup_disk-switch.sh):
      - Backup
        - /etc and /root
        - /media/nchiapol/archive
      - prune unneeded generations
  * 'borg check' is run manually every n-month, as this needs a LOT of time


Troubleshooting
---------------
```bash
Error creating textual authentication agent: Error opening current controlling terminal for the process (`/dev/tty'): No such device or address (polkit-error-quark, 0)
Error mounting /dev/sdc1: GDBus.Error:org.freedesktop.UDisks2.Error.NotAuthorizedCanObtain: Not authorized to perform operation
```

This seems to be caused by missing rights for polkit. To investigate compare the output of
```bash
for act in $(pkaction); do echo "  - $act" ; pkcheck --action-id $act --process $$; done
```
when run from the terminal and from a cron job.

Solved - See doku/helpers/10-udisks.pkla
