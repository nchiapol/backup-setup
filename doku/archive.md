Archive
=======

For archiving I use the folder `~/archive`.
The archive is managed by git-annex and does not need regular backups.
The goal of this setup is to keep old data but still free diskspace on
  the laptop.
In addition it should be easy to check if something is in the archive
  and get it back if it is.

Setup git-annex
---------------
```
cd ~/archive/annex
git init
git annex init
git annex add *
git commit -m "initial commit"
git annex numcopies 2
git annex required . "include=*.txt"

cd /media/nchiapol/backup2/
sudo mkdir nchiapol-annex
sudo chown nchiapol:nchiapol nchiapol-annex/
cd nchiapol-annex/
git clone ~/archive/annex

cd ~/archive/annex
git remote add backup2 /media/nchiapol/backup2/nchiapol-annex/annex/
git annex groupwanted backuparchive "not (copies=backuparchive:2)"
git annex group backup2 backuparchive
git annex wanted backup2 groupwanted
git annex trust backup2
git annex describe backup2 "external USB drive"
```

Archiving
---------
To archive a directory, I use the shell-function below to create
  - a `tar.gz` of the directory
  - a `_contet.txt` with a list of its content
Both files added to the archive repository with `git annex add ...`

```
function archive_dir {
  for f in "$@"
  do
    dir="${f%/}"
    echo "archiving $dir"
    echo "$(date -Iseconds)" > "$dir/$(date --iso)_archive-timestamp.txt"
    tree "$dir" > "${dir}_content.txt"
    tar -pczf "$dir.tar.gz" "$dir"
  done
}
```

Commands
--------
  * update backup disk
```
git annex sync --content
git annex drop --auto
```

  * check files
```
git annex list
```

  * retrieve data
```
git annex get <file>
```

