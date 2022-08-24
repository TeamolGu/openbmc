FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
    file://restore-bios.conf \
    file://restore-cpld.conf \
    file://restore-bios-version.sh \
    file://restore-cpld-version.sh \
    file://0001-Add-the-Bios-and-CPLD-version-paths.patch \
"

PACKAGECONFIG[flash_cpld] = "-Dhost-cpld-upgrade=enabled, -Dhost-cpld-upgrade=disabled"

SYSTEMD_SERVICE:${PN}-updater += " \
    obmc-flash-host-bios@.service \
    obmc-flash-host-cpld@.service \
"

SYSTEMD_SERVICE:${PN}-updater += "${@bb.utils.contains('PACKAGECONFIG', 'flash_cpld', 'obmc-flash-host-cpld@.service', '', d)}"

EXTRA_OEMESON:append = " -Dhost-bios-upgrade=enabled"
EXTRA_OEMESON:append = " -Dhost-cpld-upgrade=enabled"

FILES:${PN} += "/lib/systemd/system/xyz.openbmc_project.Software.BMC.Updater.service.d"

do_install:append() {
    install -d ${D}/lib/systemd/system/xyz.openbmc_project.Software.BMC.Updater.service.d/
    install -m 0644 ${WORKDIR}/restore-bios.conf ${D}/lib/systemd/system/xyz.openbmc_project.Software.BMC.Updater.service.d/
    install -m 0644 ${WORKDIR}/restore-cpld.conf ${D}/lib/systemd/system/xyz.openbmc_project.Software.BMC.Updater.service.d/
    install -m 0755 ${WORKDIR}/restore-bios-version.sh ${D}/usr/bin/
    install -m 0755 ${WORKDIR}/restore-cpld-version.sh ${D}/usr/bin/
}

