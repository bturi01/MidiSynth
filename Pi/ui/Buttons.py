from gi.repository import Gtk



class DistortionEffectButton(Gtk.Button):
    def __init__(self):
        """
        Button for the distortion controls screen
        """
        super(DistortionEffectButton, self).__init__()  # Init
        self.set_label("Distortion controls")


class DelayEffectButton(Gtk.Button):
    def __init__(self):
        """
        Button for the delay controls screen
        """
        super(DelayEffectButton, self).__init__()
        self.set_label("Delay controls")
        self.connect("clicked", self.on_click_me_clicked)

    def on_click_me_clicked(self,DelayEffectButton):
        print("\"Click me\" button was clicked")



class ReverbEffectButton(Gtk.Button):
    def __init__(self):
        """
        Button for the reverb controls screen
        """
        super(ReverbEffectButton, self).__init__()
        self.set_label("Reverb controls")
