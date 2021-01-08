#!/bin/bash
# Sacha Panasuik
# sachapan@gmail.com
# script to make a backup copy of the userdata directories and files
# from a libreelec installation
# the current backup and the previous backup are kept
# assumes ssh key exchange has been completed.

# variables
# backupdir is where to store the....wait for it.....backups
backupdir=/var/backups/kodi
# kodihosts is the list of hosts to backup
kodihosts=("fpkodi" "theater")

# loop through the hosts
for host in ${kodihosts[@]};
do
    echo "Beginning run for $host"
    echo "Test for old backup at: $backupdir/"${host}_userdata.tar.""
#    read -p "Press any key to continue..... " -n1 -s
    if [ -e $backupdir/"${host}_userdata.tar" ]
    then
        echo
        echo "Found old backup for $host, moving it now."
        read -p "Press any key to continue........" -n1 -s
        mv $backupdir/"${host}_userdata.tar" $backupdir/"${host}_userdata_old.tar"
    fi
    echo
    echo "Beginning ssh backup for $host"
#    read -p "Press any key to continue..... " -n1 -s
   ssh root@$host "tar cvf - /storage/.kodi/userdata" | dd of=$backupdir/"${host}_userdata.tar"
    echo "tar backup completed for $host"
#    read -p "Press any key to continue..... " -n1 -s
done

