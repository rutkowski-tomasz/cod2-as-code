# Sync S3
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws s3 sync $1 ~/cod2/main

function install_link {
	ln -s ~/cod2/main/1_0/* ~/cod2_1_0/main/
	if [ "$1" != "1_0" ]
	then
		ln -s ~/cod2/main/"$1"/* ~/cod2_"$1"/main/
	fi	
	echo "done main files for $1"
}

# main files link
install_link 1_0
install_link 1_2
install_link 1_3
