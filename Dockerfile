FROM debian:bookworm-slim AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV NODERED_VERSION=4.0.5

RUN apt update \
    && apt -y upgrade \
    && apt install -y --no-install-recommends \
        nodejs \
        npm \
        openssl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/node-red /data

WORKDIR /opt/node-red

FROM base AS builder

RUN npm i --unsafe-perm \
    --no-progress \
    --no-update-notifier \
    --no-audit \
    --no-fund \
    --loglevel=error \
    node-red@"$NODERED_VERSION"

FROM base AS release

COPY --from=builder /opt/node-red/node_modules ./node_modules

EXPOSE 1880

ENTRYPOINT ["/bin/nodejs", "node_modules/node-red/red.js", "--userDir", "/data"]
