FROM kong:0.14.1-alpine

LABEL image=codejamninja/kong-oidc:latest \
  maintainer="Jam Risser <jam@codejam.ninja>" \
  base=alpine:3.6

WORKDIR /

RUN apk add --no-cache \
  postgresql-client \
  tini
RUN luarocks install kong-oidc

COPY entrypoint.sh /usr/local/sbin/entrypoint.sh

RUN chmod +x /usr/local/sbin/entrypoint.sh

ENV KONG_ADMIN_ACCESS_LOG=/dev/stdout \
  KONG_ADMIN_ERROR_LOG=/dev/stderr \
  KONG_ADMIN_LISTEN="0.0.0.0:8001, 0.0.0.0:8444 ssl" \
  KONG_DATABASE=postgres \
  KONG_PG_DATABASE=postgres \
  KONG_PG_HOST=postgres \
  KONG_PG_PORT=5432 \
  KONG_PLUGINS=oidc \
  KONG_PROXY_ACCESS_LOG=/dev/stdout \
  KONG_PROXY_ERROR_LOG=/dev/stderr \
  KONG_PROXY_LISTEN="0.0.0.0:8000, 0.0.0.0:8443 ssl"

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/sbin/entrypoint.sh"]
CMD ["kong", "docker-start"]
