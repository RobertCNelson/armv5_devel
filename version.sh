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

#Kernel/Build
KERNEL_REL=3.9
KERNEL_TAG=${KERNEL_REL}.3
BUILD=imxv5-x0.12

#v3.X-rcX + upto SHA
#KERNEL_SHA="d08d528dc1848fb369a0b27cdb0749d8f6f38063"

#git branch
BRANCH="v3.9.x-imxv5"

BUILDREV=1.0
DISTRO=cross
DEBARCH=armel
