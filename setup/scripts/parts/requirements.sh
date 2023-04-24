START='\033[0;36m' # cyan
PART='\033[0;34m' # blue
DONE='\033[0;32m' # green
WARN='\033[0;33m' # yellow
NC='\033[0m' # no color

# Install packages
echo -e "${START}Installing packages...${NC}"
sudo apt-get -qq update
echo -e "${PART} - Done apt-get update${NC}"
sudo apt-get -q -y install docker.io docker-compose unzip
echo -e "${DONE}Installing packages... done${NC}"

# Docker configure
echo -e "${START}Configuring docker...${NC}"
sudo usermod -aG docker ubuntu
echo -e "${PART} - Done add ubuntu user to docker group${NC}"
sudo docker network create my_network
echo -e "${PART} - Done create my_network${NC}"
echo -e "${DONE}Configuring docker... done${NC}"

# Install AWS CLI
echo -e "${START}Installing AWS CLI...${NC}"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
echo -e "${PART} - Done download awscliv2.zip${NC}"
unzip -q awscliv2.zip
echo -e "${PART} - Done unzip awscliv2.zip${NC}"
sudo ./aws/install
echo -e "${PART} - Done install${NC}"
rm awscliv2.zip
echo -e "${PART} - Done remove awscliv2.zip${NC}"
rm -rf aws
echo -e "${PART} - Done remove aws folder${NC}"
echo -e "${DONE}Installing AWS CLI... done${NC}"
