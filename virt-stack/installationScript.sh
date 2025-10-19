#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo or as root"
   exit 1
fi
echo "Don't forget this script installs QEMU/KVM and libvirt, it does not install eventual dependancies required !"
echo "From what I have experienced everything else you need is pre-installed on red-hat like systems, I do not know about others"
# Detect package manager
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
else
    echo "Neither apt nor dnf found. Exiting."
    exit 1
fi

# Install packages
if [[ "$PKG_MANAGER" == "apt" ]]; then
    echo "Updating packages..."
    apt update
    echo "Installing QEMU/KVM, libvirt, and tools..."
    apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst
elif [[ "$PKG_MANAGER" == "dnf" ]]; then
    echo "Installing QEMU/KVM, libvirt, and tools..."
    dnf install -y @virtualization qemu-kvm libvirt libvirt-daemon bridge-utils virt-install
fi

# Add current user to groups
CURRENT_USER=${SUDO_USER:-$USER}
echo "Adding $CURRENT_USER to libvirt and kvm groups..."
usermod -aG libvirt "$CURRENT_USER"
usermod -aG qemu "$CURRENT_USER"

# Enable libvirt service
echo "Enabling libvirt service..."
systemctl enable --now libvirtd


echo "Installation complete! Log out and back in to apply group changes"
