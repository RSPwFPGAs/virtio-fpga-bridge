#!/bin/sh -xe
# options: writethrough, writeback, directsync, none, unsafe
# WARNING: When using unsafe make sure you have snapshot mode enabled

QEMU="x86_64-softmmu/qemu-system-x86_64"
DISK_CACHE="writethrough"
CORES=1
MEMORY="-m 4G"
NIC="-device virtio-net-pci,disable-modern=on"
DEBUG=""
IMG="../../cosim.qcow2.2nd"

UNTIMED="-enable-kvm  -cpu host -smp cores=$CORES"
DRIVE="-drive file=$IMG,cache=$DISK_CACHE"
FPGA_PCIE="-device accelerator-pcie"

#OPTS="-snapshot"
OPTS=""

PORTMAP="-redir tcp:2202::22"
DISPLAY="-display none"

export COSIM_PORT=2029
sudo -E $QEMU $DEBUG $MEMORY $UNTIMED $OPTS $DRIVE $FPGA_PCIE $PORTMAP $DISPLAY $NIC

