SUMMARY = "C++ bindings for systemd event APIs"
DESCRIPTION = "C++ bindings for systemd event APIs."
HOMEPAGE = "http://github.com/openbmc/sdeventplus"
PR = "r1"
PV = "0.1+git${SRCPV}"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit meson pkgconfig

DEPENDS += " \
        function2 \
        stdplus \
        systemd \
        "

EXTRA_OEMESON = " \
        -Dexamples=false \
        -Dtests=disabled \
        "

SRC_URI += "git://github.com/openbmc/sdeventplus;branch=master;protocol=https"
SRCREV = "13afebfaa6a2bbb0bc03f4382eb6ba1c50fa6d4d"

S = "${WORKDIR}/git"
