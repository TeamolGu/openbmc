SUMMARY = "Phosphor OpenBMC machine readable workbook API modules"
DESCRIPTION = "The API for the MRW XML generated by the Serverwiz tool"
PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=d2794c0df5b907fdace235a619d80314"

S = "${WORKDIR}/git"

inherit native
inherit perlnative
inherit cpan-base
inherit mrw-rev

DEPENDS += "libxml-simple-perl-native libjson-perl-native"

SRC_URI += "${MRW_API_SRC_URI}"
SRCREV = "${MRW_API_SRCREV}"

do_install() {
    install -d ${D}${PERLLIBDIRS:class-native}/site_perl/${PERLVERSION}/mrw
    install -m 0755 scripts/Targets.pm ${D}${PERLLIBDIRS:class-native}/site_perl/${PERLVERSION}/mrw/Targets.pm
}
