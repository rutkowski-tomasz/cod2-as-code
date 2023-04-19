# Install packages
echo "Installing packages..."
sudo apt-get -qq update
echo " - Done update"
sudo apt-get -q -y install docker.io docker-compose unzip
echo " - Done package installation"
sudo usermod -aG docker ubuntu
echo " - Done add ubuntu user to docker group"
sudo docker network create my_network
echo " - Done create my_network"
echo "Installing packages... done"

# Install AWS CLI
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
echo " - Done download awscliv2.zip"
unzip -q awscliv2.zip
echo " - Done unzip awscliv2.zip"
sudo ./aws/install
echo " - Done install"
rm awscliv2.zip
echo " - Done remove awscliv2.zip"
rm -rf aws
echo " - Done remove aws folder"
echo "Installing AWS CLI... done"
