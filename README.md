Backup Setup
============

Preparation
-----------
  * buy two large external USB harddrives
  * format each drive (I use `ext4`)
  * set label to `backupN`, where N is the number of the disk.  
    e.g.:
    ```
    sudo e2label /dev/sdx1 backup1  # replace sdx1 by correct value
    ```

Initial Setup (as root)
-----------------------
(The scripts are tested with Debian "Buster" and borg 1.1.4)
  * checkout this repo to `/root/backup`
  * Adjust all pathes (replace all occurences of `nchiapol`)
  * store the passphrase you want to use for your encryption-keys in the file `/root/backup/borg-passphrase`  
    (Make sure its only readable by root `chmod 400 /root/backup/borg-passphrase`)
  * plug-in backup disk and run `setup.sh`
  * plug-in second disk and run `setup.sh`
  * add a cronjob for root `crontab -e`
    ```
    15 21 * * * /root/backup/scripts/backup_home.sh
    ```

