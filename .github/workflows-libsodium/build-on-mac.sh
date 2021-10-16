#!/usr/bin/env bash
set -e

readonly IOS_MIN_VERSION=6.0

# ===========================
# macOs, iOs
# ===========================
# [brew] install dependencies
# packages='libtool autoconf automake'
# brew update
# for pkg in ${packages}; do
#     if brew list -1 | grep -q "^${pkg}\$"; then
#         echo "Package '$pkg' is installed"
#         #brew upgrade $pkg
#     else
#         echo "Package '$pkg' is not installed"
#         brew install $pkg
#     fi
# done
# brew upgrade ${packages} || true


# [variable]
ROOT=$(pwd)
DIR_DEST=${ROOT}/output
DIR_LIBSODIUM=${ROOT}/libsodium


# [src] libsodium
git clone https://github.com/jedisct1/libsodium.git $DIR_LIBSODIUM && cd $DIR_LIBSODIUM
git checkout tags/1.0.18

# configure
./autogen.sh


# [generate]
cd $DIR_LIBSODIUM

git clean -Xdf
./autogen.sh
./dist-build/ios.sh
mkdir -p $DIR_DEST/Plugins/iOS
cp $DIR_LIBSODIUM/libsodium-ios/lib/libsodium.a $DIR_DEST/Plugins/iOS/libsodium.a
ls -al $DIR_DEST/Plugins/iOS


git clean -Xdf
./autogen.sh
./dist-build/osx.sh
mkdir -p $DIR_DEST/Plugins/x64
cp $DIR_LIBSODIUM/libsodium-osx/lib/libsodium.*.dylib $DIR_DEST/Plugins/x64/sodium.bundle
ls -al $DIR_DEST/Plugins/x64