#!/bin/bash

# backup_home.sh -- run daily backup of home
#
# Copyright 2017-2021, Nicola Chiapolini
#
# License: GNU General Public License version 3,
#          or (at your option) any later version.
set -o errexit

cd /dev/disk/by-label/ || exit
for label in *
do
    if [ "${label:0:6}" == "backup" ]
    then
        sudo -u nchiapol udisksctl mount --block-device "/dev/disk/by-label/$label" --no-user-interaction || was_mounted="true"
        export BORG_RELOCATED_REPO_ACCESS_IS_OK='yes'
        export BORG_KEY_FILE="/root/backup/keys/$label"
        export BORG_PASSCOMMAND="cat /root/backup/borg-passphrase"
        borg create -v --stats "/media/nchiapol/$label/nchiapol-borg::home_{now:%Y-%m-%d}" /home/nchiapol/ \
            --exclude-from /root/backup/exclude/borg-home_exclude.conf \
            --exclude-caches \
            --one-file-system \
            --compression lz4 || true
        if [ "$was_mounted" != "true" ]
        then
            udisksctl unmount -b "/dev/disk/by-label/$label"
            /usr/sbin/hdparm -y "/dev/disk/by-label/$label"
        else
            echo "not unmounting, disk was mounted already"
        fi
        break
    fi
done
