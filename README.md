# My dotfiles
These are my dotfiles, in Void Linux, using AwesomeWM and LightDM.

![Screenshot_2022-01-21-19_1366x768](https://user-images.githubusercontent.com/59768785/150624457-01cabe8a-04f1-4b76-b613-4544c371be69.png)


## Dependencies

| Dependency | Required | Description |
|:----------:|:--------:|:-----------:|
| [AwesomeWM][awesomewm]  | :heavy_check_mark: | An awesome window manager |
| [Alacritty][alacritty]  | :heavy_check_mark: | A fast terminal emulator |
| [Neovim][nvim]     | :heavy_check_mark: | Nice editor |
| ACPI and acpi_listen |  | Required for battery management |
| [light-locker][light-locker] with [LightDM][lightdm] | :heavy_check_mark: | Lock screen and login manager |
| [rofi][rofi] | :heavy_check_mark: | Application launcher and other utils |
| [dex][dex] |  | Desktop entry execution |
| [pulsemixer][pulsemixer] |  | Sound management |
| [playerctl][playerctl] |  | Media player controller |
| [picom-jonaburg][picom-jonaburg] |  | Blurring, shadows, rounded corners, and window animations |
| [xidlehook][xidlehook] |  | Required to lock session on idle |
| [brightnessctl][brightnessctl] |  | Used only with xidlehook to dim and restore screen brightness |
| [zsh][zsh] with [ohmyzsh][ohmyzsh] |  | Z shell and ZSH plugin manager |

## Install

Inside $HOME directory, use:
```sh
git clone --recursive https://github.com/JezerM/dotfiles
cd dotfiles
./install.sh
```

### Brightness setup

TODO

[acpilight]: https://gitlab.com/wavexx/acpilight
[pulsemixer]: https://github.com/GeorgeFilipkin/pulsemixer
[playerctl]: https://github.com/altdesktop/playerctl
[awesomewm]: https://github.com/awesomeWM/awesome
[alacritty]: https://github.com/alacritty/alacritty
[nvim]: https://github.com/neovim/neovim
[dex]: https://github.com/jceb/dex
[picom-jonaburg]: https://github.com/jonaburg/picom
[rofi]: https://github.com/davatorium/rofi
[light-locker]: https://github.com/the-cavalry/light-locker
[lightdm]: https://github.com/canonical/lightdm
[xidlehook]: https://gitlab.com/jD91mZM2/xidlehook
[brightnessctl]: https://github.com/Hummer12007/brightnessctl
[zsh]: https://www.zsh.org/
[ohmyzsh]: https://ohmyz.sh/
