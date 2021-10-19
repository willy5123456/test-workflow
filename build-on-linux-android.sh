#!/usr/bin/env bash
set -e

# [variable]
VERSION=v4.4.3
ROOT=$(pwd)
DIR_SOURCE=${ROOT}/sqlcipher
DIR_OUTPUT=${ROOT}/output

# [src] openssl
OEPNSSL_VERSION=OpenSSL_1_1_1l
git clone -b ${OEPNSSL_VERSION} --depth 1 https://github.com/openssl/openssl && cd openssl

MINIMUM_ANDROID_SDK_VERSION=16
MINIMUM_ANDROID_64_BIT_SDK_VERSION=21
OPENSSL_CONFIGURE_OPTIONS="-fPIC -fstack-protector-all no-idea no-camellia \
 no-seed no-bf no-cast no-rc2 no-rc4 no-rc5 no-md2 \
 no-md4 no-ecdh no-sock no-ssl3 \
 no-dsa no-dh no-ec no-ecdsa no-tls1 \
 no-rfc3779 no-whirlpool no-srp \
 no-mdc2 no-ecdh no-engine \
 no-srtp
"

CONFIGURE_ARCH="android-arm -march=armv7-a"
ANDROID_API_VERSION=${MINIMUM_ANDROID_SDK_VERSION}
OFFSET_BITS=32

TOOLCHAIN_SYSTEM=linux-x86_64
TOOLCHAIN_BIN_PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/${TOOLCHAIN_SYSTEM}/bin
PATH=${TOOLCHAIN_BIN_PATH}:${PATH} ./Configure ${CONFIGURE_ARCH} \
 -D__ANDROID_API__=${ANDROID_API_VERSION} \
 -D_FILE_OFFSET_BITS=${OFFSET_BITS} \
 ${OPENSSL_CONFIGURE_OPTIONS}

make clean
PATH=${TOOLCHAIN_BIN_PATH}:${PATH} make build_libs

mkdir -p ${DIR_OUTPUT}
mv libcrypto.a ${DIR_OUTPUT}

ls -al ${DIR_OUTPUT}
exit 1

# [src] libsodium
git clone -b ${VERSION} --depth 1 https://github.com/sqlcipher/sqlcipher.git && cd $DIR_SOURCE


# configure
./configure -enable-tempstore=no --disable-tcl CFLAGS="-DSQLITE_HAS_CODEC -DSQLCIPHER_CRYPTO_OPENSSL"

# compile
make clean
make sqlite3.c
make

# copy
libsqlcipher_fpath=`readlink -f .libs/libsqlcipher.so`
libcrypto_fpath=`readlink -f /usr/lib/x86_64-linux-gnu/libcrypto.so`

mkdir -p ${DIR_OUTPUT}
cp ${libsqlcipher_fpath} ${DIR_OUTPUT}/libsqlcipher.so
cp ${libcrypto_fpath} ${DIR_OUTPUT}/libcrypto.so

# zip -r lib.zip libsodium/.libs/*
ls -al ${DIR_OUTPUT}