#!/usr/bin/env python3
import os
from pyzbar.pyzbar import decode
from PIL import Image

def main():
    while True:
        input_file = input("QR code filename to decode: ")
        if os.path.isfile(input_file):
            break
        else:
            print("No such file!")
    decodecQR = decode(Image.open(input_file))
    print(decodecQR[0].data.decode('ascii'))

if __name__ == "__main__":
    main()
