#!/bin/bash

cd /dev/disk/by-label/ || exit
for label in *
do
    echo "$label"
    if [ "${label:0:6}" == "backup" ] 
    then
        export BORG_RELOCATED_REPO_ACCESS_IS_OK='yes'
        export BORG_KEY_FILE="/root/backup/keys/$label"
        export BORG_PASSCOMMAND="cat /root/backup/borg-passphrase"
        echo "backup disk found, mounting $label"
        udisksctl mount --block-device "/dev/disk/by-label/$label" --no-user-interaction
        udisksctl mount --block-device /dev/disk/by-label/archiv
        echo "running system-backup"
        borg create -vp --stats "/media/root/$label/nchiapol-borg::system_{now:%Y-%m-%d}" /etc /root \
            --exclude-caches \
            --one-file-system \
            --compression lz4
        borg prune -m 12  "/media/root/$label/nchiapol-borg" --prefix "system_"
        echo "running backup of archiv"
        borg create -vp --stats "/media/root/$label/nchiapol-borg::archiv_{now:%Y-%m-%d}" /media/root/archiv \
            --exclude-from /root/backup/exclude/borg-archiv_exclude.conf \
            --exclude-caches \
            --one-file-system \
            --compression lz4
        udisksctl unmount -b /dev/disk/by-label/archiv
        borg prune -m 12  "/media/root/$label/nchiapol-borg" --prefix "archiv_"
        borg prune -d 30 -m 52 "/media/root/$label/nchiapol-borg" --prefix "home_"
        #echo "running fsck"
        #borg check "/media/root/$label/nchiapol-borg"
        echo "unmounting"
        udisksctl unmount -b "/dev/disk/by-label/$label"
        break
    fi
done
