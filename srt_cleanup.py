#!/usr/bin/env python3
import os
import sys
from bs4 import BeautifulSoup

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('This script processes a file containing raw subtitle (srt) text and produces basic formatted text directed to an output file.')
        print()
        print('Usage: srt_cleanup.py [raw srt filename] [output filename]')
        sys.exit()
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    with open(input_file,'r') as file1, open(output_file,'w') as file2:
        soup = BeautifulSoup(file1,"html.parser")
        for line in soup.stripped_strings:
            if line[0].isdigit():
                continue
            file2.writelines((line,'\n'))
            print(str(line.lstrip("\n")),end="\n")
    sys.exit()
