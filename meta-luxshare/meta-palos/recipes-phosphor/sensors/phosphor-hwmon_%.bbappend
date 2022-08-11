FILESEXTRAPATHS:prepend:palos:= "${THISDIR}/${PN}:"

EXTRA_OEMESON:append:palos = " -Dnegative-errno-on-fail=true"

CHIPS = " \
        bus@1e78a000/i2c-bus@1c0/tmp468@48 \
        pwm-tacho-controller@1e786000 \
        "
ITEMSFMT = "ahb/apb/{0}.conf"

ITEMS = "${@compose_list(d, 'ITEMSFMT', 'CHIPS')}"

ITEMS += "iio-hwmon.conf"


ENVS = "obmc/hwmon/{0}"
SYSTEMD_ENVIRONMENT_FILE:${PN}:append:palos = " ${@compose_list(d, 'ENVS', 'ITEMS')}"

