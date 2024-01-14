#! /bin/bash
mkdir env
mkdir -p env/gcc
mkdir -p env/python

WORKSPACE=$PWD

# ================ INSTALLING GCC ================
INSTALL_DIR=mktemp -d
cd $INSTALL_DIR

curl -O https://ftp.gwdg.de/pub/misc/gcc/releases/gcc-13.2.0/gcc-13.2.0.tar.gz

tar xzf gcc-13.2.0.tar.gz

./gcc-13.2.0/contrib/download_prerequisites
mkdir objdir
cd objdir
../gcc-13.2.0/configure --prefix=$WORKSPACE/env/gcc --enable-languages=c,c++
make -j2
make install

cd $WORKSPACE
rm -rf $INSTALL_DIR

# ================ INSTALLING CMAKE ================
cd $WORKSPACE/env
curl -O https://github.com/Kitware/CMake/releases/download/v3.28.1/cmake-3.28.1-linux-x86_64.tar.gz
tar xzf cmake-3.28.1-linux-x86_64.tar.gz
rm -rf cmake-3.28.1-linux-x86_64.tar.gz
mv cmake-3.28.1-linux-x86_64 cmake # rename to cmake

# ================ INSTALLING PYTHON ================
INSTALL_DIR=mktemp -d
cd $INSTALL_DIR

curl -O https://www.python.org/ftp/python/3.12.1/Python-3.12.1.tar.xz

tar jvzf Python-3.12.1.tar.xz
cd Python-3.12.1
./configure --enable-shared --prefix=$WORKSPACE/env/python
make -j2
make test
make install

# installing python dependencies
export PATH=$WORKSPACE/env/python/bin:$PATH
export LD_LIBRARY_PATH=/$WORKSPACE/env/python/lib:$LD_LIBRARY_PATH

python -m pip install -r requirements.txt