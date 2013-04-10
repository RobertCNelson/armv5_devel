#!/bin/bash
#
ARCH=$(uname -m)
DISABLE_MASTER_BRANCH=1

CORES=1
if [ "x${ARCH}" == "xx86_64" ] || [ "x${ARCH}" == "xi686" ] ; then
	CORES=$(cat /proc/cpuinfo | grep processor | wc -l)
	let CORES=$CORES+1
fi

unset GIT_OPTS
unset GIT_NOEDIT
LC_ALL=C git help pull | grep -m 1 -e "--no-edit" &>/dev/null && GIT_NOEDIT=1

if [ "${GIT_NOEDIT}" ] ; then
	GIT_OPTS+="--no-edit"
fi

config="at91_dt_defconfig"

#Kernel/Build
KERNEL_REL=3.9
KERNEL_TAG=${KERNEL_REL}-rc6
BUILD=armv5-x0.37

#v3.X-rcX + upto SHA
#KERNEL_SHA="d08d528dc1848fb369a0b27cdb0749d8f6f38063"

#git branch
BRANCH="v3.9.x-at91"

BUILDREV=1.0
DISTRO=cross
DEBARCH=armel
