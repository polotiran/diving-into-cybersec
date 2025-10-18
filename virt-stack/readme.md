# Virtualization Stack - QEMU/KVM
This folder contains a quick introduction to the virtualization stack I personnaly use, and that is used for the labs in the repository.

## Components
**QEMU/KVM** → these provide full virtualization
**libvirt** → our management layer that works via CLI or scripts (we don't use GUI tools here to get more in-depth learning but also because it would spoil the fun)

## In this folder you'll find :
- a script to **install and configure** QEMU on Linux (it will exist for apt and dnf)
- a quick guide for **creating a first VM** to ensure it works
- a rundown of the main elements you can find in the VMs' **XML configuration files**
