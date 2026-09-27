#!/bin/sh
# writes the ldap maps from the environment, so the bind password is never in a file the image carries, then runs
# postfix in the foreground. Every public address is an alias, a value of MAIL_LDAP_ALIAS_ATTRIBUTE on a member of the
# mail group or of the noreply group, '@domain' among them being a catch-all, postfix's own fallback lookup. A mail
# member's alias resolves to its uid in the private mailbox domain, where postfix delivers and which nobody outside can
# address; a noreply member's alias is accepted and discarded. Both may send as their aliases. A member without an alias
# receives nothing and may send as nothing
set -eu

if [ -n "${MAIL_LDAP_URI:-}" ]; then
  member="(&(objectClass=person)(memberOf=${MAIL_LDAP_GROUP}))"
  noreply="(&(objectClass=person)(memberOf=${MAIL_LDAP_NOREPLY_GROUP}))"
  sender="(&(objectClass=person)(|(memberOf=${MAIL_LDAP_GROUP})(memberOf=${MAIL_LDAP_NOREPLY_GROUP})))"
  alias="${MAIL_LDAP_ALIAS_ATTRIBUTE:-mailAlternateAddress}"
  map() {
    printf 'server_host = %s\nsearch_base = %s\nversion = 3\nscope = sub\nbind = yes\nbind_dn = %s\nbind_pw = %s\nresult_attribute = uid\n%s\nquery_filter = %s\n' \
      "$MAIL_LDAP_URI" "$MAIL_LDAP_BASE" "$MAIL_LDAP_BIND_DN" "$MAIL_LDAP_PASSWORD" "$3" "$2" > "/etc/postfix/ldap/$1.cf"
  }
  map aliases "(&${member}(${alias}=%s))"  "result_format = %s@${MAIL_MAILBOX_DOMAIN}"
  # the mailbox domain alone, so %u is only ever a uid
  map users   "(&${member}(uid=%u))"       "domain = ${MAIL_MAILBOX_DOMAIN}"
  # an access map: mail to a noreply member's alias is claimed and dropped
  map noreply "(&${noreply}(${alias}=%s))" "result_format = DISCARD"
  # who may send as an address: the owner of the alias, by login name, in either group
  map senders "(&${sender}(${alias}=%s))"  "result_format = %s"
  chown root:postfix /etc/postfix/ldap/*.cf
  chmod 0640 /etc/postfix/ldap/*.cf
fi

exec postfix start-fg
