#!/bin/bash

ID=
TOKEN=

function start() {
    curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
        -d chat_id="$ID" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="<b>• TWRP Recovery •</b>%0ABuild started on <code>Circle CI/CD</code>%0A <b>For device</b> <i>miatoll</i>%0A<b>Build type:-</b> <code>UNOFFICIAL</code>%0A<b>Started on:- </b> <code>$(date)</code>%0A<b>Build Status:</b> #Beta"
}

function push() {
    cd out/target/product/miatoll
    IMG=$(echo recovery.img)
        curl -F document=@$IMG "https://api.telegram.org/bot$TOKEN/sendDocument" \
        -F chat_id="$ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="TWRP Build finished on $(date) | For <b>miatoll</b> | @mango_ci "
}

function finerr() {
    curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
        -d chat_id="$ID" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=markdown" \
        -d text="Build throw an error(s)"
    exit 1
}


# Setup manual
apt-get update
apt update
apt install \
    adb autoconf automake axel bc bison build-essential \
    ccache clang cmake expat fastboot flex g++ \
    g++-multilib gawk gcc gcc-multilib git gnupg gperf \
    htop imagemagick lib32ncurses5-dev lib32z1-dev libtinfo5 libc6-dev libcap-dev \
    libexpat1-dev libgmp-dev '^liblz4-.*' '^liblzma.*' libmpc-dev libmpfr-dev libncurses5-dev \
    libsdl1.2-dev libssl-dev libtool libxml2 libxml2-utils '^lzma.*' lzop \
    maven ncftp ncurses-dev patch patchelf pkg-config pngcrush \
    pngquant python2.7 python-all-dev re2c schedtool squashfs-tools subversion \
    texinfo unzip w3m xsltproc zip zlib1g-dev lzip \
    libxml-simple-perl apt-utils repo \
    libncurses5 -y

curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo
chmod a+rx /usr/local/bin/repo\

mkdir shrp && cd shrp 

repo init -u git://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-10.0 --depth=1 --groups=all,-notdefault,-device,-darwin,-x86,-mips
repo sync -c -j8 --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync
git clone https://github.com/ceb08/device_xiaomi_miatoll -b twrp device/xiaomi/miatoll

start
. build/envsetup.sh
lunch omni_miatoll-eng
mka recoveryimage -j8

if [[ -f out/target/product/miatoll/recovery.img ]]; then 
    push
else
    finerr
fi

