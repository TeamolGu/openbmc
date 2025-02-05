SUMMARY = "Phosphor OpenBMC KCS to DBUS"
DESCRIPTION = "Phosphor OpenBMC KCS to DBUS."
PR = "r1"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b1beb00e508e89da1ed2a541934f28c0"

inherit meson pkgconfig
inherit systemd

PV = "1.0+git${SRCPV}"

KCS_DEVICE ?= "ipmi-kcs3"

SYSTEMD_SERVICE:${PN} = "${PN}@${KCS_DEVICE}.service"
FILES:${PN} += "${systemd_system_unitdir}/${PN}@.service"

PROVIDES += "virtual/obmc-host-ipmi-hw"
RPROVIDES:${PN} += "virtual-obmc-host-ipmi-hw"
RRECOMMENDS:${PN} += "phosphor-ipmi-host"

DEPENDS += " \
        fmt \
        sdbusplus \
        sdeventplus \
        stdplus \
        systemd \
        "

S = "${WORKDIR}/git"
SRC_URI = "git://github.com/openbmc/kcsbridge.git;branch=master;protocol=https"
SRCREV = "bc7bf463229b69bb2346cc66f1e4b9f65f5374bd"
