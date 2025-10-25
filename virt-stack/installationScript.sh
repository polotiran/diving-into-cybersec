#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo or as root"
   exit 1
fi
echo "Don't forget this script installs QEMU/KVM and libvirt, it does not install eventual dependancies required !"
echo "It has been tested on Debian13 and on Rocky10, but it should also work with other distributions"
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
else
    echo "Neither apt nor dnf found. Exiting."
    exit 1
fi
if [[ "$PKG_MANAGER" == "apt" ]]; then
    echo "Updating packages..."
    apt update
    echo "Installing QEMU/KVM, libvirt, and tools..."
    apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst
elif [[ "$PKG_MANAGER" == "dnf" ]]; then
    echo "Installing QEMU/KVM, libvirt, and tools..."
    dnf install -y qemu-kvm libvirt libvirt-daemon virt-install
fi
CURRENT_USER=${SUDO_USER:-$USER}
echo "Adding $CURRENT_USER to libvirt and kvm groups..."
usermod -aG libvirt "$CURRENT_USER"
usermod -aG kvm "$CURRENT_USER"
USER_HOME=$(eval echo "~$CURRENT_USER")
CONFIG_DIR="$USER_HOME/.config/libvirt"
CONFIG_FILE="$CONFIG_DIR/libvirt.conf"

echo "Configuring libvirt to use the system daemon for $CURRENT_USER..."

mkdir -p "$CONFIG_DIR"
echo 'uri_default = "qemu:///system"' > "$CONFIG_FILE"
chown -R "$CURRENT_USER:$CURRENT_USER" "$CONFIG_DIR"

echo "Enabling libvirt service..."
systemctl enable --now libvirtd


echo "Installation complete! Log out and back in to apply group changes"
