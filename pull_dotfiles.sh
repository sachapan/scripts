#!/bin/bash
ansible debian -m shell -a "git --git-dir=/home/sacha/.dotfiles.git --work-tree=/home/sacha fetch" -o -u sacha
ansible debian -m shell -a "git --git-dir=/home/sacha/.dotfiles.git --work-tree=/home/sacha pull" -o -u sacha
