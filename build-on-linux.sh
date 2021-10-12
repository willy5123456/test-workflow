#!/usr/bin/env bash
set -e

# [variable]
ROOT=$(pwd)
DIR_DEST=${ROOT}/output


# [src] libsodium
git clone https://github.com/jedisct1/libsodium.git
cd libsodium
git checkout tags/1.0.18

# configure
# ref: https://askubuntu.com/questions/27677/cannot-find-install-sh-install-sh-or-shtool-in-ac-aux
libtoolize --force
aclocal
# autoheader
autoconf
automake --force-missing --add-missing
chmod +x ./configure

# compile
mkdir .libs/
./configure --prefix=`pwd`/.libs/ && make && make install

zip -r lib.zip .libs/*

ls -al