#!/usr/bin/env bash
set -e

# [variable]

# [src] libsodium
git clone https://github.com/jedisct1/libsodium.git && cd libsodium
git checkout tags/1.0.18

# configure
libtoolize --force
aclocal
# autoheader
autoconf
automake --force-missing --add-missing
chmod +x ./configure

# compile
mkdir .libs/
./configure --prefix=`pwd`/.libs/ && make && make install

cd ..
zip -r lib.zip libsodium/.libs/*