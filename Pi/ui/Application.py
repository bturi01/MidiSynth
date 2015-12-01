from gi.repository import Gtk, Gio, Gdk
from ui.Containers import MainWindow


class PiEffects(Gtk.Application):
    def __init__(self):
        """
        Sets up the application and calls the activate function when it's ready.
        """
        Gtk.Application.__init__(self, application_id="apps.project.pi-effects",
                                 flags=Gio.ApplicationFlags.FLAGS_NONE)
        self.connect("activate", self.on_activate)
        self.set_menubar(None)
        self.set_app_menu(None)

    def on_activate(self, data=None):
        """
        Sets up the elements that make up the user interface
        :param data:
        """
        window = Gtk.ApplicationWindow(type=Gtk.WindowType.TOPLEVEL)
        window.set_title("Pi Effects")
        window.set_border_width(0)
        window.fullscreen()

        # Sets size and centers the application
        window.set_default_size(320, 240)
        x, y = window.get_size()
        window.move(Gdk.Screen.width()/2 - x/2, Gdk.Screen.height()/2 - y/2)
        content = MainWindow()
        window.add(content)

        window.show_all()
        self.add_window(window)
