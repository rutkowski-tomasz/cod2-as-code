START='\033[0;36m' # cyan
PART='\033[0;34m' # blue
DONE='\033[0;32m' # green
WARN='\033[0;33m' # yellow
NC='\033[0m' # no color

server_address=$(terraform output -raw server_address 2>/dev/null) || true
mysql_root_password=$(terraform output -raw mysql_root_password)

if [ -z "$server_address" ] && [ -z "$COD2_AS_CODE_SERVER_ADDRESS" ]; then
    echo -e "${WARN}Error: Terraform output doesn't contain 'server_address', please set server address env variable${NC}"
    echo -e "${WARN}Example: export COD2_AS_CODE_SERVER_ADDRESS=12.34.56.78${NC}"
    exit
elif [ -z "$server_address" ]; then
    server_address=$COD2_AS_CODE_SERVER_ADDRESS
fi

if [ -z "$mysql_root_password" ] && [ -z "$COD2_AS_CODE_MYSQL_ROOT_PASSWORD" ]; then
    echo -e "${WARN}Error: Terraform output doesn't contain 'mysql_root_password', please mysql root password env variable${NC}"
    echo -e "${WARN}Example: export COD2_AS_CODE_MYSQL_ROOT_PASSWORD=mysecretpassword${NC}"
    exit
elif [ -z "$mysql_root_password" ]; then
    mysql_root_password=$COD2_AS_CODE_MYSQL_ROOT_PASSWORD
fi

mysql -h $server_address -P 3307 -u root -p$mysql_root_password
