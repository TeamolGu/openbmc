FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
DEPENDS:append:palos= " palos-yaml-config"

EXTRA_OECONF:palos= " \
    YAML_GEN=${STAGING_DIR_HOST}${datadir}/palos-yaml-config/ipmi-fru-read.yaml \
    PROP_YAML=${STAGING_DIR_HOST}${datadir}/palos-yaml-config/ipmi-extra-properties.yaml \
    "

inherit obmc-phosphor-systemd systemd

SYSTEMD_SERVICE:${PN} += "obmc-read-eeprom@.service"

EEPROM_NAMES = "palos"

EEPROMFMT = "system/chassis/{0}"
EEPROM_ESCAPEDFMT = "system-chassis-{0}"
EEPROMS = "${@compose_list(d, 'EEPROMFMT', 'EEPROM_NAMES')}"
EEPROMS_ESCAPED = "${@compose_list(d, 'EEPROM_ESCAPEDFMT', 'EEPROM_NAMES')}"

ENVFMT = "obmc/eeproms/{0}"
SYSTEMD_ENVIRONMENT_FILE:${PN}:append:palos = " ${@compose_list(d, 'ENVFMT', 'EEPROMS')}"

TMPL = "obmc-read-eeprom@.service"
TGT = "${SYSTEMD_DEFAULT_TARGET}"
INSTFMT = "obmc-read-eeprom@{0}.service"
FMT = "../${TMPL}:${TGT}.wants/${INSTFMT}"

SYSTEMD_LINK_${PN}:append = " ${@compose_list(d, 'FMT', 'EEPROMS_ESCAPED')}"

do_install:append() {
        install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
        ln -sf ${systemd_system_unitdir}/obmc-read-eeprom@.service \
		    ${D}${sysconfdir}/systemd/system/multi-user.target.wants/obmc-read-eeprom@system-chassis-palos.service
}