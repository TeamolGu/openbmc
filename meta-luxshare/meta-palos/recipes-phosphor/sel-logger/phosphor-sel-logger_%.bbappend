FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
    file://0001-Add-support-for-NonRecoverable-alarms-for-sel-logger.patch \
"

DEPENDS += " \
	phosphor-logging \
  "


EXTRA_OEMESON:append = " -Dlog-threshold=true"
EXTRA_OEMESON:append = " -Dsend-to-logger=true"
EXTRA_OEMESON:append = " -Dclears-sel=false"

EXTRA_OEMESON:append = " -Dlog-pulse=false"
EXTRA_OEMESON:append = " -Dlog-watchdog=false"
EXTRA_OEMESON:append = " -Dlog-alarm=false"

