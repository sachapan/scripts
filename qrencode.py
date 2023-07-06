#!/usr/bin/env python3
import os
import qrcode
#input_data = "This is the way"
#input_data = "WIFI:T:WPA;S:ferrlegal;P:awMJWP0Ev9AP3WmjwqiT;H:;;"
def main():
    ssid = input("Enter SSID: ")
    input_pass = input("Enter passcode: ")
    input_data = "WIFI:T:WPA;S:" + ssid + ";P:" + input_pass + ";H:;;"
    print(input_data)
    qr = qrcode.QRCode(
            version=1,
            box_size=10,
            border=1)

    qr.add_data(input_data)
    qr.make(fit=True)
    img = qr.make_image(fill='black', back_color='white')
    img.save('qrencode.png')

if __name__ == "__main__":
    main()
