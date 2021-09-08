#!/bin/sh
# testing the migration of the backup function directly to deathstar instead of pulling the entire backup through hawk
# September 8, 2021

ssh admin@deathstar "~/win_hosts_backup.sh -b /cygdrive/c/Users/cryst -v -d ~/backup/crystal-desktop"
