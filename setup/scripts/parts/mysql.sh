export MYSQL_ROOT_PASSWORD=$1

envsubst < ~/lamp/docker-compose.yml > ~/lamp/tmpfile
mv ~/lamp/tmpfile ~/lamp/docker-compose.yml

export MYSQL_ROOT_PASSWORD=""
