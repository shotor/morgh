alias ls='lsd'

alias DOITNOW='gaa && gcn! && gpf'

if ! command -v code >/dev/null 2>&1; then
  alias code='vscodium'
fi

tmrec() {
  [ -n "$TMUX" ] || { echo 'tmrec: not in tmux' >&2; return 1; }
  tmux pipe-pane -o 'f=$HOME/tmux-#S-#I-#P.log; cat > "$f"; sed "s/\x1b\[[0-9;?]*[a-zA-Z]//g; s/\r//g" "$f" | wl-copy'
  tmux display-message 'tmrec toggled'
}

mediamount() { mkdir -p ~/mnt/media && sshfs -o reconnect,ServerAliveInterval=15,idmap=user media@zurvan.files.mon.shotor.foo:/srv/media ~/mnt/media; }
alias mediaumount='fusermount3 -u ~/mnt/media'

c() {
  {
    printf '$'
    printf ' %q' "$@"
    printf '\n'
    "$@" 2>&1
  } | tee >(wl-copy)
}
