#!/bin/sh
ssh cryst@crystal-desktop "tar cvf /cygdrive/d/custom_backups/users_backup_`date +%F`.tar \
	-X /home/cryst/crystal-desktop_excludes /cygdrive/c/Users"
#	--exclude="*/AppData" \
#	--exclude="*/Downloads" \
#	--exclude="Google Drive" \
