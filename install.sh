#! /bin/bash

set -eux

function _on_exit {
    echo "Script ended"
}

trap _on_exit EXIT

Help()
{
   # Display Help
   echo "Install script for the development environment."
   echo
   echo "Syntax: ./install.sh [-j|-h]"
   echo "Example ./install.sh -j <number-of-threads>"
   echo "Options:"
   echo "-j     Number of cores to be used during building."
   echo "-h     Prints this help."
}

# ================ INSTALLING DEPENDENCIES ================
sudo apt-get install -y git
sudo apt-get install -y curl

# ================ HANDLING OPTIONS ================
NBTHREADS=""

while getopts ":j:h" option; do
   case $option in
      j)
         NBTHREADS=$OPTARG;;
      h)
         Help
         exit;;
      \?)
         echo "Error: Invalid option"
         exit;;
   esac
done


mkdir -p env
mkdir -p env/gcc
mkdir -p env/python
mkdir -p env/ninja/bin

WORKSPACE=$(dirname $(readlink -f ${0}))q
INSTALL_DIR=$(mktemp -d)
cd $INSTALL_DIR

# ================ INSTALLING GCC ================

# check if gcc is empty, if not, do nothing.
if [[ -z $(ls -A "${WORKSPACE}/env/gcc") ]]; then
    wget https://ftp.gwdg.de/pub/misc/gcc/releases/gcc-13.2.0/gcc-13.2.0.tar.gz

    tar -vxzf ./gcc-13.2.0.tar.gz
    cd  ./gcc-13.2.0
    ./contrib/download_prerequisites
    mkdir objdir
    cd objdir
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ../configure --prefix=$WORKSPACE/env/gcc --enable-languages=c,c++ --with-sysroot=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        ../configure --prefix=$WORKSPACE/env/gcc --enable-languages=c,c++
    fi

    if [[ "$NBTHREADS" != "" ]]; then
        make -j $NBTHREADS
    else
        make
    fi
    make install
fi
# ================ INSTALLING CMAKE ================
if [[ -z $(ls -A "${WORKSPACE}/env/cmake") ]]; then

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        wget https://github.com/Kitware/CMake/releases/download/v3.29.1/cmake-3.29.1-linux-x86_64.tar.gz
        tar -vxzf cmake-3.29.1-linux-x86_64.tar.gz
        rm -rf cmake-3.29.1-linux-x86_64.tar.gz
        mv cmake-3.29.1-linux-x86_64 "${WORKSPACE}/env/cmake" # rename to cmake
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        wget https://github.com/Kitware/CMake/releases/download/v3.29.1/cmake-3.29.1-macos10.10-universal.tar.gz
        tar -vxzf cmake-3.29.1-macos10.10-universal.tar.gz
        rm -rf cmake-3.29.1-macos10.10-universal.tar.gz
        mv cmake-3.29.1-macos10.10-universal "${WORKSPACE}/env/cmake" # rename to cmake
    fi
fi

# ================ INSTALLING PYTHON ================
if [[ -z $(ls -A "${WORKSPACE}/env/python") ]]; then
    wget https://www.python.org/ftp/python/3.12.1/Python-3.12.1.tar.xz

    tar -vxzf Python-3.12.1.tar.xz
    cd Python-3.12.1
    ./configure --enable-shared --prefix=$WORKSPACE/env/python
    if [[ "$NBTHREADS" != "" ]]; then
        make -j $NBTHREADS
    else
        make
    fi
    make install
fi

# ================ INSTALLING NINJA ================
if [[ -z $(ls -A "${WORKSPACE}/env/ninja") ]]; then

    if [[ "$OSTYPE" == "darwin"* ]]; then
        wget https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-mac.zip
        unzip ninja-mac.zip
        rm ninja-mac.zip
        mv ninja $WORKSPACE/env/ninja/bin
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        wget https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip
        unzip ninja-linux.zip
        rm ninja-linux.zip
        mv ninja $WORKSPACE/env/ninja/bin
    fi
fi
echo "Environment installation is finished"
cd $WORKSPACE
rm -rf $INSTALL_DIR
