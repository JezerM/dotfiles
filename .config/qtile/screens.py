from libqtile import bar, layout, widget
from libqtile import hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

import os
import subprocess

from widgets.pulseVolume import PulseVolumeV
from widgets.windowName import WindowName

mod = "mod4"
home = os.path.expanduser('~')

barHeight = 24
arrowSize = barHeight - 4
roundsize = 18


colors = [
    ["#2e3440", "#2e3440"],  # background
    ["#d8dee9", "#d8dee9"],  # foreground
    ["#3b4252", "#3b4252"],  # background lighter
    ["#bf616a", "#bf616a"],  # red
    ["#a3be8c", "#a3be8c"],  # green
    ["#ebcb8b", "#ebcb8b"],  # yellow
    ["#81a1c1", "#81a1c1"],  # blue
    ["#b48ead", "#b48ead"],  # magenta
    ["#88c0d0", "#88c0d0"],  # cyan
    ["#e5e9f0", "#e5e9f0"],  # white
    ["#4c566a", "#4c566a"],  # grey
    ["#d08770", "#d08770"],  # orange
    ["#8fbcbb", "#8fbcbb"],  # super cyan
    ["#5e81ac", "#5e81ac"],  # super blue
    ["#242831", "#242831"],  # super dark background
]
group_box_settings = {
    "padding_x": 5,
    "fontsize": 10,
    "borderwidth": 4,
    "active": colors[9],
    "inactive": colors[10],
    "disable_drag": True,
    "rounded": True,
    "highlight_color": colors[2],
    "block_highlight_text_color": colors[6],
    "highlight_method": "block",
    "this_current_screen_border": colors[14],
    "this_screen_border": colors[7],
    "other_current_screen_border": colors[14],
    "other_screen_border": colors[14],
    "foreground": colors[1],
    "background": colors[14],
    "urgent_border": colors[3],
}

fullBar = bar.Bar(
            [
                #widget.LaunchBar(
                #    [
                #        ('terminal', 'x-terminal-emulator', 'launch terminal')
                #    ]
                #),
                widget.CurrentLayout(
                    background="#5e81ac"),
                widget.TextBox(
                    text="\uf0da",
                    background="#8FBCBB",
                    foreground="#5e81ac",
                    fontsize=arrowSize,
                    padding=0),
                widget.GroupBox(
                    highlight_color="#B48EAD",
                    this_current_screen_border="#bf616a",
                    rounded=False,
                    highlight_method="line",
                    background="#8FBCBB",
                    inactive="#4c566a"),
                widget.TextBox(
                    text="\uf0da",
                    background="",
                    foreground="#8FBCBB",
                    fontsize=arrowSize,
                    padding=0),
                widget.Prompt(),
                widget.WindowName(
                    padding=6),
                widget.Spacer(),
                widget.Systray(),
                widget.Spacer(10),
                widget.TextBox(
                    text="\uf0d9",
                    background="",
                    foreground="#D08770",
                    fontsize=arrowSize,
                    padding=0),
                widget.Backlight(
                    background="#D08770",
                    fmt="\uf834 {}",
                    backlight_name="intel_backlight",
                    change_command="xbacklight -set {0}"),
                widget.TextBox(
                    text="\uf0d9",
                    background="#D08770",
                    foreground="#81A1C1",
                    fontsize=arrowSize,
                    padding=0),
                PulseVolumeV(
                    background="#81A1C1",
                    fmt="\uf028 {}"),
                widget.TextBox(
                    text="\uf0d9",
                    background="#81A1C1",
                    foreground="#B48EAD",
                    fontsize=arrowSize,
                    padding=0),
                widget.Wlan(
                    background="#B48EAD",
                    max_chars=8,
                    interface="wlo1"),
                widget.TextBox(
                    text="\uf0d9",
                    background="#B48EAD",
                    foreground="#A3BE8C",
                    fontsize=arrowSize,
                    padding=0),
                widget.Battery(
                    fmt="\uf578 {}",
                    format="{percent:2.0%}",
                    background="#A3BE8C"),
                widget.TextBox(
                    text="\uf0d9",
                    background="#A3BE8C",
                    foreground="#5E81AC",
                    fontsize=arrowSize,
                    padding=0),
                widget.Clock(
                    background="#5E81AC",
                    format='%a %d-%m-%Y %H:%M'),
                widget.TextBox(
                    text="\uf0d9",
                    background="#5E81AC",
                    foreground="#BF616A",
                    fontsize=arrowSize,
                    padding=0),
                widget.QuickExit(
                    default_text="  \uf011  ",
                    countdown_format="  {}  ",
                    background="#BF616A"),
            ],
            barHeight,
            background="#2e3440",
            opacity=1
        )

leftRounded = widget.TextBox(
                text="",
                foreground=colors[14],
                background=colors[0],
                fontsize=roundsize,
                padding=0,
            )
rightRounded = widget.TextBox(
                text="",
                foreground=colors[14],
                background=colors[0],
                fontsize=roundsize,
                padding=0,
            )


barbarossaBar = bar.Bar(
[
                # widget.Image(
                #   background=colors[0],
                #    filename="~/.config/qtile/icons/qtilelogo.png",
                #    margin=6,
                #    mouse_callbacks={
                #        "Button1": lambda qtile: qtile.cmd_spawn(
                #            "./.config/rofi/launchers/ribbon/launcher.sh"
                #        )
                #    },
                # ),
                widget.TextBox(
                    text="",
                    foreground=colors[13],
                    background=colors[0],
                    font="Font Awesome 5 Free Solid",
                    fontsize=12,
                    padding=10,
                ),
                # widget.Sep(
                #    linewidth=2,
                #    foreground=colors[2],
                #    padding=25,
                #    size_percent=50,
                # ),
                leftRounded,
                widget.GroupBox(
                    font="Font Awesome 5 Brands",
                    visible_groups=[""],
                    **group_box_settings,
                ),
                widget.GroupBox(
                    font="Font Awesome 5 Free Solid",
                    **group_box_settings,
                ),
                widget.GroupBox(
                    font="Font Awesome 5 Brands",
                    visible_groups=[""],
                    **group_box_settings,
                ),
                widget.GroupBox(
                    font="Font Awesome 5 Free Solid",
                    visible_groups=["", "", ""],
                    **group_box_settings,
                ),
                rightRounded,
                widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    background=colors[0],
                    padding=10,
                    size_percent=40,
                ),
                # widget.TextBox(
                #    text=" ",
                #    foreground=colors[7],
                #    background=colors[0],
                #    font="Font Awesome 5 Free Solid",
                # ),
                # widget.CurrentLayout(
                #    background=colors[0],
                #    foreground=colors[7],
                # ),
                leftRounded,
                widget.CurrentLayoutIcon(
                    custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                    foreground=colors[2],
                    background=colors[14],
                    padding=-2,
                    scale=0.45,
                ),
                rightRounded,
                widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    padding=10,
                    size_percent=50,
                ),
                # widget.TextBox(
                #     text="",
                #     foreground=colors[14],
                #     background=colors[0],
                #     fontsize=roundsize,
                #     padding=0,
                # ),
                # widget.GenPollText(
                #     update_interval=5,
                #     foreground=colors[11],
                #     background=colors[14],
                # ),
                # widget.TextBox(
                #     text="",
                #     foreground=colors[14],
                #     background=colors[0],
                #     fontsize=roundsize,
                #     padding=0,
                # ),
                widget.Spacer(40),
                widget.TextBox(
                    text=" ",
                    foreground=colors[12],
                    background=colors[0],
                    # fontsize=38,
                    font="Font Awesome 5 Free, Solid",
                ),
                WindowName(
                    background=colors[0],
                    foreground=colors[12],
                    width=bar.CALCULATED,
                    empty_group_string="Desktop",
                    max_chars=30,
                ),
                # widget.CheckUpdates(
                #    background=colors[0],
                #    foreground=colors[3],
                #    colour_have_updates=colors[3],
                #    custom_command="./.config/qtile/updates-arch-combined",
                #    display_format=" {updates}",
                #    execute=update,
                #    padding=20,
                # ),
                widget.Spacer(),
                leftRounded,
                widget.Systray(icon_size=12, background=colors[14], padding=10),
                # CustomPomodoro(
                #    background=colors[14],
                #    fontsize=24,
                #    color_active=colors[3],
                #    color_break=colors[6],
                #    color_inactive=colors[10],
                #    timer_visible=False,
                #    prefix_active="",
                #    prefix_break="",
                #    prefix_inactive="",
                #    prefix_long_break="",
                #    prefix_paused="",
                # ),
                rightRounded,
                 widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    padding=10,
                    size_percent=50,
                ),
                leftRounded,
                widget.TextBox(
                    text=" ",
                    foreground=colors[11],
                    background=colors[14],
                    font="Font Awesome 5 Free, Solid",
                ),
                widget.Backlight(
                    foreground=colors[11],
                    background=colors[14],
                    backlight_name="intel_backlight",
                    change_command="xbacklight -set {0}"),
                rightRounded,
                widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    padding=10,
                    size_percent=50,
                ),
                leftRounded,
                widget.TextBox(
                    text=" ",
                    foreground=colors[8],
                    background=colors[14],
                    font="Font Awesome 5 Free, Solid",
                ),
                PulseVolumeV(
                    foreground=colors[8],
                    background=colors[14],
                    limit_max_volume="True",
                ),
                rightRounded,
                widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    padding=10,
                    size_percent=50,
                ),
                #widget.TextBox(
                #   text="",
                #   foreground=colors[14],
                #   background=colors[0],
                #   fontsize=roundsize,
                #   padding=0,
                #),
                #widget.TextBox(
                #    text=" ",
                #    foreground=colors[6],
                #    background=colors[14],
                #    font="Font Awesome 5 Free Brands",
                #    # fontsize=38,
                #),
                #widget.Bluetooth(
                #    background=colors[14],
                #    foreground=colors[6],
                #    hci="/dev_00_0A_45_0D_24_47",
                #    mouse_callbacks={
                #       "Button1": toggle_bluetooth,
                #       "Button3": open_bt_menu,
                #    },
                #),
                #widget.TextBox(
                #   text="",
                #   foreground=colors[14],
                #   background=colors[0],
                #   fontsize=roundsize,
                #   padding=0,
                #),
                #widget.Sep(
                #   linewidth=0,
                #   foreground=colors[2],
                #   padding=10,
                #   size_percent=50,
                #),
                leftRounded,
                widget.TextBox(
                    text=" ",
                    font="Font Awesome 5 Free, Solid",
                    foreground=colors[7],  # fontsize=38
                    background=colors[14],
                ),
                widget.Wlan(
                    interface="wlo1",
                    format="{essid}",
                    foreground=colors[7],
                    background=colors[14],
                    padding=5,
                ),
                rightRounded,
                widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    padding=10,
                    size_percent=50,
                ),
                leftRounded,
                widget.TextBox(
                    text=" ",
                    foreground=colors[4],
                    background=colors[14],
                    font="Font Awesome 5 Free, Solid",
                ),
                widget.Battery(
                    foreground=colors[4],
                    background=colors[14],
                    format="{percent:2.0%}",
                ),
                rightRounded,
                widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    padding=10,
                    size_percent=50,
                ),
                leftRounded,
                widget.TextBox(
                    text=" ",
                    font="Font Awesome 5 Free, Solid",
                    foreground=colors[5],  # fontsize=38
                    background=colors[14],
                ),
                widget.Clock(
                    format="%a, %b %d",
                    background=colors[14],
                    foreground=colors[5],
                ),
                rightRounded,
                widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    padding=10,
                    size_percent=50,
                ),
                leftRounded,
                widget.TextBox(
                    text=" ",
                    font="Font Awesome 5 Free Solid",
                    foreground=colors[4],  # fontsize=38
                    background=colors[14],
                ),
                widget.Clock(
                    format="%I:%M %p",
                    foreground=colors[4],
                    background=colors[14],
                    #    mouse_callbacks={"Button1": todays_date},
                ),
                rightRounded,
                # widget.Sep(
                #    linewidth=2,
                #    foreground=colors[2],
                #    padding=25,
                #    size_percent=50,
                # ),
                widget.TextBox(
                    text="⏻",
                    foreground=colors[13],
                    font="Font Awesome 5 Free, Solid",
                    fontsize=12,
                    padding=20,
                ),
            ],
            barHeight,
            margin=[4, -4, 4, -4],
        )

noneBar = bar.Bar(
            [
            ],
            barHeight,
            background="#2e344000",
        )


screens = [
    Screen(
        top=barbarossaBar,
        )
]
