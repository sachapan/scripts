#!/bin/bash 
# September 25, 2023
# Sacha Panasuik

# Script to extract subtitles from a video file URL
PREFIX=${1##*/}
SUBS_FILE=~/tmp/$PREFIX.srt
curl $1 | ffmpeg -i - $SUBS_FILE
sed '/^$/d /^[0-9]/d s/\r//g' < $SUBS_FILE > $PREFIX.new.srt 
~/bin/srt_cleanup.py $PREFIX.new.srt $PREFIX.done.srt
