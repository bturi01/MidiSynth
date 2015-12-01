from communication.Gpio import Gpio
from ui.Application import PiEffects

Gpio.setup()

app = PiEffects()
app.run(None)

Gpio.reset_data_pins()
