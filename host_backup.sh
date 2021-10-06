#!/bin/bash
# Little one to pipe commands into my usual backup script.  Good for crontab use.
~sacha/bin/win_hosts_backup.sh -b '/opt /etc /home' -n -d /mnt/backup/`hostname` \
-x /mnt/backup/`hostname`/backup.excludes | /usr/local/bin/telegram-send --stdin -g

