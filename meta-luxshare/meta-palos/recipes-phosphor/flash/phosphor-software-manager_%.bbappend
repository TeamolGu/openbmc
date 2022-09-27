FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
    file://restore-bios.conf \
    file://restore-cpld.conf \
    file://restore-bios-version.sh \
    file://restore-cpld-version.sh \
	file://obmc-flash-host-bios.sh \
	file://obmc-flash-host-cpld.sh \
    file://0001-Add-the-Bios-and-CPLD-version-paths.patch \
	file://0001-Added-the-support-for-upgrading-CPLD-and-BIOS-firmwa.patch \
	file://0001-add-cpld_update_tool-for-cpld.patch \
	file://0001-modify-meson-files-for-cpld_update_tool.patch \
	file://hashfunc \
	file://publickey \
"

PACKAGECONFIG[flash_cpld] = "-Dhost-cpld-upgrade=enabled, -Dhost-cpld-upgrade=disabled"

SYSTEMD_SERVICE:${PN}-updater += " \
    obmc-flash-host-bios@.service \
    obmc-flash-host-cpld@.service \
"

SYSTEMD_SERVICE:${PN}-updater += "${@bb.utils.contains('PACKAGECONFIG', 'flash_cpld', 'obmc-flash-host-cpld@.service', '', d)}"

EXTRA_OEMESON:append = " -Dhost-bios-upgrade=enabled"
EXTRA_OEMESON:append = " -Dhost-cpld-upgrade=enabled"
EXTRA_OEMESON:append = " -Dbmc-static-dual-image=enabled"
EXTRA_OEMESON:append = " -Dsync-bmc-files=enabled"
RDEPENDS:${PN}-software = " \
        ${VIRTUAL-RUNTIME_obmc-bmc-sync} \
"

FILES:${PN} += "/lib/systemd/system/xyz.openbmc_project.Software.BMC.Updater.service.d \
	/lib/systemd/system/obmc-flash-bmc-alt@.service \
	/lib/systemd/system/obmc-flash-bmc-static-mount-alt.service \
	/lib/systemd/system/obmc-flash-bmc-prepare-for-sync.service \
"

do_install:append() {
    install -d ${D}/lib/systemd/system/xyz.openbmc_project.Software.BMC.Updater.service.d/
    install -d ${D}/etc/activationdata/0penBMC
    install -m 0644 ${WORKDIR}/restore-bios.conf ${D}/lib/systemd/system/xyz.openbmc_project.Software.BMC.Updater.service.d/
    install -m 0644 ${WORKDIR}/hashfunc ${D}/etc/activationdata/0penBMC/
    install -m 0644 ${WORKDIR}/publickey ${D}/etc/activationdata/0penBMC/
    install -m 0644 ${WORKDIR}/restore-cpld.conf ${D}/lib/systemd/system/xyz.openbmc_project.Software.BMC.Updater.service.d/
    install -m 0755 ${WORKDIR}/restore-bios-version.sh ${D}/usr/bin/
    install -m 0755 ${WORKDIR}/restore-cpld-version.sh ${D}/usr/bin/
    install -m 0755 ${WORKDIR}/obmc-flash-host-bios.sh ${D}/usr/bin/
    install -m 0755 ${WORKDIR}/obmc-flash-host-cpld.sh ${D}/usr/bin/
}

