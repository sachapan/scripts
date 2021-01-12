#!/bin/sh
HOST=crystal-desktop
USER=cryst
DIR="/mnt/backup/crystal-desktop"
# Day of the month to create the monthly backup
SPECIAL=12
DOM=`date +%d`
DOW=`date +%a`
FULLDATE=`date +%F`
echo "Beginning backup run for $HOST."
if [ $DOM = $SPECIAL ]
then
    echo "Today is a special backup day."
    FILE=backup_$HOST-$FULLDATE
else
    echo "Today is a regular backup day."
    FILE=backup_$HOST-$DOW
fi
echo "backup will be stored at $DIR/$FILE.tar"
echo "backup log will be stored at $DIR/$FILE.log"
echo "Attempting to connect to $HOST as $USER."
ssh $USER@$HOST "tar cvf - \
    --exclude=*/NTUSER* \
    --exclude=*/AppData \
    --exclude=*/Downloads \
    --exclude=*/Google\ Drive \
    --exclude=*/OneDrive/backups \
    --exclude=*/Music \
	--exclude=*/Videos \
    /cygdrive/c/Users/" \
    2>$DIR/$FILE.log \
    | dd of=$DIR/$FILE.tar
ls -l $DIR/$FILE.*
echo "The backup for today is concluded."

#    2>/mnt/Archive\ TV/backup/crystal-desktop/backup_crystal-desktop.log \
#    | dd of=/mnt/Archive\ TV/backup/crystal-desktop/crystal-desktop_`date +%a`.tar
