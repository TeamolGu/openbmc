#!/bin/bash
bus=0
address=0x0d
offset="0x05 0x00"
str=$(i2ctransfer -y $bus w2@$address $offset r1)
version=$(printf "%d" $str)
echo "CPLD version got from I2C:$version"
if [ "$version" == "" ]; then
    echo "CPLD version is null, skip"
else
    mapper wait /xyz/openbmc_project/software/cpld_active
    busctl set-property xyz.openbmc_project.Software.BMC.Updater /xyz/openbmc_project/software/cpld_active xyz.openbmc_project.Software.Version Version s ${version}
    echo "Restored CPLD version ${version}"
fi

