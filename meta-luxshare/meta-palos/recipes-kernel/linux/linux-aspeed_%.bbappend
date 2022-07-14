FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:palos = " file://palos.cfg \
			 file://0010-add-support-tmp46x-temperature-sensor.patch \
       			 file://0011-add-support-ti-tla2024-adc-sensor.patch \
                       "

PACKAGE_ARCH = "${MACHINE_ARCH}"

