FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRCREV = "a9f68bb5f8e9cfe03fc8b31be5558d4bef20a5f4"

EXTRA_OEMESON:append = " \
    -Drest=enabled \
    -Dhttp-body-limit=65 \   
    -Dinsecure-tftp-update=enabled \
    -Dredfish-dbus-log=enabled \   
    "

