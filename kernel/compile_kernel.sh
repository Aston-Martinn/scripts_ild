#!/bin/bash

# The Kernel compiling Script by Advaith Bhat

# Copyright (C) 2021 github.com/Aston-martinn

# Licensed under the GNU General Public License, Version 3.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# https://github.com/Aston-Martinn/Scripts//blob/master/LICENSE

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Colours
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
green='\033[32m'
nocol='\033[0m'

# Clear the environment
clear

# Params
KERNEL_DEFCONFIG=vendor/kona-perf_defconfig
BUILD_START=$(date +"%s")

# Misc Params
DEVICE_HUB=https://github.com/Device-Tree-Hub
KERNEL_SOURCE=kernel_oneplus_sm8250.git
KERNEL_BRANCH=zip
KERNEL_DIR=kernel

# Print SeniXa
echo ""
echo -e "$green ######  ######## ##    ## #### ##     ##    ###    $nocol"
echo -e "$green ##   ## ##       ###   ##  ##   ##   ##    ## ##   $nocol"
echo -e "$green ##      ##       ####  ##  ##    ## ##    ##   ##  $nocol"
echo -e "$green ######  ######   ## ## ##  ##     ###    ##     ## $nocol"
echo -e "$green      ## ##       ##  ####  ##    ## ##   ######### $nocol"
echo -e "$green ##   ## ##       ##   ###  ##   ##   ##  ##     ## $nocol"
echo -e "$green ######  ######## ##    ## #### ##     ## ##     ## $nocol"
echo ""
echo -e "$green ########### Build Tool by Advaith Bhat ########### $nocol"
echo ""

# Clone the sources
echo -e "$red Cloning the kernel source $nocol"
git clone --quiet $DEVICE_HUB/$KERNEL_SOURCE -b $KERNEL_BRANCH $KERNEL_DIR > /dev/null
echo -e "$red Sources are cloned to $KERNEL_DIR $nocol"

cd $KERNEL_DIR

echo ""
# Clone Proton-clang
echo -e "$yellow Cloning Proton-clang $nocol"
git clone --quiet --depth=1 https://github.com/kdrag0n/proton-clang.git > /dev/null
echo -e "$yellow Cloned Proton-clang $nocol"

echo ""
# Compilation
echo -e "$yellow Compiling the kernel $nocol"
export ARCH=arm64
make clean
make mrproper
make $KERNEL_DEFCONFIG
make -j$(nproc --all) ARCH=arm64 \
        CC=proton-clang/bin/clang \
        CROSS_COMPILE=proton-clang/bin/aarch64-linux-gnu- \
        CROSS_COMPILE_ARM32=proton-clang/bin/arm-linux-gnueabi-
echo ""
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$blue ########## Kernel Compiled in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds ##########$nocol"
echo ""

sleep 5

echo ""
# Copy Image to zip
echo -e "$cyan Copying the Image to zip $nocol"
mv arch/arm64/boot/Image zip/Image

echo ""
# Zip the Image
echo -e "$red Zipping $nocol"
cd zip
zip -r SeniXa-lemonades-`date +%Y%m%d_%H%M`.zip * -x "*.zip"
echo -e "$red Zipped succussfully $nocol"

echo ""
# Upload to Drive
cd ..
echo -e "$green Uploading to Drive... $nocol"
gdrive upload zip/S*.zip
