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

# ===================
# Setting environment
# ===================
export MYDROID=`pwd`
export BOARD_TYPE=$1
export BOOT_TYPE=$2
export THREAD=$3
export WLAN_PATH=${MYDROID}/hardware/ti/wlan/mac80211/compat
export IMG_PATH=${MYDROID}/out/target/product/${BOARD_TYPE}
export MYIMG=${MYDROID}/../prebuilt_images
export PATH=$PATH:${MYDROID}/../toolchain/arm-2010q1/bin
export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabi-

# ============================
# Building Android File System
# ============================
echo -e "${YELLOW}Building Android File System start...${NORMAL}"
build_blaze_tablet_sd () 
{
    cp -f device/ti/blaze_tablet/init.omap4blazeboard.rc-sd device/ti/blaze_tablet/init.omap4blazeboard.rc
    cp -f system/core/rootdir/init.rc-sd system/core/rootdir/init.rc
    source build/envsetup.sh
    lunch blaze_tablet-userdebug
    make -j$THREAD 2>&1 |tee android_make.out
}

build_blaze_tablet_emmc() 
{
    cp -f device/ti/blaze_tablet/init.omap4blazeboard.rc-emmc device/ti/blaze_tablet/init.omap4blazeboard.rc
    cp -f system/core/rootdir/init.rc-emmc system/core/rootdir/init.rc
    source build/envsetup.sh
    lunch blaze_tablet-userdebug
    make -j$THREAD 2>&1 |tee android_make.out
}

build_blaze_sd() 
{
    cp -f device/ti/blaze/init.omap4blazeboard.rc-sd device/ti/blaze/init.omap4blazeboard.rc
    cp -f system/core/rootdir/init.rc-sd system/core/rootdir/init.rc
    source build/envsetup.sh
    lunch full_blaze-userdebug
    make -j$THREAD 2>&1 |tee android_make.out
}

build_blaze_emmc() 
{
    cp -f device/ti/blaze/init.omap4blazeboard.rc-emmc device/ti/blaze/init.omap4blazeboard.rc
    cp -f system/core/rootdir/init.rc-emmc system/core/rootdir/init.rc
    source build/envsetup.sh
    lunch full_blaze-userdebug
    make -j$THREAD 2>&1 |tee android_make.out
}

if [ "$3" == "" ]; then
    THREAD=4
fi

if [ "$1" == "blaze_tablet" ] && [ "$2" == "sd" ]; then
    echo -e "${YELLOW}Building Android File system for <$1> with <$2> ${NORMAL}"
    build_blaze_tablet_sd
elif [ "$1" == "blaze_tablet" ] && [ "$2" == "emmc" ]; then
    echo -e "${YELLOW}Building Android File system for <$1> with <$2> ${NORMAL}"
    build_blaze_tablet_emmc
elif [ "$1" == "blaze" ] && [ "$2" == "sd" ]; then
    echo -e "${YELLOW}Building Android File system for <$1> with <$2> ${NORMAL}"
    build_blaze_sd
elif [ "$1" == "blaze" ] && [ "$2" == "emmc" ]; then
    echo -e "${YELLOW}Building Android File system for <$1> with <$2> ${NORMAL}"
    build_blaze_emmc
else
    echo -e "${YELLOW}Building Android File system for <BOARD_TYPE> with <BOOT_TYPE> ${NORMAL}"
    echo -e "${YELLOW}ERROR !!!!${NORMAL}"
    echo -e "Usage : ./m.sh <BOARD_TYPE> <BOOT_TYPE> <Thread>"
    echo -e "Usage : ./m.sh [blaze_tablet | blaze>] [ <emmc | sd> ]  <#> "
	echo -e "e.g.: ./m.sh blaze emmc 8          (8 threads for AFS build.)"
    exit 1
fi

# ============================
# Building WLAN driver
# ============================
export KERNEL_PATH=${MYDROID}/../kernel/android-3.0
export KLIB=${KERNEL_PATH}
export KLIB_BUILD=${KLIB}
echo -e "${YELLOW}Building WLAN Driver...${NORMAL}"
make -C ${WLAN_PATH}
echo -e "${YELLOW}Copy WLAN modules${NORMAL}"
mkdir -p ${IMG_PATH}/system/lib/modules/
cp ${WLAN_PATH}/compat/compat.ko ${IMG_PATH}/system/lib/modules/
cp ${WLAN_PATH}/net/wireless/cfg80211.ko ${IMG_PATH}/system/lib/modules/
cp ${WLAN_PATH}/net/mac80211/mac80211.ko ${IMG_PATH}/system/lib/modules/
cp ${WLAN_PATH}/drivers/net/wireless/wl12xx/wl12xx.ko ${IMG_PATH}/system/lib/modules/
cp ${WLAN_PATH}/drivers/net/wireless/wl12xx/wl12xx_sdio.ko ${IMG_PATH}/system/lib/modules/

# ============================
# Building GPS driver
# ============================
#export GPS_PATH=${MYDROID}/hardware/ti/gps/gnss
#echo -e "${YELLOW}Building GPS Driver...${NORMAL}"
#make -C ${GPS_PATH}
#echo -e "${YELLOW}Copy WLAN modules${NORMAL}"
#cp ${GPS_PATH}/gps_drv.ko ${IMG_PATH}/system/lib/modules/
