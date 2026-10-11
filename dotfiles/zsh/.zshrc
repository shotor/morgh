export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
  git
  sudo
)

SSH_ASKPASS_REQUIRE=never
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(/home/shotor/.local/bin/mise activate zsh)"
eval "$(devvm init zsh)"

