export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
  git
  sudo
)

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
