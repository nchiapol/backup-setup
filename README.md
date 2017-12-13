Backup Setup
============

Preparation
-----------
  * buy two large external USB harddrives
  * format each drive with ext4
  * set label to `backupN`, where N is the number of the disk.  
    e.g.:
    ```
    sudo e2label /dev/sdx1 backup1  # replace sdx1 by correct value
    ```

Initial Setup (as root)
-----------------------
  * checkout this repo to `/root/backup`
  * plug-in backup disk and run `setup.sh`
  * plug-in second disk an run `setup.sh`, use same passphrase for key
  * store the passphrase in the file `/root/backup/borg-passphrase`  
    (Make sure its only readable by root `chmod 400 /root/backup/borg-passphrase`)
  * add a cronjob for root `crontab -e`
    ```
    15 21 * * * /root/backup/scripts/backup_home.sh
    ```

