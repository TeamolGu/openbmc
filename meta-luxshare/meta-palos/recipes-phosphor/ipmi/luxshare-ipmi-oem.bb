SUMMARY = "Luxshare OEM commands"
DESCRIPTION = "Luxshare OEM commands"
PR = "r1"
PV = "1.0+git${SRCPV}"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

DEPENDS = "boost phosphor-ipmi-host phosphor-logging phosphor-ipmi-fru systemd libgpiod"

inherit cmake obmc-phosphor-ipmiprovider-symlink

# EXTRA_OECMAKE="-DENABLE_TEST=0 -DYOCTO=1"

LIBRARY_NAMES = "libluxshareoemcmds.so"

S = "${WORKDIR}/git"
SRC_URI = "git://10.53.19.12/openbmc/luxshare-ipmi-oem.git;branch=master;protocol=http"
# SRCREV = "${AUTOREV}"
SRCREV = "a17931cb26e6f8e384ea295be5990f30316c2301"

HOSTIPMI_PROVIDER_LIBRARY += "${LIBRARY_NAMES}"
NETIPMI_PROVIDER_LIBRARY += "${LIBRARY_NAMES}"

FILES:${PN}:append = " ${libdir}/ipmid-providers/lib*${SOLIBS}"
FILES:${PN}:append = " ${libdir}/host-ipmid/lib*${SOLIBS}"
FILES:${PN}:append = " ${libdir}/net-ipmid/lib*${SOLIBS}"
FILES:${PN}-dev:append = " ${libdir}/ipmid-providers/lib*${SOLIBSDEV}"

do_install:append(){
   install -d ${D}${includedir}/luxshare-ipmi-oem
   install -m 0644 -D ${S}/include/*.hpp ${D}${includedir}/luxshare-ipmi-oem
}
