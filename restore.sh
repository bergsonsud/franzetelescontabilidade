sudo docker exec -ti "CONTAINER_ID" psql -U postgres -h localhost -c 'CREATE DATABASE "da6prie91o0c0d";'
echo "Restore database"
sudo docker exec -ti "CONTAINER_ID" pg_restore -d da6prie91o0c0d da6prie91o0c0d.dump