FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS:append:palos= " palos-yaml-config"

SRCREV = "a23af1206bc4c835516909c87c71be0e7428264c"

EXTRA_OEMESON:palos= " \
    -Dsensor-yaml-gen=${STAGING_DIR_HOST}${datadir}/palos-yaml-config/ipmi-sensors.yaml \
    -Dinvsensor-yaml-gen=${STAGING_DIR_HOST}${datadir}/palos-yaml-config/ipmi-inventory-sensors.yaml \
    -Dfru-yaml-gen=${STAGING_DIR_HOST}${datadir}/palos-yaml-config/ipmi-fru-read.yaml \
    "

SRC_URI:append:palos = " file://0001-add-luxshare-palos-ipmicmd-test.patch \
    "

PACKAGE_ARCH = "${MACHINE_ARCH}"
