export MYSQL_ROOT_PASSWORD=$1
export DOMAIN=$2
export EMAIL=$3

START='\033[0;36m' # cyan
PART='\033[0;34m' # blue
DONE='\033[0;32m' # green
WARN='\033[0;33m' # yellow
NC='\033[0m' # no color

echo -e "${START}Running envsubst for *.envsubst files...${NC}"
for file in $(find ~/ -type f -name '*.envsubst'); do
    envsubst '${MYSQL_ROOT_PASSWORD} ${DOMAIN} ${EMAIL}' < $file > tmp
    echo -e "${PART} - envsubst for $file${NC}"
    rm $file
    newfile=${file::-9}
    mv tmp $newfile
    echo -e "${PART} - moved envsubst'ed file to $newfile${NC}"
done
echo -e "${DONE}Running envsubst for *.envsubst files... done${NC}"

export MYSQL_ROOT_PASSWORD=""
export DOMAIN=""
export EMAIL=""