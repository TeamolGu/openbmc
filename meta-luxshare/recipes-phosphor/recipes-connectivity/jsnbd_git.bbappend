FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:palos = " file://0001-add-luxshare-palos-jsnbd.patch \
        "

PACKAGE_ARCH = "${MACHINE_ARCH}"
