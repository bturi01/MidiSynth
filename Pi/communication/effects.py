#!/usr/bin/env python3
from Gpio import Gpio
import sys

Gpio.setup(False)

if len(sys.argv) < 2:
    print("Usage: effects.py effect parameter1 [parameter2 [parameter3 [parameter4]]]")
else:
    if sys.argv[1].startswith('dis'):
        if len(sys.argv) != 3:
            print("Usage: effects.py dist[ortion] amount(between 0 and 100)")
        else:
            print("Sending distortion parameters")
            Gpio.send_distortion_data(True, int(sys.argv[2]))
    elif sys.argv[1].startswith('del'):
        if len(sys.argv) != 5:
            print("Usage: effects.py del[ay] para1 para2 para3")
        else:
            print("Sending delay parameters")
            Gpio.send_reset_data()
            Gpio.send_data(0b00000001)
            Gpio.send_data(int(sys.argv[2]))
            Gpio.send_data(int(sys.argv[3]))
            Gpio.send_data(int(sys.argv[4]))
            # do something
    elif sys.argv[1].startswith('rev'):
        if len(sys.argv) != 6:
            print("Usage: effects.py rev[erb] para1 para2 para3 para4")
        else:
            print("Sending reverb parameters")
            Gpio.send_reset_data()
            Gpio.send_data(0b00000010)
            Gpio.send_data(int(sys.argv[2]))
            Gpio.send_data(int(sys.argv[3]))
            Gpio.send_data(int(sys.argv[4]))
            Gpio.send_data(int(sys.argv[5]))
            # do something
    else:
        print("Usage: effects.py effect parameter1 [parameter2 [parameter3 [parameter4]]]")

Gpio.reset_data_pins()
