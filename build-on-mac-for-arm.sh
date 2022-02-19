#!/usr/bin/env bash
set -e

# [variable]
readonly ROOT_ROOT=`pwd`
readonly BUILD_DIR="${ROOT_ROOT}/build/macos"
readonly LIB_DIR="${ROOT_ROOT}/lib/macos"


#---------------------------------------------------------------------------------------------
# for Apple©
#---------------------------------------------------------------------------------------------
DEVELOPER=$(xcode-select -print-path)
TOOLCHAIN_BIN="${DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin"
export CC="${TOOLCHAIN_BIN}/clang"
export AR="${TOOLCHAIN_BIN}/ar"
export RANLIB="${TOOLCHAIN_BIN}/ranlib"
export STRIP="${TOOLCHAIN_BIN}/strip"
export LIBTOOL="${TOOLCHAIN_BIN}/libtool"
export NM="${TOOLCHAIN_BIN}/nm"
export LD="${TOOLCHAIN_BIN}/ld"

git clone https://github.com/webmproject/libwebp.git
cd libwebp
git checkout v1.2.2

OUT_LIB_PATHS_webp=''
OUT_LIB_PATHS_webpdecoder=''
OUT_LIB_PATHS_webpdemux=''
OUT_LIB_PATHS_webpmux=''

readonly HOST="aarch64-apple-darwin"
readonly ISYSROOT=`xcrun --sdk macosx --show-sdk-path`

for ARCH in x86_64 arm64 ; do

    BUILD_ARCH_DIR="${BUILD_DIR}/${ARCH}"
    LIB_ARCH_DIR="${LIB_DIR}/${ARCH}"
    mkdir -p "${BUILD_ARCH_DIR}"
    mkdir -p "${LIB_ARCH_DIR}"

    TARGET="${ARCH}-apple-macos"
    CFLAGS="\
-arch ${ARCH}  \
-target ${TARGET} \
-isysroot ${ISYSROOT} \
-mmacos-version-min=13.0 \
-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include \
-F/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks \
"
    ./autogen.sh
    set -x
    ./configure --prefix=${BUILD_ARCH_DIR} --enable-everything --disable-static --host="$HOST" CFLAGS="${CFLAGS}"
    make && make install
    set +x

    path_libwebp=`realpath ${BUILD_ARCH_DIR}/lib/libwebp.dylib`
    path_libwebpdecoder=`realpath ${BUILD_ARCH_DIR}/lib/libwebpdecoder.dylib`
    path_libwebpdemux=`realpath ${BUILD_ARCH_DIR}/lib/libwebpdemux.dylib`
    path_libwebpmux=`realpath ${BUILD_ARCH_DIR}/lib/libwebpmux.dylib`

    cp -r ${path_libwebp}        "${BUILD_ARCH_DIR}/webp.bundle"
    cp -r ${path_libwebpdecoder} "${BUILD_ARCH_DIR}/webpdecoder.bundle"
    cp -r ${path_libwebpdemux}   "${BUILD_ARCH_DIR}/webpdemux.bundle"
    cp -r ${path_libwebpmux}     "${BUILD_ARCH_DIR}/webpmux.bundle"

    otool -L ${BUILD_ARCH_DIR}/webp.bundle
    otool -L ${BUILD_ARCH_DIR}/webpdecoder.bundle
    otool -L ${BUILD_ARCH_DIR}/webpdemux.bundle
    otool -L ${BUILD_ARCH_DIR}/webpmux.bundle

    install_name_tool -id @loader_path/webp.bundle            ${BUILD_ARCH_DIR}/webp.bundle
    install_name_tool -id @loader_path/wewebpdecoderbp.bundle ${BUILD_ARCH_DIR}/webpdecoder.bundle
    install_name_tool -id @loader_path/webpdemux.bundle       ${BUILD_ARCH_DIR}/webpdemux.bundle
    install_name_tool -id @loader_path/webpmux.bundle         ${BUILD_ARCH_DIR}/webpmux.bundle
    install_name_tool -change ${path_libwebp} @loader_path/webp.bundle ${BUILD_ARCH_DIR}/webpdemux.bundle
    install_name_tool -change ${path_libwebp} @loader_path/webp.bundle ${BUILD_ARCH_DIR}/webpmux.bundle

    otool -L ${BUILD_ARCH_DIR}/webp.bundle
    otool -L ${BUILD_ARCH_DIR}/webpdecoder.bundle
    otool -L ${BUILD_ARCH_DIR}/webpdemux.bundle
    otool -L ${BUILD_ARCH_DIR}/webpmux.bundle

    OUT_LIB_PATHS_webp+="  ${BUILD_ARCH_DIR}/webp.bundle"
    OUT_LIB_PATHS_webpdecoder+="  ${BUILD_ARCH_DIR}/webpdecoder.bundle"
    OUT_LIB_PATHS_webpdemux+="  ${BUILD_ARCH_DIR}/webpdemux.bundle"
    OUT_LIB_PATHS_webpmux+="  ${BUILD_ARCH_DIR}/webpmux.bundle"

    make clean
done

echo "OUT_LIB_PATHS_webp = ${OUT_LIB_PATHS_webp}"
lipo -create ${OUT_LIB_PATHS_webp} -output ${LIB_DIR}/webp.bundle

echo "OUT_LIB_PATHS_webpdecoder = ${OUT_LIB_PATHS_webpdecoder}"
lipo -create ${OUT_LIB_PATHS_webpdecoder} -output ${LIB_DIR}/webpdecoder.bundle

echo "OUT_LIB_PATHS_webpdemux = ${OUT_LIB_PATHS_webpdemux}"
lipo -create ${OUT_LIB_PATHS_webpdemux} -output ${LIB_DIR}/webpdemux.bundle

echo "OUT_LIB_PATHS_webpmux = ${OUT_LIB_PATHS_webpmux}"
lipo -create ${OUT_LIB_PATHS_webpmux} -output ${LIB_DIR}/webpmux.bundle

ls -al ${LIB_DIR}
lipo -info ${LIB_DIR}/webp.bundle
lipo -info ${LIB_DIR}/webpdecoder.bundle
lipo -info ${LIB_DIR}/webpdemux.bundle
lipo -info ${LIB_DIR}/webpmux.bundle