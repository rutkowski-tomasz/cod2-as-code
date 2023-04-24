export MYSQL_ROOT_PASSWORD=$1
export DOMAIN=$2

echo "Running envsubst for *.envsubst files..."
for file in $(find ~/setup -type f -name '.envsubst'); do
    envsubst '${MYSQL_ROOT_PASSWORD} ${DOMAIN}' < $file > tmp
    echo " - envsubst for $file"
    rm $file
    newfile=${file::-9}
    mv tmp $newfile
    echo " - moved envsubst'ed file to $newfile"
    cat $file | grep sv_wwwBaseURL
done
echo "Running envsubst for *.envsubst files... done"

export MYSQL_ROOT_PASSWORD=""
export DOMAIN=""