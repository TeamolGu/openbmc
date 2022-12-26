FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://led-group-config.json \
				   file://xyz.openbmc_project.LED.GroupManager.service.new \
"
do_install:append() {
        install -m 0644 ${WORKDIR}/led-group-config.json ${D}${datadir}/phosphor-led-manager/
        install -m 0644 ${WORKDIR}/xyz.openbmc_project.LED.GroupManager.service.new ${D}${systemd_system_unitdir}/xyz.openbmc_project.LED.GroupManager.service
}
