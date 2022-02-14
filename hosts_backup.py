#!/usr/bin/env python3
# A python version of the /bin/sh script win_hosts_backup.sh
# Purpose: perform backups via ssh, tar and dd from a remote host to the local host
#
# Sacha Panasuik
# sachapan@gmail.com
# Initial script creation: January 14, 2021
# imports
import sys
import os
import argparse


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-r', '--remote', type=str, nargs='+', required=True,
                        help='The remote(s) host to backup.')
    parser.add_argument('-d', '--directory', type=str, required=False,
                        help='Local directory backup target.')
    parser.add_argument('-u', '--user', type=str, required=True,
                        help='The remote user to connect as.')
    parser.add_argument('-x', '--exclude', type=str, nargs='+', required=True,
                        help='The file name containing file/directory names to exclude from the backup.')
    parser.add_argument('-n', '--nossh', action='store_true', required=False,
                        help='Do not connect with ssh aka perform a local backup.')
    parser.add_argument('-m', '--monthly', action='store_true', required=False,
                        help='Flag to set a monthly backup.')
    # parser.add_argument('-h', '--help', type=str, nargs='+', required=False,
    #                    help='The file name containing file/directory names to exclude from the backup.')
    args = parser.parse_args()
    for arg in [args]:
        print(arg)
    # print(args.remote)
    for host in args.remote:
        print(host)
    if args.monthly:
        print("Monthly flag detected.")
# Set some variables
# Read variables from config file?

# Read command line flags/parameters

# determine if a monthly backup should be performed

# perform backup

# report backup results


if __name__ == '__main__':
    main()
