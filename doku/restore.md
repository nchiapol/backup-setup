Restore to New System
=====================

Preparations
------------
  1) install and update new system
  2) install aptitude and vim `sudo apt install aptitude vim`
  3) install borg `sudo aptitude install borgbackup`
  4) prepare config
     - download backup-setup from github to root-home folder
     - add keys to keys folder (according to readme)

Restore
-------
  1) mount backup disk check Repo
  2) restore to var (restor last home and last system backup)
     ```
     sudo -i
     cd /var/
     borg extract <repo>::<archive>
     ```
  3) logout of gui and login to terminal ([ctrl]+[alt]+[f1])
  4) replace home dir
     ```
     mv /home/nchiapol /var/backup/nchiapol_orig
     mv /var/home/nchiapol /home/nchiapol
     ```
  5) replace /etc  [UNTESTED]
     ```
     mv /etc /var/backup/etc
     mv /var/etc /etc
     ```
  6) repeat for other dirs from system-backup
  7) reboot


Installing Needed Packages
--------------------------
  1) compare lists of installed packages
```
cp /home/nchiapol/dokumente/computer/admin/OLDHOSTNAME_package_list.txt old.txt # old list from backup
aptitude search "~i" > new.txt
diff old.txt new.txt | grep "^<" > diff.txt
```
  2) manually edit the list of packages, removing all packages we don't need anymore
  3) `cat to_install.txt | cut -d " " -f 2 | xargs -o sudo aptitude install` to install


Further Fixes
-------------
  - install citrix manually
  - install custom keyboard layouts (see /home/nchiapol/dokumente/computer/sys-files/keyboard/)
  - `sudo dpkg-reconfigure locale` if warnings about locale
  - create new addressbook in kaddressbook and import vcards from backup
  - update mac-address in all WLAN config files `sed -i -e 's/<old mac>/<new mac>/' *`
  - further notes: `~/dokumente/computer/doc-notizen/restore-2019_log.txt`
