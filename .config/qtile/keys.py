from libqtile import bar, layout, widget
from libqtile import hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

import os
import subprocess

mod = "mod4"
home = os.path.expanduser('~')
terminal = "alacritty"

def toggleBar(qtile):
    qtile.cmd_hide_show_bar()
    subprocess.call(home+"/.config/qtile/scripts/toggle_eww.sh")

def togglePicom(qtile):
    subprocess.call(home+"/.config/qtile/scripts/togglepicom.sh")

def screenshot(qtile):
    subprocess.call(home+"/.takeScreenshot.sh")

keys = [
    # Switch between windows
    Key(
        [mod],
        "h",
        lazy.layout.previous(),
        desc="Move focus to left"),
    Key(
        [mod],
        "l",
        lazy.layout.next(),
        desc="Move focus to right"),
    Key(
        [mod],
        "j",
        lazy.layout.down(),
        desc="Move focus down"),
    Key(
        [mod],
        "k",
        lazy.layout.up(),
        desc="Move focus up"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"],
        "h",
        lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key(
        [mod, "shift"],
        "j",
        lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key(
        [mod, "shift"],
        "k",
        lazy.layout.shuffle_up(),
        desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key(
        [mod, "control"],
        "h",
        lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key(
        [mod, "control"],
        "l",
        lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key(
        [mod, "control"],
        "j",
        lazy.layout.grow_down(),
        desc="Grow window down"),
    Key(
        [mod, "control"],
        "k",
        lazy.layout.grow_up(),
        desc="Grow window up"),
    Key(
        [mod],
        "n",
        lazy.layout.normalize(),
        desc="Reset all window sizes"),
    Key(
        [mod],
        "m",
        lazy.window.toggle_floating(),
        desc="Toggle floating window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle window fullscreen"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key(
        ["control", "mod1"],
        "t",
        lazy.spawn(terminal),
        desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key(
        [mod],
        "Tab",
        lazy.next_layout(),
        desc="Toggle between layouts"),
    Key(
        [mod, "shift"],
        "Tab",
        lazy.prev_layout(),
        desc="Toggle backwards between layouts"),
    Key(
        [mod],
        "w",
        lazy.window.kill(),
        desc="Kill focused window"),
    Key(
        [mod, "control"],
        "r",
        lazy.restart(),
        desc="Restart Qtile"),
    Key(
        [mod, "control"],
        "q",
        lazy.shutdown(),
        desc="Shutdown Qtile"),
    Key(
        [mod],
        "r",
        lazy.spawn("rofi -show"),
        desc="Rofi app launcher"),
    Key(
        [mod],
        "e",
        lazy.spawn("rofi -show window"),
        desc="Rofi on window"),
    Key(
        [mod],
        "o",
        lazy.spawn(home+"/rofi_notification.sh"),
        desc="Rofi notifications"),
    Key(
        [mod],
        "p",
        lazy.function(togglePicom),
        desc="Toggle picom"),
    Key(
        [mod],
        "Escape",
        lazy.function(toggleBar),
        desc="Hide and show bars"),
    Key(
        [mod],
        "s",
        lazy.function(screenshot),
        desc="Take screenshot"),

    # Lock screen
    Key(
        [mod, "mod1"],
        "l",
        lazy.spawn("xidlehook-client --socket /tmp/xidlehook.sock control --action trigger --timer 0"),
        desc="Lock screen"),

    # Brightness
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("xbacklight -inc 10"),
        desc="Increase brightness"),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("xbacklight -dec 10"),
        desc="Decrease brightness"),

    # Volume and media
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn(home + "/.config/qtile/scripts/qvol.sh up"),
        desc="Increase volume"),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn(home + "/.config/qtile/scripts/qvol.sh down"),
        desc="Decrease volume"),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn(home + "/.config/qtile/scripts/qvol.sh mute"),
        desc="Toggle audio"),
    Key(
        [],
        "XF86AudioPlay",
        lazy.spawn("playerctl play-pause"),
        desc="Pause/play media"),
    Key(
        [],
        "XF86AudioNext",
        lazy.spawn("playerctl next"),
        desc="Next media"),
    Key(
        [],
        "XF86AudioPrev",
        lazy.spawn("playerctl previous"),
        desc="Previous media"),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

