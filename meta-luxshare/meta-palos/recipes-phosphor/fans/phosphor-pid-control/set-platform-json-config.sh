#!/bin/sh
# Set all the fans to run at full speed at boot time

set -e

boardID=0
bus=0
address=0x0d
offset="0x03 0x00"

boardFile_10=/usr/share/swampd/palos-config.json

# First remove the old link to make sure we set correct path
rm -f /usr/share/swampd/config.json

# Read Board ID from u-boot env
tempID=`i2ctransfer -y $bus w2@$address $offset r1`
boardID=`echo $(($tempID & 0x07))`
echo "[Info] boardID is: "$boardID

# Set soflink for platform dependent config.json file
case $boardID in
   ""|"")  # Onyx board_ids
	if [[ -f $boardFile_10 ]]; then
		ln -s $boardFile_10 /usr/share/swampd/config.json
		echo "[Info] set palos-config.json"
	else
		echo "[Warning] boardID is not supported"
	fi
   ;;
esac

# Default set
if [[ ! -f /usr/share/swampd/config.json ]] && [[ -f /usr/share/swampd/default.json ]]; then
	ln -s /usr/share/swampd/default.json /usr/share/swampd/config.json
	echo "[Info] try set default config"
fi
