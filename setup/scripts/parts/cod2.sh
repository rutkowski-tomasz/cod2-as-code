# Create CoD2 directories
echo "Creating CoD2 directories..."
mkdir ~/.callofduty2
mkdir ~/cod2
mkdir ~/cod2/main
mkdir ~/cod2/Library
mkdir ~/cod2/fastdl
echo "Creating CoD2 directories... done"

# Sync server files
echo "Syncing server files..."
aws s3 sync --quiet $1 ~/cod2/main
echo "Syncing server files... done"

# Copy base files
echo "Copying base files to 1_3..."
cp ~/cod2/main/1_0/* ~/cod2/main/1_3/
echo "Copying base files to 1_3... done"

echo "Setting MYIP in configs..."
MYIP=$(curl api.ipify.org)
echo " - Resolved IP to $MYIP"
for file in $(find ~/servers -type f -name '*.cfg'); do
    sed -i "s/MYIP/$MYIP/g" $file
    cat $file | grep sv_wwwBaseURL
done
echo "Setting MYIP in configs... done"
