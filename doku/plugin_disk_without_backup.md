If the system is set up to run a backup when disks are plugged in,
you might still want to access the backup without creating to the disk
(i.e. for a single file restore or integrity check or ...)

The easiest way to achieve this is to comment the single line in
  /etc/udev/rules.d/90-run-backup.rules

(don't forget to reactivate once done :-)

