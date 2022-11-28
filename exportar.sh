export PGHOST=''
export PGUSER=''
export PGPASSWORD=''
export PGPORT=5432

cd /usr/bin
pg_dump  postgres://${PGUSER}:${PGPASSWORD}@${PGHOST}:${PGPORT}/da6prie91o0c0d  -F c -f /da6prie91o0c0d.dump