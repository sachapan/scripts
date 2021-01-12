#!/bin/sh
#ssh sacha@slave2 "tar cvf - \
#    --exclude=AppData \
#    --exclude=OneDrive \
#    --exclude='Google\ Drive' \
#    --exclude='.vagrant.d' \
#    --exclude=.dotfiles.git \
#    --exclude=.oh-my-zsh \
#    --exclude=tmp \
#    --exclude=Videos \
#    --exclude='_.*' \
#    --exclude='NTUSER.DAT' \
#    ." \
#    2>/mnt/Archive\ TV/backup/slave2/backup_slave2_test.log \
#    | dd of=/mnt/Archive\ TV/backup/slave2/slave2_`date +%a`.tar

ssh cryst@crystal-desktop "tar cvf - \
    --exclude=*/NTUSER* \
    --exclude=*/AppData \
    --exclude=*/Downloads \
    --exclude=*/Google\ Drive \
    --exclude=*/OneDrive/backups \
    --exclude=*/Music \
	--exclude=*/Videos \
    /cygdrive/c/Users/" \
    2>/mnt/Archive\ TV/backup/crystal-desktop/backup_crystal-desktop.log \
    | dd of=/mnt/Archive\ TV/backup/crystal-desktop/crystal-desktop_`date +%a`.tar

