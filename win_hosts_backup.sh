#!/bin/sh
# Script to use ssh, tar and dd to backup a windows computer running sshd
# Sacha Panasuik
# sachapan@gmail.com
HOST=crystal-desktop
USER=cryst
DIR="/mnt/backup/crystal-desktop"
TARGET="/cygdrive/c/Users/"
EXCLUDE="/home/cryst/crystal-desktop_excludes"
NOSSH=0
# Day of the month to create the monthly backup
SPECIAL=05
DOM=`date +%d`
DOW=`date +%a`
FULLDATE=`date +%F`
MONTHLY=0
if [ $DOM = $SPECIAL ]
then
    MONTHLY=1
fi
var_dump(){
    echo "var_dump was called."
    echo "variables:"
    echo " HOST = $HOST"
    echo " USER = $USER"
    echo " DOM = $DOM"
    echo " DOW = $DOW"
    echo " FULLDATE = $FULLDATE"
    echo " SPECIAL = $SPECIAL"
    echo " DIR = $DIR"
    echo " TARGET = $TARGET"
    echo " EXCLUDE = $EXCLUDE"
    echo " BACKUP_FILE = $BACKUP_FILE"
    echo " BACKUP_LOG = $BACKUP_LOG"
    echo " MONTHLY = $MONTHLY"
    echo " TEST = $TEST"
    echo " NOSSH = $NOSSH"
    exit 1
}
# Check for parameters
#whole getopts t: flag
echo "received command line parameters: $@"
for arg in "$@"
do
    case "$arg" in
#        -t) OUTPUT=${OPTARG};;
        -t|--test)
        TEST=1
        shift
        ;;
        -m|--monthly)
        MONTHLY=1
        shift
        ;;
        -n|--nossh)
        NOSSH=1
        shift
        ;;
    esac
done
date
#if $TEST 
#then
#    echo "This is just a test."
#    exit 1
#fi
echo "Beginning backup run for $HOST."
if [ $MONTHLY = 1 ]
then
    echo "Today is a special backup day: performing monthly."
    FILE=backup_$HOST-$FULLDATE
else
    echo "Today is a regular backup day."
    FILE=backup_$HOST-$DOW
fi
BACKUP_FILE=$DIR/$FILE.tar
BACKUP_LOG=$DIR/$FILE.log
if [ $TEST = 1 ];
then 
    BACKUP_FILE=/dev/null
    BACKUP_LOG=$DIR/test_$FILE.log
fi
    echo "Backup will be stored at $BACKUP_FILE"
    echo "Backup log will be stored at $BACKUP_LOG"
    echo "Attempting to connect to $HOST as $USER."
if [ $NOSSH = 0 ]
then
    echo "we fell into the NOSSH=0 condition."
    echo "MONTHLY=$MONTHLY"
    var_dump
#    ssh $USER@$HOST "tar cvf - -X $EXCLUDE $TARGET" 2>$BACKUP_LOG | dd of=$BACKUP_FILE
    date
else
    echo "Ok, with the nossh option, this is where we end."
    var_dump
fi
#    ls -l $DIR/$FILE.*
    echo
    echo "The backup for today is concluded."
    echo "Thank you for your cooperation."
exit 0
#    2>/mnt/Archive\ TV/backup/crystal-desktop/backup_crystal-desktop.log \
#    | dd of=/mnt/Archive\ TV/backup/crystal-desktop/crystal-desktop_`date +%a`.tar
