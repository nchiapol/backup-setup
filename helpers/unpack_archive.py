# coding: utf-8
""" unpack KMail Archives

KMail fails to properly sync mails to the file system.
To ensure proper backups we therefore archive relevant
accounts daily with KMails Archive Agent.
To avoid backing up constantly chaning archive files, we
then unpack the archives and backup the resulting maildir.

Copyright 2019, Nicola Chiapolini

License: GNU General Public License version 3,
         or (at your option) any later version.
"""
# pylint: disable=invalid-name
import os
import sys
import glob
import libarchive

BASE_PATH = "/home/nchiapol/.mail-backup/"

try:
    account = sys.argv[1]
except IndexError:
    print("Usage:\n  unpack_archive.py <account>")
    sys.exit(1)

archive = glob.glob(os.path.join(BASE_PATH, f"archives/Archive_{account}_*"))[0]

# check if archive has been unpacked already
date_file = os.path.join(BASE_PATH, f"date_{account}")
try:
    with open(date_file, "r") as f:
        old_date = f.readline().strip()
except FileNotFoundError:
    old_date = "0000-00-00"
new_date = archive.split("_")[-1].split(".")[0]
if not old_date < new_date:
    print(f"No new archive found for {account}")
    sys.exit(0)

target_dir = os.path.join(BASE_PATH, f"unpacked_{account}")
try:
    os.chdir(target_dir)
except FileNotFoundError:
    os.mkdir(target_dir)
    os.chdir(target_dir)
print(f"unpacking: {archive} to {target_dir}")
libarchive.extract_file(archive)

with open(date_file, "w") as f:
    f.write(new_date + "\n")
