#!/bin/bash

# create_package_list.sh -- write a list of manually installed packages
#
# This script writes a list of manually installed debian
# packages to a file for backup. Such a file can then be used to
# quickly set up a new system if needed.
#
# Author: Nicola Chiapolini, 2019
#
# Licence: Public Domain (I don't think this is copyrightable anyway.)

target_file="/home/nchiapol/dokumente/computer/admin/${HOSTNAME}_package_list.txt"
echo "writing list of manually installed pacakges to $target_file"
aptitude search "~i ?not(~M)" > "$target_file"

