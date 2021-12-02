#!/usr/bin/env bash
set -e

# [variable]
VERSION=v1.5.0
ROOT=$(pwd)
DIR_SOURCE=${ROOT}/zstd/build/cmake
DIR_OUTPUT=${ROOT}/output

#---------------------------------------------------------------------------------------------
# for Apple©
#---------------------------------------------------------------------------------------------
# DEVELOPER=$(xcode-select -print-path)
# TOOLCHAIN_BIN="${DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin"
# export CC="${TOOLCHAIN_BIN}/clang"
# export AR="${TOOLCHAIN_BIN}/ar"
# export RANLIB="${TOOLCHAIN_BIN}/ranlib"
# export STRIP="${TOOLCHAIN_BIN}/strip"
# export LIBTOOL="${TOOLCHAIN_BIN}/libtool"
# export NM="${TOOLCHAIN_BIN}/nm"
# export LD="${TOOLCHAIN_BIN}/ld"

# [src] zstd
git clone -b ${VERSION} --depth 1 https://github.com/facebook/zstd.git
cd ${DIR_SOURCE}

# add BUNDLE DESTINATION - this had been fixed dev branch but not v1.5.0
sed -i '' 's|install(TARGETS zstd RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}")|install(TARGETS zstd RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}" BUNDLE DESTINATION "${CMAKE_INSTALL_BINDIR}")|' programs/CMakeLists.txt

# use leetal/ios-cmake : https://github.com/leetal/ios-cmake
mkdir ios && cd ios
wget https://raw.githubusercontent.com/leetal/ios-cmake/master/ios.toolchain.cmake

# compile
cmake .. -G Xcode -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake -DPLATFORM=OS64COMBINED
echo '0'
cmake --build . --config Release
echo '1'
ls -al lib/
echo '2'
ls -al ${ROOT}/zstd/build/
echo '3'
ls -al ${ROOT}/zstd/
echo '4'
mv lib/ ${DIR_OUTPUT}/iOS
rm -rf lib/

# cmake .. -G Xcode -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake -DPLATFORM=TVOSCOMBINED
# make lib-mt
# ls -al lib/
# mv lib/ ${DIR_OUTPUT}/tvOS
# rm -rf lib/

# cmake .. -G Xcode -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake -DPLATFORM=WATCHOSCOMBINED
# make lib-mt
# ls -al lib/
# mv lib/ ${DIR_OUTPUT}/watchOS
# rm -rf lib/

# cmake .. -G Xcode -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake -DPLATFORM=MAC
# make lib-mt
# ls -al lib/