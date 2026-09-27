#!/bin/sh
# writes the ldap maps from the environment, so the bind password is never in a file the image carries, then runs
# postfix in the foreground. A mailbox is a member of the mail group with a mail address; an alias is one of its
# mailAlternateAddress values, '@domain' among them being a catch-all, postfix's own fallback lookup
set -eu

if [ -n "${MAIL_LDAP_URI:-}" ]; then
  member="(&(objectClass=person)(memberOf=${MAIL_LDAP_GROUP}))"
  map() {
    printf 'server_host = %s\nsearch_base = %s\nversion = 3\nscope = sub\nbind = yes\nbind_dn = %s\nbind_pw = %s\nquery_filter = %s\nresult_attribute = mail\n' \
      "$MAIL_LDAP_URI" "$MAIL_LDAP_BASE" "$MAIL_LDAP_BIND_DN" "$MAIL_LDAP_PASSWORD" "$2" > "/etc/postfix/ldap/$1.cf"
  }
  map users        "(&${member}(mail=%s))"
  map aliases      "(&${member}(mailAlternateAddress=%s))"
  # who may send as an address: the mailbox itself, or the owner of the alias
  map sender-login "(&${member}(|(mail=%s)(mailAlternateAddress=%s)))"
  chown root:postfix /etc/postfix/ldap/*.cf
  chmod 0640 /etc/postfix/ldap/*.cf
fi

exec postfix start-fg
