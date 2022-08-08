DEPENDS:append:palos= " palos-yaml-config"

EXTRA_OECONF:palos= " \
    YAML_GEN=${STAGING_DIR_HOST}${datadir}/palos-yaml-config/ipmi-fru-read.yaml \
    PROP_YAML=${STAGING_DIR_HOST}${datadir}/palos-yaml-config/ipmi-extra-properties.yaml \
    "
