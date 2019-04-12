#!/bin/bash

# backup_disk-switch.sh -- perpare switching of backup disks
#
# Copyright 2017-2019 Nicola Chiapolini
#
# License: GNU General Public License version 3,
#          or (at your option) any later version.

for label in /dev/disk/by-label/*
do
    diskname=$(basename "$label")
    echo "$diskname"
    if [ "${diskname:0:6}" == "backup" ] 
    then
        export BORG_RELOCATED_REPO_ACCESS_IS_OK='yes'
        export BORG_KEY_FILE="/root/backup/keys/$diskname"
        export BORG_PASSCOMMAND="cat /root/backup/borg-passphrase"
        echo "backup disk found, mounting $diskname"
        sudo -u nchiapol udisksctl mount --block-device "/dev/disk/by-label/$diskname" --no-user-interaction
        echo "running system-backup"
        borg create -vp --stats "/media/nchiapol/$diskname/nchiapol-borg::system_{now:%Y-%m-%d}" /etc /root /var/spool/cron/crontabs \
            --exclude-caches \
            --one-file-system \
            --compression lz4
	echo "updating archives"
	sudo -u nchiapol ../helpers/annex_update.sh
	echo "pruning"
        borg prune -m 12  "/media/nchiapol/$diskname/nchiapol-borg" --prefix "system_"
        borg prune -d 30 -w 52 "/media/nchiapol/$diskname/nchiapol-borg" --prefix "home_"
        #echo "running fsck"
        #borg check "/media/root/$diskname/nchiapol-borg"
        echo "unmounting backup disk"
        udisksctl unmount -b "/dev/disk/by-label/$diskname"
        break
    fi
done
