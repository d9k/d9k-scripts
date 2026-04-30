#!/bin/bash

# SYSTEMD_SCRIPT

set -x

sudo systemctl status nvidia-suspend.service
sudo systemctl status nvidia-hibernate.service
sudo systemctl status nvidia-resume.service

# https://forums.developer.nvidia.com/t/fixed-suspend-resume-issues-with-the-driver-version-470/187150/3
sudo systemctl stop nvidia-suspend.service
sudo systemctl stop nvidia-hibernate.service
sudo systemctl stop nvidia-resume.service

sudo systemctl disable nvidia-suspend.service
sudo systemctl disable nvidia-hibernate.service
sudo systemctl disable nvidia-resume.service

sudo mv /lib/systemd/system-sleep/nvidia $HOME/temp/lib_systemd_system-sleep_nvidia
