FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"
SRC_URI:append = " file://palos_baseboard.json \
                   file://blocklist.json \
                   file://blacklist.json \
		"
do_install:append() {
     install -m 0644 -D ${WORKDIR}/blacklist.json ${D}${datadir}/${PN}/blacklist.json
     install -d ${D}/usr/share/entity-manager/configurations
     rm -rf ${D}/usr/share/entity-manager/configurations/*.json
     install -m 0444 ${WORKDIR}/palos_baseboard.json ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/blocklist.json ${D}/usr/share/entity-manager/configurations
}
