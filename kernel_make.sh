#!/bin/bash
# Pretty colors
YELLOW="\033[01;33m"
NORMAL="\033[00m"
BLUE="\033[34m"

# no colors (It may be bad colors than pretty colors depending on
# the background color chosen by the user.
# thus we provide a way to disable colors.
if [ "$1" = "--no-color" ]; then
    NORMAL=""
    YELLOW=$NORMAL
    BLUE=$NORMAL
    shift
fi

export KERNEL_PATH=`pwd`
export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabi-
export PATH=${KERNEL_PATH}/../u-boot/tools:$PATH
export PATH=${KERNEL_PATH}/../../../../toolchain/arm-2010q1/bin:$PATH

export CPU_TYPE=4460

# ============================
# Building Kernel
# ============================

build_blaze_tablet_sd () 
{
    make blaze_defconfig
    make -j4 uImage | tee make_kernel.out
    make modules | tee make_modules.out
}

build_blaze_tablet_emmc() 
{
    make blaze_defconfig
    make -j4 uImage | tee make_kernel.out
    make modules | tee make_modules.out
}

build_blaze_sd() 
{
    make blaze_defconfig
    make -j4 uImage | tee make_kernel.out
    make modules | tee make_modules.out
}

build_blaze_emmc() 
{
    make blaze_defconfig
    make -j4 uImage | tee make_kernel.out
    make modules | tee make_modules.out
}

Usage()
{
    echo -e "Usage : ./m.sh <BOARD_TYPE> <BOOT_TYPE>"
    echo -e "Usage : ./m.sh [blaze_tablet | blaze [ <emmc | sd> ] ] "
}

if [ "$1" == "blaze_tablet" ] && [ "$2" == "sd" ]; then
    build_blaze_tablet_sd
elif [ "$1" == "blaze_tablet" ] && [ "$2" == "emmc" ]; then
    build_blaze_tablet_emmc
elif [ "$1" == "blaze" ] && [ "$2" == "sd" ]; then
    build_blaze_sd
elif [ "$1" == "blaze" ] && [ "$2" == "emmc" ]; then
    build_blaze_emmc
else
    echo -e "${YELLOW}Building kernel for <BOARD_TYPE> with <BOOT_TYPE> ${NORMAL}"
    echo -e "${YELLOW}ERROR !!!!${NORMAL}"
    Usage
    exit 1
fi
