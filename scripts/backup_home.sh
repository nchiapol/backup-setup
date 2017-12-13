#!/bin/bash

# backup_home.sh -- run daily backup of home
#
# Copyright 2017, Nicola Chiapolini
#
# License: GNU General Public License version 3,
#          or (at your option) any later version.

cd /dev/disk/by-label/ || exit
for label in *
do
    if [ "${label:0:6}" == "backup" ]
    then
        udisksctl mount --block-device "/dev/disk/by-label/$label" --no-user-interaction
        export BORG_RELOCATED_REPO_ACCESS_IS_OK='yes'
        export BORG_KEY_FILE="/root/backup/keys/$label"
        export BORG_PASSCOMMAND="cat /root/backup/borg-passphrase"
        borg create -v --stats "/media/root/$label/nchiapol-borg::home_{now:%Y-%m-%d}" /home/nchiapol/ \
            --exclude-from /root/backup/exclude/borg-home_exclude.conf \
            --exclude-caches \
            --one-file-system \
            --compression lz4
        udisksctl unmount -b "/dev/disk/by-label/$label"
        break
    fi
done
