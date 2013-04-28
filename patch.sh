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
#git="git am --whitespace=fix"

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

cleanup () {
	git format-patch -${number} -o ${DIR}/patches/
	exit
}

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-deb-pkg-Simplify-architecture-matching-for-cross-bui.patch"
}

atmel_spi () {
	echo "dir: atmel_spi"
	${git} "${DIR}/patches/atmel_spi/0001-spi-spi-atmel-fix-probing-failure-after-xfer-speed_h.patch"
	${git} "${DIR}/patches/atmel_spi/0002-spi-spi-atmel-detect-the-capabilities-of-SPI-core-by.patch"
	${git} "${DIR}/patches/atmel_spi/0003-spi-spi-atmel-add-support-transfer-on-CS1-2-3-not-on.patch"
	${git} "${DIR}/patches/atmel_spi/0004-spi-spi-atmel-add-physical-base-address.patch"
	${git} "${DIR}/patches/atmel_spi/0005-spi-spi-atmel-call-unmapping-on-transfers-buffers.patch"
	${git} "${DIR}/patches/atmel_spi/0006-spi-spi-atmel-status-information-passed-through-cont.patch"
	${git} "${DIR}/patches/atmel_spi/0007-spi-spi-atmel-add-flag-to-controller-data-for-lock-o.patch"
	${git} "${DIR}/patches/atmel_spi/0008-spi-spi-atmel-add-dmaengine-support.patch"
	${git} "${DIR}/patches/atmel_spi/0009-spi-spi-atmel-fix-spi-atmel-driver-to-adapt-to-slave.patch"
	${git} "${DIR}/patches/atmel_spi/0010-spi-spi-atmel-correct-16-bits-transfers-using-PIO.patch"
	${git} "${DIR}/patches/atmel_spi/0011-spi-spi-atmel-correct-16-bits-transfers-with-DMA.patch"
	${git} "${DIR}/patches/atmel_spi/0012-spi-spi-atmel-add-pinctrl-support-for-atmel-spi.patch"
	${git} "${DIR}/patches/atmel_spi/0013-ARM-at91-add-clocks-for-spi-dt-entries.patch"
	${git} "${DIR}/patches/atmel_spi/0014-ARM-dts-add-spi-nodes-for-atmel-SoC.patch"
	${git} "${DIR}/patches/atmel_spi/0015-ARM-dts-add-spi-nodes-for-the-atmel-boards.patch"
	${git} "${DIR}/patches/atmel_spi/0016-ARM-dts-add-pinctrl-property-for-spi-node-for-atmel-.patch"
}

atmel_aria () {
	echo "dir: atmel_aria"
	${git} "${DIR}/patches/atmel_aria/0001-ARM-at91-add-Acme-Systems-Aria-G25-board.patch"
	${git} "${DIR}/patches/atmel_aria/0002-at91-at91-ariag25-rename-usart-build.patch"
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
	#In our case, we are using Device Tree's...
	${git} "${DIR}/patches/atmel_fixes/0001-Revert-Revert-drivers-rtc-rtc-at91rm9200.c-use-a-var.patch"
	${git} "${DIR}/patches/atmel_fixes/0002-at91-ariag25-mega-patch-need-to-split-up.patch"
	${git} "${DIR}/patches/atmel_fixes/0003-ARM-at91-dts-at91sam9g20ek_2mmc-fix-card-detection.patch"
	${git} "${DIR}/patches/atmel_fixes/0004-add-at91-foxg20.patch"
	${git} "${DIR}/patches/atmel_fixes/0005-at91-dts-fix-rtc.patch"
}

arm
atmel_spi
atmel_aria
atmel_mci
atmel_fixes

echo "patch.sh ran successful"
