#!/bin/bash

#cd 
#rm -rf go-ethereum
#git clone -b develop git://github.com/ethereum/go-ethereum

cd ~/go-ethereum
git pull
make -j$(nproc)

