#!/bin/sh
ssh cryst@crystal-desktop "tar cvf /cygdrive/d/custom_backups/users_backup_`date +%F`.tar \
	--exclude="*/AppData" \
	--exclude="*/Downloads" \
	--exclude="Google Drive" \
	/cygdrive/c/Users"
