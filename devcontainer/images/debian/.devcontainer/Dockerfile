FROM mcr.microsoft.com/devcontainers/base:debian-13

USER root

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_IE.UTF-8

RUN groupmod -n user vscode \
    && usermod -l user -d /home/user -m vscode

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        locales \
        lsd \
        tmux \
        vim \
        zsh \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "en_IE.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/* \
    && chsh -s /usr/bin/zsh user

RUN curl -fsSL https://starship.rs/install.sh \
    | sh -s -- -y --bin-dir /usr/local/bin

COPY --chown=user:user zshrc /home/user/.zshrc
COPY --chown=user:user install-codium-extensions /home/user/install-codium-extensions

RUN chmod +x /home/user/install-codium-extensions

USER user
WORKDIR /workspace
