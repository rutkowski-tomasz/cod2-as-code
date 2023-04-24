s3_bucket_name=$1
s3_bukcet_region=$2

# Create CoD2 directories
echo "Creating CoD2 directories..."
mkdir -p ~/cod2/main
mkdir ~/cod2/Library
echo "Creating CoD2 directories... done"

# Move servers directory
echo "Moving servers directory..."
mv ~/setup/servers ~/cod2
echo "Moving servers directory..."

# Sync server files
echo "Syncing server files..."
aws s3 sync $s3_bucket_name ~/cod2/main --region=$s3_bukcet_region 1> /dev/null
echo "Syncing server files... done"

# Copy base files
echo "Copying base files to 1_3..."
cp ~/cod2/main/1_0/* ~/cod2/main/1_3/
echo "Copying base files to 1_3... done"
