# renovate: datasource=pypi depName=knot-exporter
ARG VERSION=3.6.2

FROM cznic/knot:v${VERSION}

ARG VERSION

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3 python3-venv \
    && rm -rf /var/lib/apt/lists/* \
    && python3 -m venv /opt/knot-exporter \
    && /opt/knot-exporter/bin/pip install --no-cache-dir "knot-exporter==${VERSION}" "libknot==${VERSION}"

USER knot

EXPOSE 9433

ENTRYPOINT ["/opt/knot-exporter/bin/knot-exporter"]
