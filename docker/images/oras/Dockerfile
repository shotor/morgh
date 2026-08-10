ARG VERSION=1.3.3

FROM alpine:3.24 AS download

ARG VERSION
ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache curl tar \
    && curl -fsSL \
        "https://github.com/oras-project/oras/releases/download/v${VERSION}/oras_${VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" \
        -o /tmp/oras.tar.gz \
    && mkdir /tmp/oras \
    && tar -xzf /tmp/oras.tar.gz -C /tmp/oras


FROM alpine:3.24

RUN apk add --no-cache ca-certificates

COPY --from=download /tmp/oras/oras /usr/local/bin/oras

ENTRYPOINT ["oras"]
