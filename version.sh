#!/bin/sh
#
ARCH=$(uname -m)
DISABLE_MASTER_BRANCH=1
#EXPIRED_BRANCH=1

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
KERNEL_REL=3.9
KERNEL_TAG=${KERNEL_REL}.2
BUILD=armv5-x0.44

#v3.X-rcX + upto SHA
#KERNEL_SHA="cfb63bafdb87bbcdc5d6dbbca623d3f69475f118"

#git branch
BRANCH="v3.9.x-at91"

BUILDREV=1.0
DISTRO=cross
DEBARCH=armel
