./scripts/sync_server.sh myserver
ssh -i ~/.ssh/$KEYNAME ubuntu@$SERVER "cd ~/servers/docker-compose/myserver && docker-compose down && docker-compose up"
