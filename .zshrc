source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zi snippet OMZP::git
zi snippet OMZP::brew

export LS_COLORS=" "
export LSCOLORS="Gxfxcxdxbxegedabagacad"

zinit ice blockf
zi snippet PZTM::completion

zi snippet PZTM::history
zi snippet PZTM::directory

zi light lukechilds/zsh-better-npm-completion
zi light zsh-users/zsh-completions

zi light zsh-users/zsh-history-substring-search
zi snippet PZTM::history-substring-search

zi ice as"completion"
zi snippet OMZP::docker/_docker

zi ice as"completion"
zi snippet OMZP::fd/_fd

zi ice as"completion"
zi snippet OMZP::ripgrep/_ripgrep

zinit ice blockf completions
zi light rust-zinit

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

ls -G . &>/dev/null && alias ls='ls -G'

bindkey -v

alias libreoffice="/Applications/LibreOffice.app/Contents/MacOS/soffice"
alias playit="/Applications/playit.app/Contents/MacOS/playit"

function docxtopdf() {
  libreoffice --headless --convert-to pdf --outdir . $1
}

source ~/.profile
eval "$(starship init zsh)"
