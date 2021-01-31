#!/bin/bash

rm -Rvf build_release
mkdir build_release

pushd build_release
cmake -DCMAKE_BUILD_TYPE=Release .. || exit 1
make -j6  > make-log.txt.2 2>&1 || exit 1
popd

echo PWD is $PWD
ls -lh *.zip
ls -lh *.tbz
