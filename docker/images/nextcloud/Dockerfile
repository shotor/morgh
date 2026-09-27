FROM nextcloud:34.0.3-apache

# the imagick extras package is named per imagemagick major; resolved from the base image's index
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        supervisor \
        "$(apt-cache search --names-only '^libmagickcore-.*-extra$' | cut -d' ' -f1 | sort | head -n1)" \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/log/supervisord /var/run/supervisord \
    && chown -R 9000:9000 /var/log/supervisord /var/run/supervisord

# apache and cron under one supervisor, the pod runs as 9000
COPY supervisord.conf /

# php validates the fleet's certificates on self-calls against the system store
COPY root_ca.crt /usr/local/share/ca-certificates/internal-root.crt
RUN update-ca-certificates

ENV NEXTCLOUD_UPDATE=1
CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
