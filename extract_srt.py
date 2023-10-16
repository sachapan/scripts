#!env python3


# .5 download the video file
# 
# 1. Load srt file from video file supplied as a filename given as arg1
# 2. Extract title
# 3. Extract subtitles
#cmd = ["ffmpeg", "-i", "/home/sacha/tmp/jwb-092_E_02_r480P.mp4", "/home/sacha/tmp/new2.srt"]
# 4. Output Title and subtitles

import sys
import os
import subprocess
import ffmpeg
import re
import requests

mytmp = "/home/sacha/tmp/"

def download_file(url, mytmp):
    if url.startswith("http"):
        print("Found an http URL")
        file_name = mytmp + url.split("/")[-1]
        print("Downloading to: ", file_name)
        query_parameters = {"downloadformat": "mp4"}
        response = requests.get(url, params=query_parameters, stream=True)
        if response.ok == 200:
            with open(file_name, mode="wb") as file:
                for chunk in response.iter_content(chunk_size=10 * 1024):
                    file.write(chunk)
    else:
        file_name = url
    # only download if passed a url
    return(file_name)


def get_title(input_file):
    try:
        metadata = ffmpeg.probe(input_file, show_entries="format_tags=title")
        title = metadata.get('format', {}).get('tags', {}).get('title', '')
        title = re.sub(":", "\:", title)
        title = re.sub('"', "", title)
        #title = re.sub("\.", "", title)
        title = re.sub("\(", "- ", title)
        title = re.sub("\)", "", title)
        title = re.sub(",", "", title)
        #title = re.sub(" ","\ ",title)
        if title:
            return title.strip()
        else:
            return()
    except ffmpeg.Error as e:
        print(f"Error getting title metadata: {e.stderr}")
        return None

def get_subtitles(video_file, srt_file):
    # TODO: Can I make this function work with python-ffmpeg?
    #srt_file = title + '.srt'
    cmd = ["ffmpeg", "-y", "-i", video_file, srt_file]
    try:
        subprocess.run(cmd, check=True, capture_output=True)
    except CalledProcessError as e:
        print(f"Error extracting subtitles: {e.stderr}")
    with open(srt_file, 'r', encoding='utf-8') as file:
        lines = file.readlines()
    os.remove(srt_file)
    return(lines)

def process_lines(lines):
    result_lines = []
    current_line = ""
    for line in lines:
        line = line.strip()
        # Skip blank lines
        if not line:
            continue
        # Skip lines that begin with a number
        if re.match(r'^\d', line):
            continue
        # Skip lines that contain only numbers and symbols
        if re.match(r'^[0-9\W]+$', line):
            continue
        # Replace underscores with a single quote before 's' or 't'
        line = re.sub(r'_(s|t)\b', r"'\1", line)
        # Remove html stuff
        line = re.sub("<[^<]+?>", "", line)
        # Concatenate lines until the length is 140 characters
        if len(current_line) + len(line) <= 140:
            current_line += line + " "
        else:
            result_lines.append(current_line.strip())
            current_line = line + " "
    # Add the last line
    if current_line:
        result_lines.append(current_line.strip())
    return result_lines

def main():
    if len(sys.argv) == 2:
        input_file = sys.argv[1]
        output_file = False
        #with open(input_file, 'r', encoding='utf-8') as file:
        #    lines = file.readlines()
    elif len(sys.argv) == 3:
        input_file = sys.argv[1]
        output_file = sys.argv[2]
    else:
        print("Usage: extract_srt.py [video file] optional:[output file]")
        print("This script optionally downloads and extracts the subtitle data from a supplied video file")
        print("including title if present in the video file metadata and writes the resulting srt data to")
        print("[title].srt or the [output file] specified on the command line.")
        print("Attempts to download the [video file] if supplied a URL beginning with https://")
        print("To output to stdout only use: - for [output_file] parameter.")
        sys.exit(1)
    download = download_file(input_file, mytmp)
    if download:
        input_file = download
    title = get_title(input_file)
    srt_file = title + ".srt"
    raw_srt_name = title + "raw.srt"
    subtitles = process_lines(get_subtitles(input_file, raw_srt_name))
    if title:
        theme = ["Title: " + title + "\n"]
    else:
        theme = ["No Title\n"]
    srt = theme + subtitles
    if output_file == "-":
        print("\n".join(srt))
    elif output_file:
        with open(output_file, 'w', encoding='utf-8') as file2:
            file2.writelines("\n".join(srt))
        print("srt data now available in: ", output_file)
    else:
        with open(srt_file, "w", encoding="utf-8") as file2:
            file2.writelines("\n".join(srt))
        print("srt data now available in: ", srt_file)
        #print("Completed:", srt_name)
    #if len(sys.argv) == 1:
        # Read input from stdin
    #    lines = sys.stdin.readlines()
if __name__ == "__main__":
    main()


