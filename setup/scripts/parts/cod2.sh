s3_bucket_name=$1
s3_bucket_region=$2
aws_access_key_id=$3
aws_secret_access_key=$4

START='\033[0;36m' # cyan
PART='\033[0;34m' # blue
DONE='\033[0;32m' # green
WARN='\033[0;33m' # yellow
NC='\033[0m' # no color

# Create CoD2 directories
if [[ -d ~/cod2/main ]] && [[ -d ~/cod2/Library ]]; then
    echo -e "${DONE}CoD2 directories already created.${NC}"
else
    echo -e "${START}Creating CoD2 directories...${NC}"
    mkdir -p ~/cod2/main
    mkdir -p ~/cod2/Library
    echo -e "${DONE}Creating CoD2 directories... done${NC}"
fi

# Move servers directory
if [[ -d ~/cod2/servers ]]; then 
    echo -e "${DONE}Servers directory already moved.${NC}"
elif [[ -d ~/servers/ ]]; then
    echo -e "${START}Moving servers directory...${NC}"
    mv ~/servers ~/cod2
    echo -e "${DONE}Moving servers directory... done${NC}"
else
    echo -e "${WARN}Skipping moving servers directory, because ~/servers is missing.${NC}"
fi

# Sync server files
if [[ -f ~/cod2/main/1_0/iw_00.iwd ]]; then 
    echo -e "${DONE}Base server files already synced.${NC}"
elif [[ -z "${s3_bucket_name}" ]] || [[ -z "${s3_bucket_region}" ]] || [[ -z "${aws_access_key_id}" ]] || [[ -z "${aws_secret_access_key}" ]]; then
    echo -e "${WARN}Skipping syncing base server files, because some arguments are missing.${NC}"
    echo "s3_bucket_name: ${s3_bucket_name}"
    echo "s3_bucket_region: ${s3_bucket_region}"
    echo "aws_access_key_id: ${aws_access_key_id}"
    echo "aws_secret_access_key: ${aws_secret_access_key}"
else
    echo -e "${START}Syncing server files...${NC}"

    export AWS_ACCESS_KEY_ID=$aws_access_key_id
    export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key
    echo -e "${PART} - set env AWS credentials${NC}"

    aws s3 sync $s3_bucket_name ~/cod2/main --region=$s3_bucket_region 1> /dev/null
    echo -e "${PART} - files synced${NC}"

    export AWS_ACCESS_KEY_ID=""
    export AWS_SECRET_ACCESS_KEY=""
    echo -e "${PART} - unset env AWS credentials${NC}"

    echo -e "${DONE}Syncing server files... done"
fi

# Copy server base files
function copy_server_base_files {
    if [[ -f ~/cod2/main/$1/iw_00.iwd ]]; then
        echo -e "${DONE}$1 server files already setup.${NC}"
    elif [[ -d ~/cod2/main/"$1"/ ]]; then
        echo -e "${START}Copying base files to $1...${NC}"
        cp ~/cod2/main/1_0/* ~/cod2/main/"$1"/
        echo -e "${DONE}Copying base files to $1... done${NC}"
    else
        echo -e "${WARN}Skipping $1 server files setup, because ~/cod2/main/$1/ is missing.${NC}"
    fi
}

copy_server_base_files 1_2
copy_server_base_files 1_3
