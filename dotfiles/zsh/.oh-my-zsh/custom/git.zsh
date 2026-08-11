gitshotor() {
  git config user.name "shotor"
  git config user.email "shotor@shotor.com"
  git config gpg.format ssh
  git config user.signingkey ~/.ssh/shotor_id_ed25519.pub
  git config commit.gpgsign true
  git config tag.gpgSign true
}
