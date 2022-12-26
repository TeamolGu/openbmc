FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRCREV = "f20aa7c87360a0d2918377a86bbf04c85268d47d"

SRC_URI += " \
    file://virtual_sensor_config.json \
"

do_install:append() {
    install -m 0644 -D ${WORKDIR}/virtual_sensor_config.json ${D}${datadir}/phosphor-virtual-sensor/
}
