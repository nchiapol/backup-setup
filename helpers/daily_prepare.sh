#!/bin/bash
/home/nchiapol/code/backup-setup/helpers/create_package_list.sh
python3 /home/nchiapol/code/backup-setup/helpers/unpack_archive.py bluewin
python3 /home/nchiapol/code/backup-setup/helpers/unpack_archive.py wichtig
