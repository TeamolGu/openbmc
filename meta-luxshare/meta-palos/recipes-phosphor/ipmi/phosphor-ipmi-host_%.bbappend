FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS:append:palos= " palos-yaml-config"

EXTRA_OEMESON:palos= " \
    -Dsensor-yaml-gen=${STAGING_DIR_HOST}${datadir}/palos-yaml-config/ipmi-sensors.yaml \
    -Dinvsensor-yaml-gen=${STAGING_DIR_HOST}${datadir}/palos-yaml-config/ipmi-inventory-sensors.yaml \
    -Dfru-yaml-gen=${STAGING_DIR_HOST}${datadir}/palos-yaml-config/ipmi-fru-read.yaml \
    "
