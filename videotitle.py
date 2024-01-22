#!env python3
import sys
import ffmpeg
import re

def get_metadata(input_file):
    try:
        metadata = ffmpeg.probe(input_file, show_entries="format_tags=title")
        title = metadata.get('format', {}).get('tags', {}).get('title', '')
        #title = re.sub(":", "", title)
        #title = re.sub('"', "", title)
        title = re.sub("\.", "", title)
        title = re.sub("\(", "- ", title)
        title = re.sub("\)", "", title)
        title = re.sub(",", "", title)

        # remove quotation marks
        # remove .
        # replace ( with -
        # remove )
        if title:
            return title.strip()
        else:
            return()
    except ffmpeg.Error as e:
        print(f"Error getting metadata: {e.stderr}")
        return None

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("This script extracts the title metadata from a video file using ffmpeg.probe.")
        print("Usage: videotitle.py input_video_file")
        sys.exit(1)

    input_file = sys.argv[1]
    print(get_metadata(input_file))

