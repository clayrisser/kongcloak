#!/bin/sh

alias psql_authed='PGPASSWORD=$KONG_PG_PASSWORD psql -h "$KONG_PG_HOST" -U "$KONG_PG_USER" -p "$KONG_PG_PORT"'
until psql_authed -c '\l' &>/dev/null; do
  echo "waiting for postgres"
  sleep 1
done
if [ ! $(psql_authed -l | cut -d \| -f 1 | grep -w $KONG_PG_DATABASE) ]; then
  psql_authed -c "CREATE DATABASE $KONG_PG_DATABASE;"
fi
/docker-entrypoint.sh kong migrations up

exec /docker-entrypoint.sh "$@"
