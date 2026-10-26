if [[ -r /usr/share/oh-my-zsh/oh-my-zsh.sh ]]; then
  export ZSH=/usr/share/oh-my-zsh
  zstyle ':omz:update' mode disabled
else
  export ZSH="$HOME/.oh-my-zsh"
fi
export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
ZSH_THEME=""
plugins=(git sudo)

export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
if [[ -z "$SSH_AUTH_SOCK" && -r /etc/profile.d/fido.sh ]]; then
  source /etc/profile.d/fido.sh
fi
[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
(( $+commands[starship] )) && eval "$(starship init zsh)"
(( $+commands[mise] )) && eval "$(mise activate zsh)"
(( $+commands[devvm] )) && eval "$(devvm init zsh)"
