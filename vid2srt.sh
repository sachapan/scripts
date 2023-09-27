#!env bash 
# September 25, 2023
# Sacha Panasuik

# Script to extract subtitles from a video file URL
VIDEO=~/tmp/${1##*/}
#PREFIX=${1##*/}
SUBS_FILE=$VIDEO.srt
#curl $1 | ffmpeg -i $VIDEO $SUBS_FILE
curl $1 -o $VIDEO
ffmpeg -i $VIDEO $SUBS_FILE 
python3 ~/bin/videotitle.py $VIDEO > ~/tmp/temp_title
mv $SUBS_FILE ~/tmp/temp_subs
cat ~/tmp/temp_title > $SUBS_FILE
cat ~/tmp/temp_subs >> $SUBS_FILE
#sed '/^$/d /^[0-9]/d s/\r//g' < $SUBS_FILE > $PREFIX.new.srt 
python3 ~/bin/format_srt.py $SUBS_FILE > $VIDEO.done.srt
