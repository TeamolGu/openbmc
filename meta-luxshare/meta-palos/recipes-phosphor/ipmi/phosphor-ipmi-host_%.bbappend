FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS:append:palos= " palos-yaml-config"

SRCREV = "fc24fa5e00ac5d6bfdeebcacd5c86fbc5d64765a"

EXTRA_OEMESON:append:palos= " \
    -Dsensor-yaml-gen=${STAGING_DIR_HOST}${datadir}/palos-yaml-config/ipmi-sensors.yaml \
    -Dinvsensor-yaml-gen=${STAGING_DIR_HOST}${datadir}/palos-yaml-config/ipmi-inventory-sensors.yaml \
    -Dfru-yaml-gen=${STAGING_DIR_HOST}${datadir}/palos-yaml-config/ipmi-fru-read.yaml \
    "

SRC_URI:append:palos = " file://0001-add-luxshare-palos-ipmicmd-test.patch \
                         file://0002-Add-ipmi-cmd-debug-info.patch \
                         file://0004-ipmi-sensors-support-non-recoverable-alarms.patch \
    "

PACKAGE_ARCH = "${MACHINE_ARCH}"
