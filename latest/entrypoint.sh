#!/bin/sh

sleep 5
if [ ! $(psql -h "$KONG_PG_HOST" -U "$KONG_PG_USER" -l | cut -d \| -f 1 | grep -w $KONG_PG_DATABASE) ]; then
  psql -h "$KONG_PG_HOST" -U "$KONG_PG_USER" -c "CREATE DATABASE $KONG_PG_DATABASE;"
fi
if [ ! $(psql -h "$KONG_PG_HOST" -U "$KONG_PG_USER" -c "\c $KONG_PG_DATABASE" -c "\dt" | cut -d \| -f 2 | grep -w profiles) ]; then
  /docker-entrypoint.sh kong migrations up
fi

exec /docker-entrypoint.sh "$@"
