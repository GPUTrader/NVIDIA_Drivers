#!/bin/bash

#This script will add the Ubuntu-targeted NVIDIA drivers repo, run an update
#And then install the recommended package for this machine.
#Written by: William Russell for public use.
#updated 4/23/2023

#Ensure no pending updates:
apt-get update && apt upgrade -y
sleep 1
clear

#add the repository for ubuntu-drivers and select recommended:
sudo apt-get install ubuntu-drivers-common
#       && sudo ubuntu-drivers autoinstall


#list available drivers for this system:
sudo ubuntu-drivers devices

echo ""
echo "This script will autoinstall the latest driver"

ubuntu-drivers autoinstall

#sudo apt install <driver-version> -y ##example: sudo apt install nvidia-driver-470 -y


#sudo ubuntu-drivers devices

#blacklist the Nouveau driver so it doesn't initialize:
sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sleep 1
cat /etc/modprobe.d/blacklist-nvidia-nouveau.conf
sleep 1
clear

#update the kernel to reflect changes:
echo "updating initramfs..."
sleep 1
sudo update-initramfs -u
clear

echo "checking nvidia-smi output for validation"
nvidia-smi

#end of script output
echo "Script completed - NVIDIA drivers installed"
echo "please restart your machine to initialize correctly if `nvidia-smi` output did not report driver version"
