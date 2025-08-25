#!/bin/bash

# CUDA support is broken after hibernate.
# https://stackoverflow.com/questions/10871412/resetting-gpu-and-driver-after-cuda-error/57803619#57803619

set -x 

sudo rmmod nvidia_uvm
sudo modprobe nvidia_uvm
