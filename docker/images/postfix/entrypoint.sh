#!/bin/sh
# writes the ldap maps from the environment, so the bind password is never in a file the image carries, then runs
# postfix in the foreground. Every public address is an alias, a mailAlternateAddress value of a member of the mail
# group, '@domain' among them being a catch-all, postfix's own fallback lookup; it resolves to the member's uid in the
# private mailbox domain, which is where postfix delivers and which nobody outside can address. A member without an
# alias receives nothing and may send as nothing
set -eu

if [ -n "${MAIL_LDAP_URI:-}" ]; then
  member="(&(objectClass=person)(memberOf=${MAIL_LDAP_GROUP}))"
  map() {
    printf 'server_host = %s\nsearch_base = %s\nversion = 3\nscope = sub\nbind = yes\nbind_dn = %s\nbind_pw = %s\nresult_attribute = uid\n%s\nquery_filter = %s\n' \
      "$MAIL_LDAP_URI" "$MAIL_LDAP_BASE" "$MAIL_LDAP_BIND_DN" "$MAIL_LDAP_PASSWORD" "$3" "$2" > "/etc/postfix/ldap/$1.cf"
  }
  map aliases "(&${member}(mailAlternateAddress=%s))" "result_format = %s@${MAIL_MAILBOX_DOMAIN}"
  # the mailbox domain alone, so %u is only ever a uid
  map users   "(&${member}(uid=%u))"                  "domain = ${MAIL_MAILBOX_DOMAIN}"
  # who may send as an address: the owner of the alias, by login name
  map senders "(&${member}(mailAlternateAddress=%s))" "result_format = %s"
  chown root:postfix /etc/postfix/ldap/*.cf
  chmod 0640 /etc/postfix/ldap/*.cf
fi

exec postfix start-fg
