#!/usr/bin/env bash
set -e

# [variable]
ROOT=$(pwd)
DIR_DEST=${ROOT}/output
DIR_LIBSODIUM=${ROOT}/libsodium


# [src] libsodium
git clone https://github.com/jedisct1/libsodium.git $DIR_LIBSODIUM && cd $DIR_LIBSODIUM
git checkout tags/1.0.18

# ===========================
# Android
# ===========================
# [environment]
# export ANDROID_NDK_HOME=${ROOT}/android-ndk
# DIR_TEMP=${ROOT}/temp_dir
# 
# 
# # [sdk] Android NDK
# mkdir $DIR_TEMP && cd $DIR_TEMP
# wget -q https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip
# unzip -o -q android-ndk-r13b-linux-x86_64.zip
# mv $DIR_TEMP/android-ndk-r13b ${ANDROID_NDK_HOME}


# [generate]
cd $DIR_LIBSODIUM

echo "================================== armv7-a"
git clean -Xdf
./autogen.sh
./dist-build/android-armv7-a.sh
mkdir -p $DIR_DEST/Plugins/Android/libs/armeabi-v7a
ls -al $DIR_LIBSODIUM/libsodium-android-armv7-a/lib
mv $DIR_LIBSODIUM/libsodium-android-armv7-a/lib/libsodium.a $DIR_LIBSODIUM/libsodium-android-armv7-a/lib/libsodium.so $DIR_DEST/Plugins/Android/libs/armeabi-v7a


echo "================================== armv8-a"
git clean -Xdf
./autogen.sh
./dist-build/android-armv8-a.sh
mkdir -p $DIR_DEST/Plugins/Android/libs/armeabi-v8a
ls -al $DIR_LIBSODIUM/libsodium-android-armv8-a/lib
mv $DIR_LIBSODIUM/libsodium-android-armv8-a/lib/libsodium.a $DIR_LIBSODIUM/libsodium-android-armv8-a/lib/libsodium.so $DIR_DEST/Plugins/Android/libs/armeabi-v8a


echo "================================== x86"
git clean -Xdf
./autogen.sh
./dist-build/android-x86.sh
mkdir -p $DIR_DEST/Plugins/Android/libs/x86
ls -al $DIR_LIBSODIUM/libsodium-android-i686/lib
mv $DIR_LIBSODIUM/libsodium-android-i686/lib/libsodium.a $DIR_LIBSODIUM/libsodium-android-i686/lib/libsodium.so $DIR_DEST/Plugins/Android/libs/x86


echo "================================== x86_64"
git clean -Xdf
./autogen.sh
./dist-build/android-x86_64.sh
mkdir -p $DIR_DEST/Plugins/Android/libs/x86_64
ls -al $DIR_LIBSODIUM/libsodium-android-westmere/lib
mv $DIR_LIBSODIUM/libsodium-android-westmere/lib/libsodium.a $DIR_LIBSODIUM/libsodium-android-westmere/lib/libsodium.so $DIR_DEST/Plugins/Android/libs/x86_64



cd ..
zip -r lib.zip $DIR_DEST*

ls -al