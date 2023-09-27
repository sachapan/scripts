#!env python3
import sys
import ffmpeg

def get_metadata(input_file):
    try:
        metadata = ffmpeg.probe(input_file, show_entries="format_tags=title")
        return metadata.get('format', {}).get('tags', {}).get('title', '')
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

