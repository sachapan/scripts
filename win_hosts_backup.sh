#!/bin/sh
ssh sacha@slave2 "tar cvf - \
    --exclude=AppData \
    --exclude=OneDrive \
    --exclude='Google Drive' \
    --exclude='.vagrant.d' \
    --exclude=.dotfiles.git \
    --exclude=.oh-my-zsh \
    --exclude=tmp \
    --exclude=Videos \
    --exclude='_.*' \
    --exclude='NTUSER.DAT' \
    ." \
    2>/mnt/Archive\ TV/backup/slave2/backup_slave2_test.log \
    | dd of=/mnt/Archive\ TV/backup/slave2/user_sacha_test.tar

