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
    # initialize variables
    host = ""
    username = ""
    dir = ""
    backupfile = ""
    backuppath = ""
    target = ""
    exclude_file = ""
    monthly_day = ""
    monthly = False
    verbose_level = False
    day_of_month = datetime.today().strftime('%d')
    day_of_week = datetime.today().strftime('%a')
    print("Today is", day_of_week)
    print("Day of month:", day_of_month)
    full_date = datetime.today().strftime('%F')
    print("Full date is:", full_date)
    nossh = False
    test_run = False
    parser = argparse.ArgumentParser()
    parser.add_argument('--save_json',
                        help='Save settings to file in json format.  Only save, do not run.')
    parser.add_argument('-b', '--backupdir', type=str, nargs="+", required=False,
                        help='Directory/ies to backup.')
    parser.add_argument('--load_json',
                        help='Load settings from file in json format. Command line options override loaded values.')
    parser.add_argument('-r', '--remote', type=str, nargs='+', required=False,
                        help='The remote(s) host to backup.')
    parser.add_argument('-d', '--directory', type=str, required=False,
                        help='Local directory backup target.')
    parser.add_argument('-u', '--user', type=str, required=False,
                        help='The remote user to connect as.')
    parser.add_argument('-q', '--quiet', action='store_true', required=False,
                        help='Decrease verbosity.')
    parser.add_argument('-v', '--verbose', action='store_true', required=False,
                        help='Increase verbosity.')
    parser.add_argument('-x', '--exclude', type=str, nargs='+', required=False,
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
            # host = args.remote
            # dir = args.directory
            # exclude_file = args.exclude
            # backup = args.backupdir
            # username = args.user
            # nossh = args.nossh
            # monthly = args.monthly
            # monthly_day = args.monthly_date
            # verbose_level = args.verbose
            # #    print(host)
            # print(args)
    if args.save_json:
        print("Saving configuration to:", args.save_json)
        with open(args.save_json, 'wt') as f:
            # Do not save load_json and save_json to json config file
            del args.load_json
            del args.save_json
            del args.verbose
            json.dump(vars(args), f, indent=4)
        exit()
    for arg in [args]:
        print(arg)
    # print(args.remote)
    # for host in args.remote:
   # Determine if monthly should be run.
    if args.monthly:
        if args.verbose:
            print("Monthly flag detected.")
        monthly = True
    else:
        print("No monthly flag set.")
    if monthly:
        print("Monthly backup today.")
        backupfile = arg.directory+'/backup_'+arg.remote+'-'+full_date+'.tar'
    else:
        backupfile = arg.directory+'/backup_'+arg.remote+'-'+day_of_week+'.tar'
    backuplog = backupfile.split('.')[0]+'.log'
    print(backupfile)
    print(backuplog)
    if not os.path.exists(arg.directory):
        print(arg.directory, "does not exist.  Creating it.")
        os.makedirs(arg.directory)

#
# perform backup
# report backup results


if __name__ == '__main__':
    main()
