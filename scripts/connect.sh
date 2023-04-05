# sudo is required here as I am using WSL
sudo ssh ubuntu@$(terraform output -raw public_ip) -i ./keys/primary_server.pem
