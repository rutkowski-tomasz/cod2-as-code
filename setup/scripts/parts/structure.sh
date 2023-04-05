function install_folders {
	mkdir ~/cod2/main/"$1"
	mkdir ~/cod2_"$1"
	mkdir ~/cod2_"$1"/main
}

function install_lnxded {
	cp ~/setup/cod2_lnxded/"$1"/cod2_lnxded ~/cod2_"$1"/cod2_lnxded
	chmod 500 ~/cod2_"$1"/cod2_lnxded
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

# lnxded
install_lnxded 1_0
install_lnxded 1_2
install_lnxded 1_3
