function install_folders {
	mkdir ~/cod2/main/"$1"
	mkdir ~/cod2_"$1"
	mkdir ~/cod2_"$1"/main
}

# create main folders
mkdir ~/.callofduty2
mkdir ~/cod2
mkdir ~/cod2/main
mkdir ~/cod2/servers
mkdir ~/cod2/Library

# create versions folders
install_folders 1_0
install_folders 1_2
install_folders 1_3
