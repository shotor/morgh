FROM python:3.14-alpine

RUN apk add --no-cache \
  git

RUN pip install --no-cache-dir commitizen

COPY cz_filter_path /cz_filter_path

RUN pip install --no-cache-dir /cz_filter_path

WORKDIR /workspace
