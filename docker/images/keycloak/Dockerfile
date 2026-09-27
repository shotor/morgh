# keycloak with radicallyopensecurity's app passwords: the extension jar built from a pinned commit against the same
# keycloak version, the account theme that manages them, and the extension's config
ARG KEYCLOAK_VERSION=26.7.4

FROM maven:3.9-eclipse-temurin-17 AS source
ARG REF=20e8dfa7f963910bd959f55769164fd573c0a733
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/* \
 && git clone https://github.com/radicallyopensecurity/keycloak-app-passwords /src \
 && git -C /src checkout --quiet "$REF"

# the jar is named after the extension's version; the shade plugin leaves an original- copy beside it
FROM source AS extension
ARG KEYCLOAK_VERSION
WORKDIR /src/extension
RUN mvn --quiet --batch-mode -DskipTests "-Dkeycloak.version=$KEYCLOAK_VERSION" clean package \
 && cp target/keycloak-app-passwords-[0-9]*.jar /keycloak-app-passwords.jar

# keycloakify needs maven and java beside node for the theme jar
FROM node:22-bookworm AS theme
RUN apt-get update && apt-get install -y --no-install-recommends maven && rm -rf /var/lib/apt/lists/*
COPY --from=source /src /src
WORKDIR /src/theme
RUN npm ci && npm run build-keycloak-theme

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}
COPY --from=extension /keycloak-app-passwords.jar /opt/keycloak/providers/keycloak-app-passwords.jar
COPY --from=theme /src/theme/dist_keycloak/keycloak-theme-for-kc-all-other-versions.jar /opt/keycloak/providers/keycloak-app-passwords-theme.jar
COPY keycloak-app-passwords.config.json /opt/keycloak/providers/keycloak-app-passwords.config.json
# the same build options the cluster starts it with, so start needs no rebuild
ENV KC_DB=postgres \
    KC_FEATURES=authorization:v1,hostname:v2,scripts:v1,opentelemetry:v1 \
    KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true
RUN /opt/keycloak/bin/kc.sh build
