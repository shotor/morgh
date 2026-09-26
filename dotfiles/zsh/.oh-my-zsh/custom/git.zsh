gitshotor() {
  git config user.name "shotor"
  git config user.email "shotor@shotor.com"
  git config gpg.format ssh
  git config user.signingkey "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDmyJfbxkoZuv1owYO1hiV60bE65mIkw7RGDmKtNicpy shotor@shotor.com"
  git config commit.gpgsign true
  git config tag.gpgSign true

  git config sendemail.smtpServer smtp.fastmail.com
  git config sendemail.smtpServerPort 465
  git config sendemail.smtpEncryption ssl
  git config sendemail.smtpUser shotor@shotor.com
  git config sendemail.from shotor@shotor.com
}

