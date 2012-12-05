#!/bin/bash
#
# Copyright (c) 2009-2012 Robert Nelson <robertcnelson@gmail.com>
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
#git="git am --whitespace=fix"

if [ -f ${DIR}/system.sh ] ; then
	source ${DIR}/system.sh
fi

if [ "${RUN_BISECT}" ] ; then
	git="git apply"
fi

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

cleanup () {
	git format-patch -${number} -o ${DIR}/patches/
	exit
}

distro () {
	echo "Distro Specific Patches"
	${git} "${DIR}/patches/distro/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"
}

mainline_fixes () {
	echo "Mainline Fixes"
	${git} "${DIR}/patches/mainline_fixes/0001-arm-add-definition-of-strstr-to-decompress.c.patch"
	${git} "${DIR}/patches/mainline_fixes/0002-revert-breaks-mmc-on-at91.patch"
}

atmel_mci () {
	echo "Atmel: MCI"
	${git} "${DIR}/patches/atmel_mci/0001-ARM-at91-add-clocks-for-DT-entries.patch"
	${git} "${DIR}/patches/atmel_mci/0002-ARM-dts-add-nodes-for-atmel-hsmci-controllers-for-at.patch"
	${git} "${DIR}/patches/atmel_mci/0003-ARM-dts-add-nodes-for-atmel-hsmci-controllers-for-at.patch"
	${git} "${DIR}/patches/atmel_mci/0004-mmc-atmel-mci-remove-not-needed-DMA-capability-test.patch"
	${git} "${DIR}/patches/atmel_mci/0005-ARM-at91-atmel-mci-remove-unused-setup_dma_addr-macr.patch"
	${git} "${DIR}/patches/atmel_mci/0006-mmc-atmel-mci-remove-the-need-for-CONFIG_MMC_ATMELMC.patch"
	${git} "${DIR}/patches/atmel_mci/0007-ARM-dts-fix-add-mmc-irq-priority.patch"
	${git} "${DIR}/patches/atmel_mci/0008-mmc-atmel-mci-support-8-bit-buswidth.patch"
	${git} "${DIR}/patches/atmel_mci/0009-mmc-atmel-mci-increase-dma-threshold.patch"
	${git} "${DIR}/patches/atmel_mci/0010-atmel-mci-replace-flush_dcache_page-with-flush_kerne.patch"
}

atmel_aria () {
	echo "Atmel: aria g25"
	${git} "${DIR}/patches/atmel_aria/0001-arm-at91-sam9x5-enable-uart0-uart1.patch"
	${git} "${DIR}/patches/atmel_aria/0002-arm-at91-add-ariag25-device-tree.patch"
	${git} "${DIR}/patches/atmel_aria/0003-arm-at91-ariag25-add-leds-onewire.patch"
	${git} "${DIR}/patches/atmel_aria/0004-arm-at91-sam9x5-use-usart-over-uart.patch"
	${git} "${DIR}/patches/atmel_aria/0005-rtc-serial-cleanup.patch"
#	${git} "${DIR}/patches/atmel_aria/0006-at91-sam9x-enable-nand.patch"
}

distro
mainline_fixes
atmel_mci
atmel_aria

echo "patch.sh ran successful"
