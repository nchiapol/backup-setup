#!/usr/bin/bash
#
# get the relevant log-lines for todays backup and mail them to my user
# (don't forget to adjust the recipient name)
#
# (this script is part of the udev triggered backup setup
# together with 90-run-backup.rules and run-backup.service)

journalctl -S "today" -u run-backup.service -o cat | rg "This archive" -A 4 -B 12 | mail -s "Today's backup" nchiapol

# otherwise systemd kills the process before exim can deliver the mail queued above...
# see: https://serverfault.com/questions/982318/mail-stuck-in-exim-queue-for-no-reason
exim -qf
