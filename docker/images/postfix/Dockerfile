FROM debian:13-slim
# postfix with the ldap map type; the ca bundle verifies the world's mx certificates when they offer tls
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends postfix postfix-ldap ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /etc/postfix/ldap
COPY entrypoint.sh /entrypoint.sh
# main.cf and master.cf are mounted per role; the ldap maps are written at start from the environment
ENTRYPOINT ["/entrypoint.sh"]
