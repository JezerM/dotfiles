# My dotfiles
These are my dotfiles.

> For previous dotfiles, using AwesomeWM, use `awesome` branch

## Dependencies

| Dependency | Required | Description |
|:----------:|:--------:|:-----------:|
| [stow][stow]  | :heavy_check_mark: | Symlink farm manager |
| [Alacritty][alacritty]  | :heavy_check_mark: | A fast terminal emulator |
| [Neovim][nvim]     | :heavy_check_mark: | Nice editor |
| [zsh][zsh] with [zinit][zinit] |  | Z shell and ZSH plugin manager |
| [zoxide][zoxide] |  | A smarter cd command |
| [fzf][fzf] |  | A command-line fuzzy finder |
| [vivid][vivid] |  | LS_COLORS generator |

## Install

Inside $HOME directory, use:
```sh
git clone --recursive https://github.com/JezerM/dotfiles
cd dotfiles
stow --dotfiles .
```

### macOS

To install macOS packages with Homebrew, run:

```sh
brew bundle
```

[alacritty]: https://github.com/alacritty/alacritty
[nvim]: https://github.com/neovim/neovim
[zsh]: https://www.zsh.org/
[zinit]: https://github.com/zdharma-continuum/zinit
[zoxide]: https://github.com/ajeetdsouza/zoxide
[fzf]: https://github.com/junegunn/fzf
[stow]: https://www.gnu.org/software/stow/manual/
[vivid]: https://github.com/sharkdp/vivid
