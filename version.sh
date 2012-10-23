#!/bin/bash

ARCH=$(uname -m)

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

CCACHE=ccache

config="at91_dt_defconfig"

#Kernel/Build
KERNEL_REL=3.7
KERNEL_TAG=${KERNEL_REL}-rc2
BUILD=armv5-x0.3

#git branch
#BRANCH=3.2.x

BUILDREV=1.0
DISTRO=cross
DEBARCH=armel
