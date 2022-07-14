FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:palos = " file://palos.cfg \
			 file://aspeed-bmc-luxshare-palos.dts;subdir=git/arch/${ARCH}/boot/dts \
			 file://0009-add-luxshare-palos-bmc-dts.patch \
			 file://0010-add-support-tmp46x-temperature-sensor.patch \
       			 file://0011-add-support-ti-tla2024-adc-sensor.patch \
                       "

PACKAGE_ARCH = "${MACHINE_ARCH}"

