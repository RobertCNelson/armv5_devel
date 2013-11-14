#!/bin/sh
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

# Split out, so build_kernel.sh and build_deb.sh can share..

git="git am"

if [ -f ${DIR}/system.sh ] ; then
	. ${DIR}/system.sh
fi

if [ "${RUN_BISECT}" ] ; then
	git="git apply"
fi

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

start_cleanup () {
	git="git am --whitespace=fix"
}

cleanup () {
	if [ "${number}" ] ; then
		git format-patch -${number} -o ${DIR}/patches/
	fi
	exit
}

arm () {
	echo "dir: arm"
#	${git} "${DIR}/patches/arm/0001-deb-pkg-Simplify-architecture-matching-for-cross-bui.patch"
	${git} "${DIR}/patches/arm/0001-builddeb-just-force-armel.patch"
}

atmel_mci () {
	echo "dir: atmel_mci"
	${git} "${DIR}/patches/atmel_mci/0001-mmc-atmel-mci-remove-not-needed-DMA-capability-test.patch"
	${git} "${DIR}/patches/atmel_mci/0002-mmc-atmel-mci-support-8-bit-buswidth.patch"
	${git} "${DIR}/patches/atmel_mci/0003-mmc-atmel-mci-increase-dma-threshold.patch"
	${git} "${DIR}/patches/atmel_mci/0004-atmel-mci-replace-flush_dcache_page-with-flush_kerne.patch"
}

atmel_fixes () {
	echo "dir: atmel_fixes"
#	${git} "${DIR}/patches/atmel_fixes/0001-at91-merge-mega-patch.patch"
}

ariag25_fixes () {
	echo "dir: ariag25_fixes"
	${git} "${DIR}/patches/ariag25_fixes/0001-at91-ariag25-updates.patch"
}

fixes () {
	echo "dir: fixes"
	${git} "${DIR}/patches/fixes/0001-mtd-atmel_nand-fix-bug-driver-will-in-a-dead-lock-if.patch"
}

arm
atmel_mci
atmel_fixes
ariag25_fixes
fixes

echo "patch.sh ran successful"
