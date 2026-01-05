#!/bin/bash

# CUDA support is broken after hibernate.
# https://stackoverflow.com/questions/10871412/resetting-gpu-and-driver-after-cuda-error/57803619#57803619

# sudo nvidia-smi --gpu-reset -i 0

echo "Check if nvidia_uvm is in use (stop processes manually):"

( set -x; sudo fuser -v /dev/nvidia-uvm )

set -x 

sudo rmmod nvidia_uvm
sudo modprobe nvidia_uvm
