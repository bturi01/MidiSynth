import RPi.GPIO as GPIO
import time
import math


class Pins():
    DATA_READY = 8
    DATA_RCVD = 10
    DATA_0 = 3
    DATA_1 = 5
    DATA_2 = 7
    DATA_3 = 11
    DATA_4 = 12
    DATA_5 = 13
    DATA_6 = 15
    DATA_7 = 16


class Gpio():
    @staticmethod
    def setup(debug=True):
        """
        Sets up the GPIO pins for data transfer
        """
        GPIO.setmode(GPIO.BOARD)
        GPIO.setwarnings(debug)

        GPIO.setup(Pins.DATA_READY, GPIO.OUT)
        GPIO.setup(Pins.DATA_RCVD, GPIO.IN)
        GPIO.setup(Pins.DATA_0, GPIO.OUT)
        GPIO.setup(Pins.DATA_1, GPIO.OUT)
        GPIO.setup(Pins.DATA_2, GPIO.OUT)
        GPIO.setup(Pins.DATA_3, GPIO.OUT)
        GPIO.setup(Pins.DATA_4, GPIO.OUT)
        GPIO.setup(Pins.DATA_5, GPIO.OUT)
        GPIO.setup(Pins.DATA_6, GPIO.OUT)
        GPIO.setup(Pins.DATA_7, GPIO.OUT)

        GPIO.output(Pins.DATA_READY, False)
        GPIO.output(Pins.DATA_0, False)
        GPIO.output(Pins.DATA_1, False)
        GPIO.output(Pins.DATA_2, False)
        GPIO.output(Pins.DATA_3, False)
        GPIO.output(Pins.DATA_4, False)
        GPIO.output(Pins.DATA_5, False)
        GPIO.output(Pins.DATA_6, False)
        GPIO.output(Pins.DATA_7, False)

    @staticmethod
    def set_data_pins(byte):
        """
        Sets the GPIO pins based on the byte value
        :param byte:
        """
        GPIO.output(Pins.DATA_0, int(byte) & 1)
        GPIO.output(Pins.DATA_1, int(byte) & 2)
        GPIO.output(Pins.DATA_2, int(byte) & 4)
        GPIO.output(Pins.DATA_3, int(byte) & 8)
        GPIO.output(Pins.DATA_4, int(byte) & 16)
        GPIO.output(Pins.DATA_5, int(byte) & 32)
        GPIO.output(Pins.DATA_6, int(byte) & 64)
        GPIO.output(Pins.DATA_7, int(byte) & 128)

    @staticmethod
    def reset_data_pins():
        """
        Resets the data pins for the next transmission
        """
        GPIO.output(Pins.DATA_READY, False)
        GPIO.output(Pins.DATA_0, False)
        GPIO.output(Pins.DATA_1, False)
        GPIO.output(Pins.DATA_2, False)
        GPIO.output(Pins.DATA_3, False)
        GPIO.output(Pins.DATA_4, False)
        GPIO.output(Pins.DATA_5, False)
        GPIO.output(Pins.DATA_6, False)
        GPIO.output(Pins.DATA_7, False)

    @staticmethod
    def send_data(data, shift_to_byte=0):
        """
        Blocking write of a byte of data
        :param data:
        :param shift_to_byte: Determines which byte to sent, with 0 being the LSByte and 3 the MSByte
        :return: :raise Exception:
        """
        if GPIO.input(Pins.DATA_READY):
            raise Exception('Bus is busy')
        else:
            # Set pins and change DATA_READY pin to high
            Gpio.set_data_pins(data >> (8 * shift_to_byte))
            GPIO.output(Pins.DATA_READY, True)

            # Wait for DATA_RCVD
            while not GPIO.input(Pins.DATA_RCVD):
                time.sleep(.01)

            # Reset pins
            Gpio.reset_data_pins()

            return True

    @staticmethod
    def send_reset_data():
        """
        Sends reset signal to FPGA
        """
        Gpio.send_data(0b11111111)

    @staticmethod
    def send_distortion_data(effect_on, data):
        """
        Sends the parameters for the distortion effect to the FPGA
        :param data:
        """
        data = Gpio.scale_distortion_data(data)

        Gpio.send_reset_data()

        if effect_on:
            Gpio.send_data(0b00000011)
        else:
            Gpio.send_data(0b10000011)

        Gpio.send_data(data, 1)
        Gpio.send_data(data)
        print("Updated distortion")

    @staticmethod
    def send_delay_data(effect_on, para_1, para_2, para_3):

        Gpio.send_reset_data()

        if effect_on:
            Gpio.send_data(0b00000001)
        else:
            Gpio.send_data(0b10000001)

        Gpio.send_data(Gpio.scale_delay_data(para_1))
        Gpio.send_data(Gpio.scale_delay_data(para_2))
        Gpio.send_data(0b00000001)
        Gpio.send_data(Gpio.scale_delay_data(para_3))
        print("Updated delay")

    @staticmethod
    def send_reverb_data(effect_on, para_1, para_2, para_3, para_4):
        Gpio.send_reset_data()

        if effect_on:
            Gpio.send_data(0b00000010)
        else:
            Gpio.send_data(0b10000010)

        Gpio.send_data(Gpio.scale_reverb_data(para_1))
        Gpio.send_data(Gpio.scale_reverb_data(para_2))
        Gpio.send_data(Gpio.scale_reverb_data(para_3))
        Gpio.send_data(Gpio.scale_reverb_data(para_4))
        print("Updated reverb")

    @staticmethod
    def scale_data(min_in, min_out, max_in, max_out, value):
        """
        Scales data from the input range to the output range
        :param min_in: Minimum value of input
        :param min_out: Minimum out value of output
        :param max_in: Maximum value of input
        :param max_out: Maximum value of output
        :param value: Value that needs to be converted
        :return: Converted value rounded down
        """
        return math.floor(((value - min_in)/(max_in-min_in))*(max_out-min_out) + min_out)

    @staticmethod
    def scale_distortion_data(value):
        return Gpio.scale_data(0, 0, 100, 0x0f00, value)

    @staticmethod
    def scale_delay_data(value):
        return Gpio.scale_data(0, 0, 100, 254, value)

    @staticmethod
    def scale_reverb_data(value):
        return Gpio.scale_data(0, 0, 100, 254, value)
