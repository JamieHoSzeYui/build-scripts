#!/bin/bash

sudo apt-get update
sudo apt-get install git

git clone https://github.com/akhilnarang/scripts &&cd scripts/setup &&bash android_buil*.sh 

cd ../../

# some probably broken flags to make me feel better
export USE_CCACHE=1
export USE_CCACHE_EXEC=$(command -v ccache)
ccache -M 50G
export ANDROID_JACK_VM_ARGS="-Xmx15g -Dfile.encoding=UTF-8 -XX:+TieredCompilation"
