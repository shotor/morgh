gitshotor() {
  git config user.name "shotor"
  git config user.email "shotor@shotor.com"
  git config gpg.format ssh
  # quoted: git expands ~ itself, the shell's expansion writes this machine's home
  # into the checkout, which devvm pull/sync carries to the other one
  git config user.signingkey '~/.ssh/shotor_id_ed25519.pub'
  git config commit.gpgsign true
  git config tag.gpgSign true

  git config sendemail.smtpServer smtp.fastmail.com
  git config sendemail.smtpServerPort 465
  git config sendemail.smtpEncryption ssl
  git config sendemail.smtpUser shotor@shotor.com
  git config sendemail.from shotor@shotor.com
}
