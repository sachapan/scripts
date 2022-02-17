#!/usr/bin/env python3
# A python version of the /bin/sh script win_hosts_backup.sh
# Purpose: perform backups via ssh, tar and dd from a remote host to the local host
#
# Sacha Panasuik
# Initial script creation: January 14, 2021
# imports
import sys
import os
import argparse
import json
from datetime import datetime


def main():
    monthly = False
    verbose_level = False
    day_of_month = datetime.today().strftime('%d')
    day_of_week = datetime.today().strftime('%a')
    full_date = datetime.today().strftime('%F')
    # test_run = False
    parser = argparse.ArgumentParser()
    parser.add_argument('--save_json',
                        help='Save settings to file in json format.  Only save, do not run.')
    parser.add_argument('-b', '--backupdir', type=str, nargs="+", required=False,
                        help='Directory/ies to backup.')
    parser.add_argument('--load_json',
                        help='Load settings from file in json format. Command line options override loaded values.')
    parser.add_argument('-r', '--remote', type=str, required=False,
                        help='The host to backup.')
    parser.add_argument('-d', '--directory', type=str, required=False,
                        help='Local directory backup target.')
    parser.add_argument('-u', '--user', type=str, required=False,
                        help='The remote user to connect as.')
    parser.add_argument('-q', '--quiet', action='store_true', required=False,
                        help='Decrease verbosity.')
    parser.add_argument('-v', '--verbose', action='store_true', required=False,
                        help='Increase verbosity.')
    parser.add_argument('-x', '--exclude', type=str, required=False,
                        help='The file name containing file/directory names to exclude from the backup.')
    parser.add_argument('-n', '--nossh', action='store_true', required=False,
                        help='Do not connect with ssh aka perform a local backup.')
    parser.add_argument('-m', '--monthly', action='store_true', required=False,
                        help='Force a monthly backup.')
    parser.add_argument('-md', '--monthly_date', type=int, required=False,
                        help='Set day of month for monthly backup.')

    args = parser.parse_args()

    if args.load_json:
        with open(args.load_json, 'rt') as f:
            t_args = argparse.Namespace()
            t_args.__dict__.update(json.load(f))
            args = parser.parse_args(namespace=t_args)
    if args.save_json:
        print("Saving configuration to:", args.save_json)
        with open(args.save_json, 'wt') as f:
            del args.load_json
            del args.save_json
            del args.verbose
            json.dump(vars(args), f, indent=4)
        exit()
    if args.monthly:
        if args.verbose:
            print("Monthly flag detected.")
        monthly = True
    else:
        if args.verbose:
            print("No monthly flag set.")
    if monthly:
        print("Monthly backup today.")
        backup_file = args.directory+'/backup_'+args.remote+'-'+full_date+'.tar'
    else:
        backup_file = args.directory+'/backup_'+args.remote+'-'+day_of_week+'.tar'
    backuplog = backup_file.split('.')[0]+'.log'
    if args.verbose:
        print("Backup will be stored in: ", backup_file)
        print("Backup log will be stored in: ", backuplog)
    if not os.path.exists(args.directory):
        print(args.directory, "does not exist.  Creating it.")
        os.makedirs(args.directory)
    if not args.quiet:
        dd_cmd = 'dd of='+backup_file
    else:
        dd_cmd = 'dd status=none of='+backup_file
    # perform remote backup
    # first test for successful ssh connection if we are doing that sort of thing.
    if not args.nossh:
        ssh_test = 'ssh -q '+args.user+'@'+args.remote+' exit'
        if args.verbose:
            print("Testing ssh connection with:", ssh_test)
        if os.system(ssh_test) != 0:
            raise Exception('Cannot connect with: '+ssh_test)
        ssh_cmd = 'ssh '+args.user+'@'+args.remote + \
            ' \"tar cvf - -X '+args.exclude+' ' + \
            ' '.join(args.backupdir)+'\" 2>'+backuplog+' | '+dd_cmd
        if os.system(ssh_cmd) != 0:
            raise Exception('ssh backup failed.')
    else:
        # perform local backup
        backup_cmd = 'tar -cvf - -X '+args.exclude+' ' + \
            ' '.join(args.backupdir)+' 2> '+backuplog+' | '+dd_cmd
        if args.verbose:
            print("Local backup command:", backup_cmd)
        # exit()
        if os.system(backup_cmd) != 0:
            raise Exception('Local backup failed.')
    backup_size = os.path.getsize(backup_file)
    backup_log_size = os.path.getsize(backuplog)
    if not args.quiet:
        print("Backup file is:", backup_size, " bytes.")
        if args.verbose:
            print("Backup log file is:", backup_log_size, " bytes.")


if __name__ == '__main__':
    main()
