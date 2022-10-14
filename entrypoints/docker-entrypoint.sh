#!/bin/sh

set -e

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

if [ -f /tmp/pids/server.pid ]; then
  rm /tmp/pids/server.pid
fi
bin/rails server -b 0.0.0.0 -p 3000 -e development