Backup Setup
============

(see doku/policy.md for general idea)

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
  * Adjust all paths (replace all occurences of `nchiapol`)
  * store the passphrase you want to use for your encryption-keys in the file `/root/backup/borg-passphrase`
    (Make sure its only readable by root `chmod 400 /root/backup/borg-passphrase`)
  * plug-in backup disk and run `setup.sh`
  * plug-in second disk and run `setup.sh`
  * setup trigger for `backup_home.sh`
    a. trigger script when disks are plugged in:
       - install `helpers/90-run-backup.rules`
       - install `helpers/run-backup.service`
       (according to comments in these files)
    b. add a cronjob for root `crontab -e`
       ```
       15 21 * * * /root/backup/scripts/backup_home.sh
       ```
  * copy file `helpers/10-udisks.rules` to `/etc/polkit-1/rules.d`
    and adjust `subject.user` to match the user used when mounting in the backup scripts

KMail Backups
-------------
  * create a directory to store the mail backups (e.g. `~/.mail-backup`)
  * add subfolder `archives`
  * setup KMail's 'Archive Mail Agent'
    ```
    Path: ~/.mail-backup/archives
    Backup each: 1 Days
    Maximum number of archives: 1
    ```
  * add (user-)cronjob to run `helpers/unpack_archive.py` for each account
    a few minutes before the `backup_home.sh` cronjob



