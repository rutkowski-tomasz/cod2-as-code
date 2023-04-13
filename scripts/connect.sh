sudo cp ./keys/private_key.pem ~/.ssh/
chmod 400 ~/.ssh/private_key.pem
ssh ubuntu@$(terraform output -raw public_ip) -i ~/.ssh/private_key.pem
