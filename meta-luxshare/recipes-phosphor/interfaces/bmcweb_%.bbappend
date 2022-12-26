FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRCREV = "a9f68bb5f8e9cfe03fc8b31be5558d4bef20a5f4"
SRC_URI += " \
    file://0001-Add-ThresholdNonRecoverable-information-for-sensors-.patch \
"

EXTRA_OEMESON:append = " \
    -Drest=enabled \
    -Dhttp-body-limit=65 \   
    -Dinsecure-tftp-update=enabled \
    -Dredfish-dbus-log=enabled \   
    "

