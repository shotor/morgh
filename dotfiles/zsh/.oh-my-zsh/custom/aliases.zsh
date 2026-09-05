alias ls='lsd'

alias DOITNOW='gaa && gcn! && gpf'

if ! command -v code >/dev/null 2>&1; then
  alias code='vscodium'
fi

devvm() {
  local infra=~/git/shotor2/infra
  PATH="$(mise -C "$infra" where node)/bin:$PATH" "$infra/ansible/.venv/bin/devvm" "$@"
}

c() {
  {
    printf '$'
    printf ' %q' "$@"
    printf '\n'
    "$@" 2>&1
  } | tee >(wl-copy)
}
