#!/bin/bash

export DISPLAY=:0
export GPU_MAX_ALLOC_PERCENT=100

#cd
#rm -fr cpp-ethereum
#git clone -b develop https://github.com/ethereum/cpp-ethereum

cd ~/cpp-ethereum 
rm -fr build
mkdir  build
cd     build

cmake .. -DGUI=0 -DETHASHCL=1 -DTESTS=0

make -j$(nproc)

