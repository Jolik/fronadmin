FROM debian:bookworm-slim
RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates libstdc++6 libgcc-s1 libzstd1 zlib1g libcurl4 \
    ; rm -rf /var/lib/apt/lists/*
COPY --chmod=0755 ./opt/FrontDCC /opt/app
COPY ./etc/fmsoft /etc/fmsoft
EXPOSE 8077
STOPSIGNAL SIGINT
ENTRYPOINT ["/opt/app"]
