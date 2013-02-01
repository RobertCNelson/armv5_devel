#!/bin/bash
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

unset KERNEL_UTS
unset MMC
unset ZRELADDR

BOOT_PARITION="1"

DIR=$PWD

source ${DIR}/version.sh

mmc_write_rootfs () {
	echo "Installing ${KERNEL_UTS}-modules.tar.gz to ${partition}"

	if [ -d "${location}/lib/modules/${KERNEL_UTS}" ] ; then
		sudo rm -rf "${location}/lib/modules/${KERNEL_UTS}" || true
	fi

	sudo tar ${UNTAR} "${DIR}/deploy/${KERNEL_UTS}-modules.tar.gz" -C "${location}"
	sync

	echo "Installing ${KERNEL_UTS}-firmware.tar.gz to ${partition}"

	sudo mkdir -p "${location}/tmp/fir"
	sudo tar ${UNTAR} "${DIR}/deploy/${KERNEL_UTS}-firmware.tar.gz" -C "${location}/tmp/fir/"
	sync

	sudo cp -v "${location}"/tmp/fir/cape-*.dtbo "${location}/lib/firmware/" 2>/dev/null
	sync

	if [ "${ZRELADDR}" ] ; then
		if [ ! -f "${location}/boot/SOC.sh" ] ; then
			if [ -f "${location}/boot/uImage" ] ; then
			#Possibly Angstrom: dump a newer uImage if one exists..
				if [ -f "${location}/boot/uImage_bak" ] ; then
					sudo rm -f "${location}/boot/uImage_bak" || true
				fi

				sudo mv "${location}/boot/uImage" "${location}/boot/uImage_bak"
				sudo mkimage -A arm -O linux -T kernel -C none -a ${ZRELADDR} -e ${ZRELADDR} -n ${KERNEL_UTS} -d "${DIR}/deploy/${KERNEL_UTS}.zImage" "${location}/boot/uImage"
			fi
		fi
	fi
}

mmc_write_boot () {
	echo "Installing ${KERNEL_UTS} to ${partition}"

	if [ -f "${location}/SOC.sh" ] ; then
		source "${location}/SOC.sh"
		ZRELADDR=${load_addr}
	fi

	if [ -f "${location}/uImage_bak" ] ; then
		sudo rm -f "${location}/uImage_bak" || true
	fi

	if [ -f "${location}/uImage" ] ; then
		sudo mv "${location}/uImage" "${location}/uImage_bak"
	fi

	if [ "${ZRELADDR}" ] ; then
		sudo mkimage -A arm -O linux -T kernel -C none -a ${ZRELADDR} -e ${ZRELADDR} -n ${KERNEL_UTS} -d "${DIR}/deploy/${KERNEL_UTS}.zImage" "${location}/uImage"
	fi

	if [ -f "${location}/zImage_bak" ] ; then
		sudo rm -f "${location}/zImage_bak" || true
	fi

	if [ -f "${location}/zImage" ] ; then
		sudo mv "${location}/zImage" "${location}/zImage_bak"
	fi

	#Assuming boot via zImage on first partition...
	sudo cp -v "${DIR}/deploy/${KERNEL_UTS}.zImage" "${location}/zImage"

	if [ -f "${DIR}/deploy/${KERNEL_UTS}-dtbs.tar.gz" ] ; then

		if [ -d "${location}/dtbs" ] ; then
			sudo rm -rf "${location}/dtbs" || true
		fi

		sudo mkdir -p "${location}/dtbs"

		echo "Installing ${KERNEL_UTS}-dtbs.tar.gz to ${partition}"
		sudo tar ${UNTAR} "${DIR}/deploy/${KERNEL_UTS}-dtbs.tar.gz" -C "${location}/dtbs/"
		sync
	fi
}

mmc_partition_discover () {
	if [ -f "${DIR}/deploy/disk/uEnv.txt" ] ; then
		location="${DIR}/deploy/disk"
		mmc_write_boot
	fi

	if [ -f "${DIR}/deploy/disk/boot/uEnv.txt" ] ; then
		location="${DIR}/deploy/disk/boot"
		mmc_write_boot
	fi

	if [ -f "${DIR}/deploy/disk/etc/fstab" ] ; then
		location="${DIR}/deploy/disk"
		mmc_write_rootfs
	fi
}

mmc_unmount () {
	cd "${DIR}/deploy/disk"
	sync
	sync
	cd -
	sudo umount "${DIR}/deploy/disk" || true
}

mmc_detect_n_mount () {
	echo "Starting Partition Search"
	echo "-----------------------------"
	num_partitions=$(LC_ALL=C sudo fdisk -l 2>/dev/null | grep "^${MMC}" | grep -v "DM6" | grep -v "Extended" | grep -v "swap" | wc -l)

	for (( c=1; c<=${num_partitions}; c++ ))
	do
		partition=$(LC_ALL=C sudo fdisk -l 2>/dev/null | grep "^${MMC}" | grep -v "DM6" | grep -v "Extended" | grep -v "swap" | head -${c} | tail -1 | awk '{print $1}')
		echo "Trying ${partition}"

		if [ ! -d "${DIR}/deploy/disk/" ] ; then
			mkdir -p "${DIR}/deploy/disk/"
		fi

		echo "Partition: [${partition}] trying: [vfat], [ext4]"
		if sudo mount -t vfat ${partition} "${DIR}/deploy/disk/" 2>/dev/null ; then
			echo "Partition: [vfat]"
			UNTAR="xfo"
			mmc_partition_discover
			mmc_unmount
		elif sudo mount -t ext4 ${partition} "${DIR}/deploy/disk/" 2>/dev/null ; then
			echo "Partition: [extX]"
			UNTAR="xf"
			mmc_partition_discover
			mmc_unmount
		fi
	done

	echo "-----------------------------"
	echo "This script has finished..."
	echo "Always test your device for verification..."
}

unmount_partitions () {
	echo ""
	echo "Debug: Existing Partition on drive:"
	echo "-----------------------------"
	LC_ALL=C sudo fdisk -l ${MMC}

	echo ""
	echo "Unmounting Partitions"
	echo "-----------------------------"

	NUM_MOUNTS=$(mount | grep -v none | grep "${MMC}" | wc -l)

	for (( c=1; c<=${NUM_MOUNTS}; c++ ))
	do
		DRIVE=$(mount | grep -v none | grep "${MMC}" | tail -1 | awk '{print $1}')
		sudo umount ${DRIVE} &> /dev/null || true
	done

	mkdir -p "${DIR}/deploy/disk/"
	mmc_detect_n_mount
}

check_mmc () {
	FDISK=$(LC_ALL=C sudo fdisk -l 2>/dev/null | grep "Disk ${MMC}" | awk '{print $2}')

	if [ "x${FDISK}" = "x${MMC}:" ] ; then
		echo ""
		echo "I see..."
		echo "fdisk -l:"
		LC_ALL=C sudo fdisk -l 2>/dev/null | grep "Disk /dev/" --color=never
		echo ""
		echo "mount:"
		mount | grep -v none | grep "/dev/" --color=never
		echo ""
		read -p "Are you 100% sure, on selecting [${MMC}] (y/n)? "
		[ "${REPLY}" == "y" ] && unmount_partitions
		echo ""
	else
		echo ""
		echo "Are you sure? I Don't see [${MMC}], here is what I do see..."
		echo ""
		echo "fdisk -l:"
		LC_ALL=C sudo fdisk -l 2>/dev/null | grep "Disk /dev/" --color=never
		echo ""
		echo "mount:"
		mount | grep -v none | grep "/dev/" --color=never
		echo "Please update MMC variable in system.sh"
	fi
}

if [ -f "${DIR}/system.sh" ] ; then
	source ${DIR}/system.sh

	if [ -f "${DIR}/KERNEL/arch/arm/boot/zImage" ] ; then
		KERNEL_UTS=$(cat "${DIR}/KERNEL/include/generated/utsrelease.h" | awk '{print $3}' | sed 's/\"//g' )
		if [ "x${MMC}" == "x" ] ; then
			echo "ERROR: MMC is not defined in system.sh"
		else
			unset PARTITION_PREFIX
			if [[ "${MMC}" =~ "mmcblk" ]] ; then
				PARTITION_PREFIX="p"
			fi
			check_mmc
		fi
	else
		echo "ERROR: arch/arm/boot/zImage not found, Please run build_kernel.sh before running this script..."
	fi
else
	echo "Missing system.sh, please copy system.sh.sample to system.sh and edit as needed"
	echo "cp system.sh.sample system.sh"
	echo "gedit system.sh"
fi

