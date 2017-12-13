#!/bin/bash

cd /dev/disk/by-label/ || exit
for label in *
do
    if [ "${label:0:6}" == "backup" ]
    then
        udisksctl mount --block-device "/dev/disk/by-label/$label" --no-user-interaction
        export BORG_KEY_FILE="/root/backup/keys/$label"
        export BORG_PASSCOMMAND="cat /root/backup/borg-passphrase"
        borg init -e keyfile "/media/root/$label/nchiapol-borg"
        udisksctl unmount -b "/dev/disk/by-label/$label"
        break
    fi
done
