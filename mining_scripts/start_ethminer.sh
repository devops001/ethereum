#!/bin/bash

export DISPLAY=:0
export GPU_MAX_ALLOC_PERCENT=100

~/bin/ethminer -G --opencl-device 0

