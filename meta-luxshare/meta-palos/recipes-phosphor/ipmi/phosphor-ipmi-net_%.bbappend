RMCPP_EXTRA = "eth0"
SYSTEMD_SERVICE:${PN} += " \
        ${PN}@${RMCPP_EXTRA}.service \
        ${PN}@${RMCPP_EXTRA}.socket \
        "
