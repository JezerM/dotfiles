import os
import subprocess

home = os.path.expanduser('~/.config/qtile/autostart.sh')
subprocess.call([home])
