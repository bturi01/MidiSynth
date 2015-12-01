import time
from Gpio import Gpio

print('Settting up')
Gpio.setup()

# Reset
print('Sending byte 1111 1111')
Gpio.send_data(0b11111111)

# Effect
print('Sending byte 0000 0001')
Gpio.send_data(0b00000001)

# Para 1
print('Sending byte 0000 0101')
Gpio.send_data(0b00000101)

# Para 2
print('Sending byte 0000 1111')
Gpio.send_data(0b00001111)

# Para 3
print('Sending byte 0001 1111')
Gpio.send_data(0b00011111)

# Para 4
print('Sending byte 0101 1111')
Gpio.send_data(0b01011111)

# Reset
print('Sending byte 1111 1111')
Gpio.send_data(0b11111111)

# Garbage
print('Sending byte 1010 1010')
Gpio.send_data(0b10101010)

# Garbage
print('Sending byte 1011 1011')
Gpio.send_data(0b10111011)

# Reset
print('Sending byte 1111 1111')
Gpio.send_data(0b11111111)

# Effect
print('Sending byte 1000 0001')
Gpio.send_data(0b10000001)

# Para 1
print('Sending byte 1000 0101')
Gpio.send_data(0b10000101)

# Para 2
print('Sending byte 1000 1111')
Gpio.send_data(0b10001111)

# Para 3
print('Sending byte 1001 1111')
Gpio.send_data(0b10011111)

# Para 4
print('Sending byte 1101 1111')
Gpio.send_data(0b11011111)
