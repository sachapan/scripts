#!/bin/sh
#ssh cryst@crystal-desktop "tar cvzf /cygdrive/d/custom_backups/users_backup_`date +%F`.tgz \
ssh cryst@crystal-desktop "tar cvzf /cygdrive/d/custom_backups/users_backup_`date +%a`.tgz \
	-X /home/cryst/crystal-desktop_excludes /cygdrive/c/Users"
