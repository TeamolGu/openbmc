FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
    file://0001-Add-support-for-tmp468.patch \
	file://0001-Add-support-for-NonRecoverable-alarms.patch \
"
PACKAGECONFIG:append = " \
				   tmp468temp \
				   "
PACKAGECONFIG[tmp468temp] = "-Dtmp468-temp=enabled"
SYSTEMD_SERVICE:${PN} += "${@bb.utils.contains('PACKAGECONFIG', 'tmp468temp', \
                                               'xyz.openbmc_project.tmp468sensor.service', \
                                               '', d)}"
