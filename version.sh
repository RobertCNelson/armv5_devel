#!/bin/sh
#
ARCH=$(uname -m)

#Dual/Quad Core arms are now more prevalent, so don't just limit to x86:
CORES=$(cat /proc/cpuinfo | grep processor | wc -l)

unset GIT_OPTS
unset GIT_NOEDIT
LC_ALL=C git help pull | grep -m 1 -e "--no-edit" >/dev/null 2>&1 && GIT_NOEDIT=1

if [ "${GIT_NOEDIT}" ] ; then
	GIT_OPTS="${GIT_OPTS} --no-edit"
fi

config="mxs_defconfig"

linaro_toolchain="arm9_gcc_4_7"
#linaro_toolchain="cortex_gcc_4_6"
#linaro_toolchain="cortex_gcc_4_7"
#linaro_toolchain="cortex_gcc_4_8"

#Kernel/Build
KERNEL_REL=3.10
KERNEL_TAG=${KERNEL_REL}.1
BUILD=imxv5-x0.4

#v3.X-rcX + upto SHA
#KERNEL_SHA="2c2c0e52314ef812a2aa9f7d32b3162584bee92b"

#git branch
BRANCH="v3.10.x-imxv5"

BUILDREV=1.0
DISTRO=cross
DEBARCH=armel
