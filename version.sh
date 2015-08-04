#!/bin/sh
#
ARCH=$(uname -m)

config="at91_dt_defconfig"

#toolchain="gcc_linaro_eabi_4_8"
toolchain="gcc_linaro_eabi_4_9"
#toolchain="gcc_linaro_gnueabi_4_6"
#toolchain="gcc_linaro_gnueabihf_4_7"
#toolchain="gcc_linaro_gnueabihf_4_8"
#toolchain="gcc_linaro_gnueabihf_4_9"

#Kernel/Build
KERNEL_REL=4.0
KERNEL_TAG=${KERNEL_REL}.9
BUILD=armv5-r5

#v3.X-rcX + upto SHA
#prev_KERNEL_SHA=""
#KERNEL_SHA=""

#git branch
BRANCH="v4.0.x-at91"

DISTRO=cross
DEBARCH=armel
#
