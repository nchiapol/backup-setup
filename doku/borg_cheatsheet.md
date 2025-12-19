Borg Cheat-Sheet
----------------
  - print overview info
      ```
      borg info <repo path>
      ```

  - list available generations (archives)
      ```
      borg list <repo path>
      ```

  - verify last generation
    a) use helper-script: `random_check.sh`
    b) manually run:
       ```
       mkdir ~/tmp/verify
       cd ~/tmp/verify
       borg list <last archive> --format {mode}+{path}{NL} | grep -v '^d' | grep -o "home/.*" | shuf -n 100 | xargs -d '\n' borg extract <last archive>
       diff -rs ~/tmp/verify/home/nchiapol/ ~/ | grep -e 'identical$' | wc -l
       ```
       (should return number in `shuf -n`)

  - check consistency of archive
      ```
      borg check -v --progress <repo path>::<archive>
      ```
    and full repo
      ```
      borg check -v --progress <repo path>
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
      borg prune --progress -d 10 -w 52 <repo-path>
      ```

  - free disk space (`prune` alone is not enough)
    ```
    borg compact <repo-path>
    ```

