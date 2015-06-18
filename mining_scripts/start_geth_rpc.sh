#!/bin/bash

export DISPLAY=:0
export GPU_MAX_ALLOC_PERCENT=100

~/bin/geth --maxpeers 10 --rpc console 2>~/geth.log

