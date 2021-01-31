#!/bin/bash

mkdir ~/install
git clone https://github.com/aws/aws-sdk-cpp.git
pushd aws-sdk-cpp
mkdir build
cd build
cmake .. -DBUILD_ONLY="core" \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  -DENABLE_UNITY_BUILD=ON \
  -DCUSTOM_MEMORY_MANAGEMENT=OFF \
  -DCMAKE_INSTALL_PREFIX=~/install \
  -DENABLE_UNITY_BUILD=ON || exit 1
make || exit 1
make install || exit 1
popd

git clone https://github.com/awslabs/aws-lambda-cpp-runtime.git
pushd aws-lambda-cpp-runtime
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_INSTALL_PREFIX=~/install \
make
make install
popd 

rm -Rvf build_release
mkdir build_release

pushd build_release
cmake -DCMAKE_BUILD_TYPE=Release .. -DCMAKE_INSTALL_PREFIX=~/install || exit 1
make -j6 || exit 1
make aws-lambda-package-api || exit 1
#make -j6  > make-log.txt.2 2>&1 || exit 1
popd

cp build_release/*.zip .
echo PWD is $PWD
ls -lh *.zip
ls -lh *.tbz
