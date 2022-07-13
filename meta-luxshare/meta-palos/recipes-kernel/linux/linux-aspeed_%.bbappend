FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:palos = " file://palos.cfg \
			 file://0001-add-support-tmp46x-temperature-sensor.patch \
                       "
SRC_URI += "file://aspeed-bmc-luxshare-palos.dts;subdir=git/arch/${ARCH}/boot/dts"

PACKAGE_ARCH = "${MACHINE_ARCH}"

