#!/bin/sh -e
#
# Copyright (c) 2009-2013 Robert Nelson <robertcnelson@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

ARCH=$(uname -m)
DIR=$PWD

. ${DIR}/system.sh

#For:
#linaro_toolchain
. ${DIR}/version.sh

ubuntu_arm_gcc_installed () {
	unset armel_pkg
	unset armhf_pkg
	if [ $(which lsb_release) ] ; then
		deb_distro=$(lsb_release -cs)

		#Linux Mint: Compatibility Matrix
		#http://www.linuxmint.com/oldreleases.php
		case "${deb_distro}" in
		maya)
			deb_distro="precise"
			;;
		nadia)
			deb_distro="quantal"
			;;
		olivia)
			deb_distro="raring"
			;;
		esac

		case "${deb_distro}" in
		precise|quantal|raring)
			#http://packages.ubuntu.com/raring/gcc-arm-linux-gnueabi
			armel_pkg="gcc-arm-linux-gnueabi"
			;;
		esac

		case "${deb_distro}" in
		precise|quantal|raring)
			#http://packages.ubuntu.com/raring/gcc-arm-linux-gnueabihf
			armhf_pkg="gcc-arm-linux-gnueabihf"
			;;
		esac

		if [ "${armel_pkg}" ] || [ "${armhf_pkg}" ] ; then
			echo "fyi: ${distro} ${deb_distro} has these ARM gcc cross compilers available in their repo:"
			if [ "${armel_pkg}" ] ; then
				echo "sudo apt-get install ${armel_pkg}"
			fi
			if [ "${armhf_pkg}" ] ; then
				echo "sudo apt-get install ${armhf_pkg}"
			fi
			echo "-----------------------------"
		fi
	fi

	if [ "${armel_pkg}" ] || [ "${armhf_pkg}" ] ; then
		if [ $(which arm-linux-gnueabi-gcc) ] ; then
			armel_gcc_test=$(LC_ALL=C arm-linux-gnueabi-gcc -v 2>&1 | grep "Target:" | grep arm || true)
		fi
		if [ $(which arm-linux-gnueabihf-gcc) ] ; then
			armhf_gcc_test=$(LC_ALL=C arm-linux-gnueabihf-gcc -v 2>&1 | grep "Target:" | grep arm || true)
		fi

		if [ "x${armel_gcc_test}" != "x" ] ; then
			CC="arm-linux-gnueabi-"
		fi
		if [ "x${armhf_gcc_test}" != "x" ] ; then
			CC="arm-linux-gnueabihf-"
		fi
	fi
}

dl_gcc_generic () {
	WGET="wget -c --directory-prefix=${DIR}/dl/"
	if [ ! -f ${DIR}/dl/${directory}/${datestamp} ] ; then
		echo "Installing: ${toolchain_name}"
		echo "-----------------------------"
		${WGET} ${site}/${version}/+download/${filename}
		if [ -d ${DIR}/dl/${directory} ] ; then
			rm -rf ${DIR}/dl/${directory} || true
		fi
		${untar} ${DIR}/dl/${filename} -C ${DIR}/dl/
		if [ -f ${DIR}/dl/${directory}/${binary}gcc ] ; then
			touch ${DIR}/dl/${directory}/${datestamp}
		fi
	fi

	if [ "x${ARCH}" = "xarmv7l" ] ; then
		#using native gcc
		CC=
	else
		CC="${DIR}/dl/${directory}/${binary}"
	fi
}

gcc_linaro_toolchain () {
	#https://launchpad.net/gcc-arm-embedded/+download
	#https://launchpad.net/linaro-toolchain-binaries/+download
	case "${linaro_toolchain}" in
	arm9_gcc_4_7)
		#https://launchpad.net/gcc-arm-embedded/4.7/4.7-2013-q1-update/+download/gcc-arm-none-eabi-4_7-2013q1-20130313-linux.tar.bz2

		toolchain_name="gcc-arm-none-eabi"
		site="https://launchpad.net/gcc-arm-embedded"
		version="4.7/4.7-2013-q1-update"
		version_date="20130313"
		directory="${toolchain_name}-4_7-2013q1"
		filename="${directory}-${version_date}-linux.tar.bz2"
		datestamp="${version_date}-${toolchain_name}"
		untar="tar -xjf"

		binary="bin/arm-none-eabi-"
		;;
	cortex_gcc_4_7)
		#https://launchpad.net/linaro-toolchain-binaries/trunk/2013.04/+download/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux.tar.xz

		gcc_version="4.7"
		release="2013.04"
		toolchain_name="gcc-linaro-arm-linux-gnueabihf"
		site="https://launchpad.net/linaro-toolchain-binaries"
		version="trunk/${release}"
		version_date="20130415"
		directory="${toolchain_name}-${gcc_version}-${release}-${version_date}_linux"
		filename="${directory}.tar.xz"
		datestamp="${version_date}-${toolchain_name}"
		untar="tar -xJf"

		binary="bin/arm-linux-gnueabihf-"
		;;
	cortex_gcc_4_8)
		#https://launchpad.net/linaro-toolchain-binaries/trunk/2013.05/+download/gcc-linaro-arm-linux-gnueabihf-4.8-2013.05_linux.tar.xz

		gcc_version="4.8"
		release="2013.05"
		toolchain_name="gcc-linaro-arm-linux-gnueabihf"
		site="https://launchpad.net/linaro-toolchain-binaries"
		version="trunk/${release}"
		directory="${toolchain_name}-${gcc_version}-${release}_linux"
		filename="${directory}.tar.xz"
		datestamp="${release}-${toolchain_name}"
		untar="tar -xJf"

		binary="bin/arm-linux-gnueabihf-"
		;;
	*)
		echo "bug: maintainer forgot to set:"
		echo "linaro_toolchain=\"xzy\" in version.sh"
		exit 1
		;;
	esac

	dl_gcc_generic
}

if [ "x${CC}" = "x" ] && [ "x${ARCH}" != "xarmv7l" ] ; then
	ubuntu_arm_gcc_installed
	if [ "x${CC}" = "x" ] ; then
		gcc_linaro_toolchain
	fi
fi

GCC_TEST=$(LC_ALL=C ${CC}gcc -v 2>&1 | grep "Target:" | grep arm || true)

if [ "x${GCC_TEST}" = "x" ] ; then
	echo "-----------------------------"
	echo "scripts/gcc: Error: The GCC ARM Cross Compiler you setup in system.sh (CC variable) is invalid."
	echo "-----------------------------"
	gcc_linaro_toolchain
fi

echo "-----------------------------"
echo "scripts/gcc: Using: `LC_ALL=C ${CC}gcc --version`"
echo "-----------------------------"
echo "CC=${CC}" > ${DIR}/.CC
