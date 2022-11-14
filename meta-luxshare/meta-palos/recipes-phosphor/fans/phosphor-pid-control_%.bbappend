FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd

SYSTEMD_SERVICE:${PN} = "phosphor-pid-control.service"

SRC_URI += " \
    file://default.json \
	file://set-platform-json-config.sh \
	file://0001-Supports-fan-manual-mode.patch \
"
FILES:${PN} += " \
	/usr/share/swampd/default.json \
	/usr/bin/set-platform-json-config.sh \
"

do_install:append() {
    install -d ${D}/${config_datadir}
    install -m 0644 ${WORKDIR}/default.json ${D}/${config_datadir}
    install -m 0755 ${WORKDIR}/set-platform-json-config.sh ${D}/usr/bin/
}
