#!/bin/sh

#fw path info
image_path=/tmp/images/$1/
image=/tmp/images/$1/bios.bin
manifest=/tmp/images/$1/MANIFEST
type='bios'

#mux info
i2c_bus=0
i2c_addr=0xd
switch_reg="0xa0 0x03"

#platform info
bmc_spi_bus_info="1e630000.spi"
aspeed_smc_bind_path="/sys/bus/platform/drivers/spi-aspeed-smc/"
bios_mtd_path="/dev/mtd/bios"

function flash_bios() {
    flashcp -v $image $bios_mtd_path
    if [[ $? -ne 0 ]];then
        echo "[Error]: Flash $type failed"
        switch_rom_to_soc
        exit -7
    fi
    echo "[Info]: Flash $type successfully"
}

function require_check() {
    if [[ ! -f $image ]];then
        echo "[Error]: Can not find $type image, exiting"
        exit -1
    fi
    if [[ -f $manifest ]];then
        echo "[Info]: manifest file found"
    fi
    status="`ipmitool power status`"
    if [[ $? -ne 0 ]]; then
        echo "[Error]: Can not get power status, exiting"
        exit -2
    fi
    if [[ $status == *"on"* ]]; then
        echo "[Error]: Power is ON, can not flash $type, exiting"
        exit -3
    fi
}

function try_unbind()
{
	if ls $aspeed_smc_bind_path|grep $bmc_spi_bus_info; then
		echo -n $bmc_spi_bus_info > ${aspeed_smc_bind_path}/unbind
#		sleep 5
	fi
}

function switch_rom_to_bmc() {
	try_unbind
    reg_status="`i2ctransfer -f -y $i2c_bus w2@$i2c_addr $switch_reg r1`"
    write_reg="`expr $[$reg_status | 0x80]`"
    reg_hex="`printf 0x%x $write_reg`"
    i2ctransfer -f -y $i2c_bus w3@$i2c_addr $switch_reg $reg_hex
    echo -n $bmc_spi_bus_info > ${aspeed_smc_bind_path}/bind
    sleep 3
    if [[ ! -e $bios_mtd_path ]];then
        echo "[Error]: Can not find ${type} flash, exiting"
        switch_rom_to_soc
        exit -6
    fi
}

function switch_rom_to_soc() {
    echo "[Info]: Switch $type flash into SOC access mode"
    echo -n $bmc_spi_bus_info > ${aspeed_smc_bind_path}/unbind
    reg_status="`i2ctransfer -f -y $i2c_bus w2@$i2c_addr $switch_reg r1`"
    write_reg="`expr $[$reg_status & 0x7f]`"
    reg_hex="`printf 0x%x $write_reg`"
    i2ctransfer -f -y $i2c_bus w3@$i2c_addr $switch_reg $reg_hex
    sleep 5
}

#require_check
switch_rom_to_bmc
flash_bios
switch_rom_to_soc
