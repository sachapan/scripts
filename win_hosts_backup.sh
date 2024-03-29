#!/bin/bash
# Script to use ssh, tar and dd to backup a computer running sshd
# (I prefer cygwin sshd on windows hosts for historical reasons)
# Sacha Panasuik
# sachapan@gmail.com
# User defined variables begin here:
# Host to be backed up
HOST=crystal-aio
# Remote user to connect as
USER=cryst
# local directory to direct backup to
DIR="/mnt/backup/$HOST"
# directory to be backed up recursively
TARGET="/cygdrive/c/Users/"
# A file stored on the remote system provides the file exclusion list
EXCLUDE="/home/cryst/crystal-desktop_excludes"
# Day of the month to create the monthly backup
SPECIAL=05
# These variables are not user defined from the command line.
# Today's day of Month
DOM=`date +%d`
# Today's day of week short name
DOW=`date +%a`
# Today's full date
FULLDATE=`date +%F`
# Zero out some variables to be used later
# I'm old school and don't really trust new variables will be NULL
MONTHLY=0
MONTHLY_FLAG=0
NOSSH=0
QUIET=0
SECONDS=0
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
  echo "-------------------------------------------------------------"
}    
func_quiet_echo(){
if [ $QUIET = 0 ]
then
  echo $1
fi
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
  echo " QUIET = $QUIET"
  echo " TARGET = $TARGET"
  echo " EXCLUDE = $EXCLUDE"
  echo " BACKUP_FILE = $BACKUP_FILE"
  echo " BACKUP_LOG = $BACKUP_LOG"
  echo " MONTHLY = $MONTHLY"
  echo " TEST = $TEST"
  echo " NOSSH = $NOSSH"
  echo " QUIET = $QUIET"
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
    -q|--quiet)
      QUIET=1
      shift
    ;;
    -b|--backup)
      TARGET=$2
      func_quiet_echo "Backup target is: $TARGET"
      shift
      shift
    ;;
    -u|--user)
      USER=$2
      func_quiet_echo "Remote user is: $USER"
      shift
      shift
    ;;
    -x|--exclude)
      EXCLUDE=$2
      func_quiet_echo "EXCLUDE file is: $EXCLUDE"
      shift
      shift
    ;;
   -r|--remote)
      HOST=$2
      func_quiet_echo "Remote host is: $HOST"
      shift
      shift
    ;;
    -d|--dir)
      DIR=$2
      func_quiet_echo "Local directory target is: $DIR"
      shift
      shift
    ;;
    -m|--monthly)
      MONTHLY=1
      MONTHLY_FLAG=1
      func_quiet_echo "Monthly flag set from command line.  Otherwise the monthly backup is run on day $SPECIAL"
      shift
      ;;
    -n|--nossh)
      NOSSH=1
      HOST=`hostname -s`
      DIR="/mnt/backup/$HOST"
      shift
      ;;
    -h | --help | --usage)
      echo "This script performs remote tar backups via ssh and pulls them back to this host: `hostname`"
      echo "Usage: win_hosts_backup.sh [OPTION]"
      echo 
      echo "-b name or --backup name      Remote directory to recursively backup."
      echo "                              Default is: $TARGET."
      echo "-d name or --dir name         Set backup directory to name."
      echo "                              Default is $DIR."
      echo "-h or --help or --usage       Print this help text."
      echo "-m or --monthly               Force a monthly backup run."
      echo "-n or --nossh                 Do not connect with ssh - i.e. perform local backup."
      echo "-q or --quiet                 Minimize output text."
      echo "-r host or --remote host      The remote host to connect to."
      echo "                              Default is $HOST."
      echo "-t or --test                  Output log file prepended with 'test_' and direct "
      echo "                              output file to /dev/null"
      echo "-u name or --user name        Set user to name.  This is the remote ssh user."
      echo "                              Default is: $USER."
      echo "-x file or --exclude file     Filename that contains the exclusions."
      echo "                              Default is $EXCLUDE."
      echo "-v or --verbose               Increase verbosity level."
      echo
      echo "With no command line parameters entered: just run the backup job with default parameters."
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
echo "Beginning backup run for $HOST."
if [ $QUIET = 0 ]
then
  date
  func_separator
fi
if [ $MONTHLY = 1 ]
then
  if [ $MONTHLY_FLAG = 1 ]
  then
    echo "Monthly backup has been forced with -m flag."
  fi
  echo "Today is a special backup day: performing monthly."
  FILE=backup_$HOST-$FULLDATE
else
  func_quiet_echo "Today is a regular backup day: performing daily."
  FILE=backup_$HOST-$DOW
fi
BACKUP_FILE=$DIR/$FILE.tar
BACKUP_LOG=$DIR/$FILE.log
if [ $TEST = 1 ]
then 
  BACKUP_FILE=/dev/null
  BACKUP_LOG=$DIR/test_$FILE.log
fi
if [ ! -d $DIR ];
then 
    mkdir $DIR
fi
func_quiet_echo "Backup will be stored at $BACKUP_FILE"
func_quiet_echo "Backup log will be stored at $BACKUP_LOG"
if [ QUIET = 0 ]
  then
    dd_cmd="dd of=$BACKUP_FILE"
  else
    dd_cmd="dd status=none of=$BACKUP_FILE"
fi
if [ $NOSSH = 0 ]
  then
#    func_var_dump
  func_quiet_echo "Attempting to connect to $HOST as $USER."
  ssh -q $USER@$HOST "exit"
  if [ $? == 0 ]
    then
       func_quiet_echo "Connection successful."
       echo "Performing Backup."
       ssh -q $USER@$HOST "tar cvf - -X $EXCLUDE $TARGET" 2>$BACKUP_LOG | $dd_cmd
    else
       echo "Connection failed."
       exit 1
    fi
  else
  func_quiet_echo "Ok, the nossh option means local backup has been enabled."
  tar cvf - -X $EXCLUDE $TARGET 2>$BACKUP_LOG | $dd_cmd
fi
SIZE=`du -hs $BACKUP_FILE | awk '{print $1}'`
echo "Backup File size: $SIZE"
if [ $VERBOSE = 1 ]
then
  cat $BACKUP_LOG
fi
func_quiet_echo "The backup for today is concluded."
#date
duration=$SECONDS
if [ $(($duration / 60)) = 0 ]
  then
    echo "$(($duration % 60)) seconds to complete."
  else
    echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds to complete."
fi
func_quiet_echo "Thank you for your cooperation."
exit 0
