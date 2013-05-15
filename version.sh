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

config="at91_dt_defconfig"

#Kernel/Build
KERNEL_REL=3.10
KERNEL_TAG=${KERNEL_REL}-rc1
BUILD=armv5-x0.4

#v3.X-rcX + upto SHA
KERNEL_SHA="c240a539df4e2d50f86e2f31813ff6b7334cd493"

#git branch
BRANCH="v3.9.x-at91"

BUILDREV=1.0
DISTRO=cross
DEBARCH=armel
