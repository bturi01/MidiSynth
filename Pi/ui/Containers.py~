# include <gtk/gtk.h>
from gi.repository import Gtk
from communication.Gpio import Gpio


class MainWindow(Gtk.Notebook):
    def __init__(self):

        super(MainWindow, self).__init__()  # Init


        # Delay screen with sliders
        delay = Gtk.Grid()
        
        # Make switch
        self.delaySwitch = Gtk.Switch.new()
        self.delaySwitch.set_name("delaySwitch")
        # Make slider 1
        adjustmentDelayParameter1 = Gtk.Adjustment.new(50, 1, 100, 1, 1, 1)
        self.delayParameter1 = Gtk.Scale.new(Gtk.Orientation.HORIZONTAL, adjustmentDelayParameter1)
        self.delayParameter1.set_name("delayParameter1")
        # Make slider 2
        adjustmentDelayParameter2 = Gtk.Adjustment.new(50, 1, 100, 1, 1, 1)
        self.delayParameter2 = Gtk.Scale.new(Gtk.Orientation.HORIZONTAL, adjustmentDelayParameter2)
        self.delayParameter2.set_name("delayParameter2")
        # Make slider 3
        adjustmentDelayParameter3 = Gtk.Adjustment.new(50, 1, 100, 1, 1, 1)
        self.delayParameter3 = Gtk.Scale.new(Gtk.Orientation.HORIZONTAL, adjustmentDelayParameter3)
        self.delayParameter3.set_name("delayParameter3")
        # Add switch
        delay.attach(self.delaySwitch, 0, 0, 1, 1)
        # Add slider 1 with label
        delay.attach(Gtk.Label.new("Some parameter"), 0, 1, 1, 1)
        delay.attach(self.delayParameter1, 0, 2, 1, 1)
        # Add slider 2 with label
        delay.attach(Gtk.Label.new("Another parameter"), 0, 3, 1, 1)
        delay.attach(self.delayParameter2, 0, 4, 1, 1)
        # Add slider 3 with label
        delay.attach(Gtk.Label.new("Parameter"), 0, 5, 1, 1)
        delay.attach(self.delayParameter3, 0, 6, 1, 1)

        # Distortion screen with sliders
        distortion = Gtk.Grid()
        
        # Make switch
        self.distortionSwitch = Gtk.Switch.new()
        self.distortionSwitch.set_name("disortionSwitch")
        # Make slider 1
        adjustmentDistortionParameter1 = Gtk.Adjustment.new(50, 1, 100, 1, 1, 1)
        self.distortionParameter1 = Gtk.Scale.new(Gtk.Orientation.HORIZONTAL, adjustmentDistortionParameter1)
        self.distortionParameter1.set_name("distortionParameter1")
        # Add switch
        distortion.attach(self.distortionSwitch, 0, 0, 1, 1)
        # Add slider 1 with label
        distortion.attach(Gtk.Label.new("Drive"), 0, 1, 1, 1)
        distortion.attach(self.distortionParameter1, 0, 2, 1, 1)


        # Reverb screen with sliders on switch
        reverb = Gtk.Grid()
        

        # Make on of switch
        self.reverbSwitch = Gtk.Switch.new()
        self.reverbSwitch.set_name("reverbSwitch")
        # Make slider 1
        adjustmentReverbParameter1 = Gtk.Adjustment.new(50, 1, 100, 1, 1, 1)
        self.reverbParameter1 = Gtk.Scale.new(Gtk.Orientation.HORIZONTAL, adjustmentReverbParameter1)
        self.reverbParameter1.set_name("reverbParameter1")
        # Make slider 2
        adjustmentReverbParameter2 = Gtk.Adjustment.new(50, 1, 100, 1, 1, 1)
        self.reverbParameter2 = Gtk.Scale.new(Gtk.Orientation.HORIZONTAL, adjustmentReverbParameter2)
        self.reverbParameter2.set_name("reverbParameter2")
        # Make slider 3
        adjustmentReverbParameter3 = Gtk.Adjustment.new(50, 1, 100, 1, 1, 1)
        self.reverbParameter3 = Gtk.Scale.new(Gtk.Orientation.HORIZONTAL, adjustmentReverbParameter3)
        self.reverbParameter3.set_name("reverbParameter3")
        # Make slider 4
        adjustmentReverbParameter4 = Gtk.Adjustment.new(50, 1, 100, 1, 1, 1)
        self.reverbParameter4 = Gtk.Scale.new(Gtk.Orientation.HORIZONTAL, adjustmentReverbParameter4)
        self.reverbParameter4.set_name("reverbParameter4")
        # Add switch
        reverb.attach(self.reverbSwitch, 0, 0, 1, 1)
        # Add slider 1 with label
        reverb.attach(Gtk.Label.new("Some parameter"), 0, 2, 1, 1)
        reverb.attach(self.reverbParameter1, 0, 3, 1, 1)
        # Add slider 2 with label
        reverb.attach(Gtk.Label.new("Another parameter"), 0, 4, 1, 1)
        reverb.attach(self.reverbParameter2, 0, 5, 1, 1)
        # Add slider 3 with label
        reverb.attach(Gtk.Label.new("The last parameter"), 0, 6, 1, 1)
        reverb.attach(self.reverbParameter3, 0, 7, 1, 1)
        # Add slider 4 with label
        reverb.attach(Gtk.Label.new("The last parameter"), 0, 8, 1, 1)
        reverb.attach(self.reverbParameter4, 0, 9, 1, 1)

        # Make handlers for all the scales and switches
        # Delay handlers
        self.delaySwitch.connect("state-changed", self.stateChanged)
        self.delayParameter1.connect("change-value", self.valueChanged)
        self.delayParameter2.connect("change-value", self.valueChanged)
        self.delayParameter3.connect("change-value", self.valueChanged)

        # Distortion handlers
        self.distortionSwitch.connect("state-changed", self.stateChanged)
        self.distortionParameter1.connect("change-value", self.valueChanged)
        
        # Reverb handlers
        self.reverbSwitch.connect("state-changed", self.stateChanged)
        self.reverbParameter1.connect("change-value", self.valueChanged)
        self.reverbParameter2.connect("change-value", self.valueChanged)
        self.reverbParameter3.connect("change-value", self.valueChanged)
        self.reverbParameter4.connect("change-value", self.valueChanged)


        # Add pages to window
        self.append_page(delay, Gtk.Label.new("Delay effect"))
        self.append_page(distortion, Gtk.Label.new("Distortion effect"))
        self.append_page(reverb, Gtk.Label.new("Reverb effect"))

    def valueChanged(self, arg1, arg2, arg3):
        name = arg1.get_name()

        if(name == "delayParameter1" or name == "delayParameter2" or name == "delayParameter3"):
            self.sendDataDelay(self.delaySwitch.get_active(), self.delayParameter1.get_value(), self.delayParameter2.get_value(), self.delayParameter3.get_value())
        elif (name == "distortionParameter1"):
            self.sendDataDistortion(self.distortionSwitch.get_active(), self.distortionParameter1.get_value())
        else:
            self.sendDataReverb(self.reverbSwitch.get_active()), self.reverbParameter1.get_value(), self.reverbParameter2.get_value(), self.reverbParameter3.get_value(), self.reverbParameter4.get_value())



    def stateChanged(self, arg1, arg2):
        active = arg1.get_active()
        name = arg1.get_name()
        if (name == "reverbSwitch"):
            self.sendDataReverb(active,self.reverbParameter1.get_value(), self.reverbParameter2.get_value(), self.reverbParameter3.get_value(), self.reverbParameter4.get_value())
        elif (name == "disortionSwitch"):
            self.sendDataDistortion(active, self.distortionParameter1.get_value())
        else:
            self.sendDataDelay(active, self.delayParameter1.get_value(), self.delayParameter2.get_value(), self.delayParameter3.get_value())


    def sendDataDelay(self, effectActive, parameter1, parameter2, parameter3):
        Gpio.send_delay_data(effectActive, int(parameter1), int(parameter2), int(parameter3))


    def sendDataDistortion(self, effectActive, parameter1):
        Gpio.send_distortion_data(effectActive, int(parameter1))

    def sendDataReverb(self, effectActive, parameter1, parameter2, parameter3, parameter4):
        Gpio.send_reverb_data(effectActive, int(parameter1), int(parameter2), int(parameter3), int(parameter4))
