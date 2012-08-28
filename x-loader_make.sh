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

export MYXLOADER=`pwd`
export PATH=${MYXLOADER}/../toolchain/arm-2010q1/bin:$PATH
export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabi-
export BOARD_TYPE=$1
export BOOT_TYPE=$2

build_blaze_tablet_sd () 
{
    make distclean
    make ARCH=arm omap44XXtablet_config
    make ift 2>&1 | tee make_x-loader.out
}

build_blaze_tablet_emmc() 
{
    make distclean
    make ARCH=arm omap44XXtablet_config
    make ift 2>&1 | tee make_x-loader.out
    cp MLO Blaze_Tablet_GP_ES1.1_MLO
}

build_blaze_sd() 
{
    make distclean
    make ARCH=arm omap44XXsdp_config
    make ift 2>&1 | tee make_x-loader.out
}

build_blaze_emmc() 
{
    make distclean
    make ARCH=arm omap44XXsdp_config
    make ift 2>&1 | tee make_x-loader.out
    cp MLO Blaze_GP_ES1.1_MLO
}

Usage()
{
    echo -e "Usage : ./m.sh <BOARD_TYPE> <BOOT_TYPE>"
    echo -e "Usage : ./m.sh [blaze_tablet | blaze [ <emmc | sd> ] ] "
}

if [ "$1" == "blaze_tablet" ] && [ "$2" == "sd" ]; then
    echo -e "${YELLOW}Building x-loader for <$1> with <$2> ${NORMAL}"
    build_blaze_tablet_sd
elif [ "$1" == "blaze_tablet" ] && [ "$2" == "emmc" ]; then
    echo -e "${YELLOW}Building x-loader for <$1> with <$2> ${NORMAL}"
    build_blaze_tablet_emmc
elif [ "$1" == "blaze" ] && [ "$2" == "sd" ]; then
    echo -e "${YELLOW}Building x-loader for <$1> with <$2> ${NORMAL}"
    build_blaze_sd
elif [ "$1" == "blaze" ] && [ "$2" == "emmc" ]; then
    echo -e "${YELLOW}Building x-loader for <$1> with <$2> ${NORMAL}"
    build_blaze_emmc
else
    echo -e "${YELLOW}Building x-loader for <BOARD_TYPE> with <BOOT_TYPE> ${NORMAL}"
    echo -e "${YELLOW}ERROR !!!!${NORMAL}"
    Usage
    exit 1
fi
