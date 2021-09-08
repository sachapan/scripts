#!/bin/bash
# testing the migration of the backup function directly to deathstar instead of pulling the entire backup through hawk
# September 8, 2021
if ! ssh admin@deathstar "~/win_hosts_backup.sh -b /cygdrive/c/Users/cryst -d ~/backup/crystal-desktop -u cryst -v"
then
  echo "SSH connection failed!"
fi
