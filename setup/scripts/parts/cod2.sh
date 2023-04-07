# Create CoD2 directories
echo "Creating CoD2 directories..."
mkdir ~/.callofduty2
mkdir ~/cod2
mkdir ~/cod2/main
mkdir ~/cod2/servers
mkdir ~/cod2/Library
echo "Creating CoD2 directories... done"

# Sync server files
echo "Syncing server files..."
aws s3 sync --quiet $1 ~/cod2/main
echo "Syncing server files... done"

# Copy base files
echo "Copying base files to 1_3..."
cp ~/cod2/main/1_0/* ~/cod2/main/1_3/
echo "Copying base files to 1_3... done"
