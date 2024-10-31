#!/bin/bash

# Universal NVIDIA Driver Installation Script with CUDA Repository Setup

# Function to detect the Linux distribution and version
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION=$VERSION_ID
    else
        echo "Unsupported distribution."
        exit 1
    fi
}

# Add NVIDIA CUDA repository for each supported Linux distribution
add_nvidia_repo() {
    case "$DISTRO" in
        ubuntu)
            echo "Adding NVIDIA CUDA repository for $DISTRO $VERSION."
            sudo apt update -y
            sudo apt install -y wget gnupg software-properties-common
            if [[ "$VERSION" == "24.04" ]]; then
                wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
            elif [[ "$VERSION" == "22.04" ]]; then
                wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
            elif [[ "$VERSION" == "20.04" ]]; then
                wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
            else
                echo "Unsupported Ubuntu version for this script."
                exit 1
            fi
            sudo dpkg -i cuda-keyring_1.1-1_all.deb
            sudo apt update -y
            ;;
        debian)
            echo "Adding NVIDIA CUDA repository for Debian."
            sudo apt update -y
            sudo apt install -y wget gnupg
            wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
            sudo dpkg -i cuda-keyring_1.1-1_all.deb
            sudo apt update -y
            ;;
        centos|rhel)
            echo "Adding NVIDIA CUDA repository for $DISTRO."
            sudo yum install -y epel-release
            sudo yum update -y
            sudo yum install -y dnf
            sudo dnf config-manager --add-repo=https://developer.download.nvidia.com/compute/cuda/repos/rhel${VERSION}/x86_64/cuda-rhel${VERSION}.repo
            sudo dnf clean all
            ;;
        fedora)
            echo "Adding NVIDIA CUDA repository for Fedora."
            sudo dnf config-manager --add-repo=https://developer.download.nvidia.com/compute/cuda/repos/fedora${VERSION}/x86_64/cuda-fedora${VERSION}.repo
            sudo dnf clean all
            ;;
        opensuse|suse)
            echo "Adding NVIDIA CUDA repository for openSUSE/SUSE."
            sudo zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
            sudo zypper refresh
            ;;
        *)
            echo "Unsupported distribution: $DISTRO. Exiting."
            exit 1
            ;;
    esac
}

# Install the NVIDIA driver using the cuda-drivers package
install_nvidia_driver() {
    case "$DISTRO" in
        ubuntu|debian)
            echo "Installing NVIDIA driver on $DISTRO."
            sudo apt install -y cuda-drivers
            ;;
        centos|rhel)
            echo "Installing NVIDIA driver on $DISTRO."
            sudo dnf install -y cuda-drivers
            ;;
        fedora)
            echo "Installing NVIDIA driver on Fedora."
            sudo dnf install -y cuda-drivers
            ;;
        opensuse|suse)
            echo "Installing NVIDIA driver on openSUSE/SUSE."
            sudo zypper install -y cuda-drivers
            ;;
        *)
            echo "Unsupported distribution: $DISTRO. Exiting."
            exit 1
            ;;
    esac
}

# Verify installation
verify_installation() {
    if command -v nvidia-smi &> /dev/null; then
        echo "NVIDIA driver installation was successful."
        nvidia-smi
    else
        echo "NVIDIA driver installation failed. Please check the logs for more details."
        exit 1
    fi
}

# Execute the script
detect_distro
add_nvidia_repo
install_nvidia_driver
verify_installation
