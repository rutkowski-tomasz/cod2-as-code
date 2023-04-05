#!/bin/bash

# libcod
cd ~/cod2 || { echo "Error! libcod.sh line 4"; exit 1; }
git clone https://github.com/voron00/libcod
# git clone https://github.com/ibuddieat/zk_libcod
# cd zk_libcod || { echo "Error! libcod.sh line 6"; exit 1; }
cd libcod || { echo "Error! libcod.sh line 7"; exit 1; }

# Make zk_libcod build non-interactive
# sed '16,24d' doit.sh > tmpfile
# mv tmpfile doit.sh
# sed "16 i \ \ \ \ key=\'2\'" doit.sh > tmpfile
# mv tmpfile doit.sh
# Make zk_libcod build non-interactive

chmod +x doit.sh

./doit.sh cod2_1_0
mv bin/libcod2_1_0.so ~/cod2_1_0/libcod2_1_0.so
./doit.sh clean
echo "done libcod for 1.0"

./doit.sh cod2_1_2
mv bin/libcod2_1_2.so ~/cod2_1_2/libcod2_1_2.so
./doit.sh clean
echo "done libcod for 1.2"

./doit.sh cod2_1_3
mv bin/libcod2_1_3.so ~/cod2_1_3/libcod2_1_3.so
./doit.sh clean
echo "done libcod for 1.3"
