#!/bin/sh
# Script to use ssh, tar and dd to backup a windows computer running sshd
# (I prefer cygwin sshd for historical reasons)
# Sacha Panasuik
# sachapan@gmail.com
# User defined variables begin here:
# Host to be backed up
HOST=crystal-desktop
# Remote user to connect as
USER=cryst
# local directory to direct backup to
DIR="/mnt/backup/crystal-desktop"
# directory to be backed up recursively
TARGET="/cygdrive/c/Users/"
# A file stored on the remote system provides the file exclusion list
EXCLUDE="/home/cryst/crystal-desktop_excludes"
# Day of the month to create the monthly backup
SPECIAL=05
# These variables are not user defined.
# Today's day of Month
DOM=`date +%d`
# Today's day of week short name
DOW=`date +%a`
# Today's full date
FULLDATE=`date +%F`
# Zero out some variables to be used later
# I'm old school and don't really on new variables being NULL
MONTHLY=0
MONTHLY_FLAG=0
NOSSH=0
TEST=0
VERBOSE=0
# program logic begins here
# Determine if today is a monthly backup day
if [ $DOM = $SPECIAL ]
then
  MONTHLY=1
fi
func_separator(){
  # this function simply prints a pretty (or ugly) line
  echo "-------------------------------------------------------------------------------------------"
}    
func_var_dump(){
# this function is for debugging purposes.  It dumps internal variables and then exits the script.
  func_separator
  echo "func_var_dump was called - that can't be good."
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
  echo " VERBOSE = $VERBOSE"
  exit 1
}
# Main program logic begins here
# Check for parameters entered on command line
for arg in "$@"
do
  case "$arg" in
    -t|--test)
      TEST=1
      shift
    ;;
    -m|--monthly)
      MONTHLY=1
      MONTHLY_FLAG=1
      shift
      ;;
    -n|--nossh)
      NOSSH=1
      shift
      ;;
    -h | --help | --usage)
      echo "This script performs remote tar backups via ssh and pulls them back to this host: `hostname`"
      echo "Usage: win_hosts_backup.sh [OPTION]"
      echo 
      echo "-h or --help or --usage       Print this help text."
      echo "-m or --monthly               Force a monthly backup run."
      echo "-n or --nossh                 Do not connect with ssh - useful for testing only."
      echo "-t or --test                  Output files prepended with 'test_'"
      echo "-v or --verbose               Increase verbosity level."
      echo
      echo "With no command line parameters entered: just run the backup job."
      exit 0
      shift
      ;;
    -v | --verbose)
      VERBOSE=1
      func_separator
      echo "Verbosity level up."
      echo "Received command line parameters: $@"
      func_separator
      shift
      ;;
  esac
done
date
echo "Beginning backup run for $HOST."
func_separator
if [ $MONTHLY = 1 ]
then
  if [ $MONTHLY_FLAG = 1 ]
  then
    echo "Monthly backup has been forced with -m flag."
  fi
  echo "Today is a special backup day: performing monthly."
  FILE=backup_$HOST-$FULLDATE
else
  echo "Today is a regular backup day: performing daily."
  FILE=backup_$HOST-$DOW
fi
BACKUP_FILE=$DIR/$FILE.tar
BACKUP_LOG=$DIR/$FILE.log
if [ $TEST = 1 ]
then 
  BACKUP_FILE=/dev/null
  BACKUP_LOG=$DIR/test_$FILE.log
fi
echo "Backup will be stored at $BACKUP_FILE"
echo "Backup log will be stored at $BACKUP_LOG"
if [ $NOSSH = 0 ]
then
#    func_var_dump
  echo "Attempting to connect to $HOST as $USER."
  func_separator
  ssh $USER@$HOST "tar cvf - -X $EXCLUDE $TARGET" 2>$BACKUP_LOG | dd of=$BACKUP_FILE
  date
  SIZE=`du -hs $BACKUP_FILE | awk '{print $1}'`
  echo "Backup File size: $SIZE"
  if [ $VERBOSE = 1 ]
  then
      cat $BACKUP_LOG
  fi
else
  func_separator
  echo "Ok, with the nossh option this is where we part company."
fi
echo
echo "The backup for today is concluded."
echo "Thank you for your cooperation."
exit 0
