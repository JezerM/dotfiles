
export PATH=${PATH}:/usr/local/mysql/bin:${HOME}/.local/bin
if [ -d "$HOME/.cargo" ]; then
  source "$HOME/.cargo/env"
fi

export VISUAL=nvim
export EDITOR=nvim
# pnpm
export PNPM_HOME="/Users/jezerm/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

export COMPOSER_BIN="/Users/jezerm/.composer/vendor/bin"
export PATH="$COMPOSER_BIN:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.2.0/bin/:$PATH"
