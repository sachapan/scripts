#!/usr/bin/env python3
import os
import sys
from pyzbar.pyzbar import decode
from PIL import Image

def main():
    while True:
        if (args_count := len(sys.argv)) < 2:
            input_file = input("QR code filename to decode: ")
        else:
            input_file = sys.argv[1]
        if os.path.isfile(input_file):
            break
        else:
            print("No such file!")
            exit(1)
    decodecQR = decode(Image.open(input_file))
    print(decodecQR[0].data.decode('ascii'))

if __name__ == "__main__":
    main()
