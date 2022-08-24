#!/bin/bash
bus=3
address=0x53
offset=0x30
tmp=$(i2ctransfer -y -f $bus w2@$address $offset 0x00 r32)
for str in $tmp;do
    if [[ $str != 0x00 ]]; then
        str=$(printf "%d" "$str")
        version=$(echo "$str" | awk '{printf("%c", $str)}')
        biosversion="$biosversion$version"
    fi
done
echo "BIOS version got from epprom:$biosversion"
if [ "$biosversion" == "" ]; then
    echo "BIOS version is null, skip"
else
    mapper wait /xyz/openbmc_project/software/bios_active
    busctl set-property xyz.openbmc_project.Software.BMC.Updater /xyz/openbmc_project/software/bios_active xyz.openbmc_project.Software.Version Version s "${biosversion}"
    echo "Restored BIOS version ${biosversion}"
fi

