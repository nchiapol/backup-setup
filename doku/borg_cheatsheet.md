Borg Cheat-Sheet
----------------
  - list available generations (archives)
      ```
      borg list <repo path>
      ```

  - verify last generation
      ```
      mkdir ~/tmp/verify
      cd ~/tmp/verfiy
      borg list <last archive> | shuf -n 100 | grep -o "home/.*" | xargs borg extract <last archive>
      diff -rs home/nchiapol/ ~/ | grep -e 'identical$' | wc -l
      ```

  - check consistency of archive
      ```
      borg check <repo path>::<archive>
      ```
    and full repo
      ```
      borg check <repo path>
      ```

  - exercise restore
      ```
      mkdir <restore-dir>
      cd <restore-dir>
      borg extract <archive> <path/to/restore>  #NOTE: no / at the start of restore-path
      ```
    then compare
      ```
      diff -r /full/path/to/restore/ <restore-dir>/path/to/restore/
      ```

  - mount and browse repository  
    mount
      ```
      borg mount <archive> ~/tmp/mount
      ```
    then browse, finally unmount
      ```
      borg umount ~/tmp/mount/
      ```

  - check available diskspace
      ```
      du -hs
      df -h
      ```

  - forget unneeded generations  
    test:
      ```
      borg prune -v --list -d 10 -w 52 --dry-run <repo-path>
      ```
    run:
      ```
      borg prune -d 10 -w 52 <repo-path>
      ```
