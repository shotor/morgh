alias ls='lsd'

alias DOITNOW='gaa && gcn! && gpf'

if ! command -v code >/dev/null 2>&1; then
  alias code='vscodium'
fi

c() {
  {
    printf '%q' "$@"
    printf '\n'
    "$@" 2>&1
  } | tee >(wl-copy)
}
