#!/usr/bin/env bash
# set -e

# export CC=i686-w64-mingw32-gcc     # x86
# export CC_FOR_windows_amd64=x86_64-w64-mingw32-gcc # x86_64

# export CXX=i686-w64-mingw32-g++     # x86
# export CXX_FOR_windows_amd64=x86_64-w64-mingw32-g++ # x86_64

# /mingw32/bin #x86
# /mingw64/bin #x86_64


# [variable]
VERSION=v1.5.0
ROOT=$(pwd)
DIR_SOURCE=${ROOT}/zstd/lib
DIR_OUTPUT=${ROOT}/output


# [src] libsodium
git clone -b ${VERSION} --depth 1 https://github.com/facebook/zstd.git && cd $DIR_SOURCE

# compile
make clean
make libzstd

# copy
libzstd_fpath=dll/libzstd.dll

ls -al dll

mkdir -p ${DIR_OUTPUT}
cp ${libzstd_fpath} ${DIR_OUTPUT}/libzstd.dll

ls -al ${DIR_OUTPUT}

# zip -r lib.zip libsodium/.libs/*
