export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
  git
  sudo
)

SSH_ASKPASS_REQUIRE=never

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(/home/shotor/.local/bin/mise activate zsh)"
eval "$(devvm init zsh)"

