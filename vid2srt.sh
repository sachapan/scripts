#!env bash 
# September 25, 2023
# Sacha Panasuik
# Script to extract subtitles from a video file URL

VIDEO=~/tmp/${1##*/}
SUBS_FILE=$VIDEO.srt
#curl $1 | ffmpeg -i $VIDEO $SUBS_FILE
echo "Downloading video file."
curl -s $1 -o $VIDEO
echo "Extracting subtitles."
ffmpeg -v quiet -i $VIDEO $SUBS_FILE 
echo "Adding title."
python3 ~/bin/videotitle.py $VIDEO > ~/tmp/temp_title
mv $SUBS_FILE ~/tmp/temp_subs
cat ~/tmp/temp_title > $SUBS_FILE
cat ~/tmp/temp_subs >> $SUBS_FILE
#rm ~/tmp/temp_subs
#rm ~/tmp/temp_title 
#sed '/^$/d /^[0-9]/d s/\r//g' < $SUBS_FILE > $PREFIX.new.srt 
echo "Cleaning up subtitles from $SUBS_FILE"
python3 ~/bin/format_srt.py $SUBS_FILE > $(cat ~/tmp/temp_title).srt

#$VIDEO.done.srt
#cp $VIDEO.done.srt `cat ~/tmp/temp_title`.srt
echo "Subtitles are now available in: $VIDEO.done.srt"
