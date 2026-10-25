if personal_ssh_socket=$(fido-socket 2>/dev/null); then
  SSH_AUTH_SOCK=$personal_ssh_socket
  export SSH_AUTH_SOCK
fi
unset personal_ssh_socket
