import subprocess
import os

from libqtile import bar
from libqtile.widget import base
from libqtile.log_utils import logger

home = os.path.expanduser("~")

__all__ = [
    'PulseVolumeV',
]

class PulseVolumeV(base._TextBox):
    """Widget that display and change volume

    By default, this widget uses ``pulsemixer`` to get and set the volume so users
    will need to make sure this is installed.

    If theme_path is set it draw widget as icons.
    """
    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ("cardid", None, "Card Id"),
        ("device", "default", "Device Name"),
        ("channel", "Master", "Channel"),
        ("padding", 3, "Padding left and right. Calculated if None."),
        ("update_interval", 0.2, "Update time in seconds."),
        ("theme_path", None, "Path of the icons"),
        ("emoji", False, "Use emoji to display volume states, only if ``theme_path`` is not set."
                         "The specified font needs to contain the correct unicode characters."),
        ("mute_command", None, "Mute command"),
        ("volume_app", None, "App to control volume"),
        ("volume_up_command", None, "Volume up command"),
        ("volume_down_command", None, "Volume down command"),
        ("get_volume_command", None, "Command to get the current volume"),
        ("step", 2, "Volume change for up an down commands in percentage."
                    "Only used if ``volume_up_command`` and ``volume_down_command`` are not set.")
    ]

    def __init__(self, **config):
        base._TextBox.__init__(self, '0', width=bar.CALCULATED, **config)
        self.add_defaults(PulseVolumeV.defaults)
        if self.theme_path:
            self.length_type = bar.STATIC
            self.length = 0
        self.surfaces = {}
        self.volume = None
        self.muted = None

        self.add_callbacks({
            'Button1': self.cmd_mute,
            'Button4': self.cmd_increase_vol,
            'Button5': self.cmd_decrease_vol,
        })

    def timer_setup(self):
        self.timeout_add(self.update_interval, self.update)
        if self.theme_path:
            self.setup_images()   

    def button_press(self, x, y, button):
        base._TextBox.button_press(self, x, y, button)
        self.draw()

    def update(self):
        vol = self.get_volume()
        mut = self.get_mute()
        if vol != self.volume:
            self.volume = vol
            # Update the underlying canvas size before actually attempting
            # to figure out how big it is and draw it.
            self._update_drawer()
            self.bar.draw()
        if mut != self.muted:
            self.muted = mut
            self._update_drawer()
            self.bar.draw()
        self.timeout_add(self.update_interval, self.update)

    def _update_drawer(self):
        if self.theme_path:
            self.drawer.clear(self.background or self.bar.background)
            if self.volume <= 0 or self.muted is 1:
                img_name = 'audio-volume-muted'
            elif self.volume <= 30:
                img_name = 'audio-volume-low'
            elif self.volume < 80:
                img_name = 'audio-volume-medium'
            else:  # self.volume >= 80:
                img_name = 'audio-volume-high'

            self.drawer.ctx.set_source(self.surfaces[img_name])
            self.drawer.ctx.paint()
        else:
            if self.muted is 1 or self.volume is 0:
                self.text = 'M'
            else:
                self.text = '{}%'.format(self.volume)

    def get_volume(self):
        try:
            cmd = "pulsemixer --get-volume".split()
            mixer_out = subprocess.check_output(cmd).decode("utf-8")
            mixer_out = mixer_out.split()[0]
        except subprocess.CalledProcessError:
            return -1

        if mixer_out:
            return int(mixer_out)
        else:
            # this shouldn't happen
            return -1

    def get_mute(self):
        try:
            cmd = "pulsemixer --get-mute".split()
            mixer_out = subprocess.check_output(cmd).decode("utf-8")
        except subprocess.CalledProcessError:
            return 1
        
        return int(mixer_out)

    def draw(self):
        if self.theme_path:
            self.drawer.draw(offsetx=self.offset, width=self.length)
        else:
            base._TextBox.draw(self)

    def cmd_increase_vol(self):
        cmd = (home + "/.config/qtile/scripts/qvol.sh up").split()
        subprocess.call(cmd)

    def cmd_decrease_vol(self):
        cmd = (home + "/.config/qtile/scripts/qvol.sh down").split()
        subprocess.call(cmd)

    def cmd_mute(self):
        cmd = (home + "/.config/qtile/scripts/qvol.sh mute").split()
        subprocess.call(cmd)

