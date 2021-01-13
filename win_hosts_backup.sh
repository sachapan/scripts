#!/bin/sh
# Script to use ssh, tar and dd to backup a windows computer running sshd
# Sacha Panasuik
# sachapan@gmail.com
HOST=crystal-desktop
USER=cryst
DIR="/mnt/backup/crystal-desktop"
# Day of the month to create the monthly backup
SPECIAL=05
DOM=`date +%d`
DOW=`date +%a`
FULLDATE=`date +%F`
# Check for parameters
#whole getopts t: flag
echo "received command line parameters: $@"
for arg in "$@"
do
    case "{$arg}" in
#        -t) OUTPUT=${OPTARG};;
        -t|--test)
        TEST=1
        shift
# Add -m parameter to force monthly backup run
    esac
done
date
#if $TEST 
#then
#    echo "This is just a test."
#    exit 1
#fi
echo "Beginning backup run for $HOST."
if [ $DOM = $SPECIAL ]
then
    echo "Today is a special backup day."
    FILE=backup_$HOST-$FULLDATE
else
    echo "Today is a regular backup day."
    FILE=backup_$HOST-$DOW
fi
BACKUP_FILE=$DIR/$FILE.tar
BACKUP_LOG=$DIR/$FILE.log
if $TEST
then 
    BACKUP_FILE=/dev/null
    BACKUP_LOG=$DIR/test_$FILE.log
fi
    echo "Backup will be stored at $BACKUP_FILE"
    echo "Backup log will be stored at $BACKUP_LOG"
    echo "Attempting to connect to $HOST as $USER."
    ssh $USER@$HOST "tar cvf - \
     --exclude=*/NTUSER* \
     --exclude=*/AppData \
     --exclude=*/Downloads \
     --exclude=*/Google\ Drive \
     --exclude=*/MicrosoftEdgeBackups \
     --exclude=*/OneDrive/backups \
     --exclude=*/Music \
     --exclude=*/Videos \
     /cygdrive/c/Users/" \
     2>$BACKUP_LOG \
     | dd of=$BACKUP_FILE
    date
#    ls -l $DIR/$FILE.*
    echo
    echo "The backup for today is concluded."
    echo "Thank you for your cooperation."
exit 0
#    2>/mnt/Archive\ TV/backup/crystal-desktop/backup_crystal-desktop.log \
#    | dd of=/mnt/Archive\ TV/backup/crystal-desktop/crystal-desktop_`date +%a`.tar
