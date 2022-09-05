#!/bin/sh
#fw path info
image_path=/tmp/images/$1/
image=/tmp/images/$1/bios.bin
manifest=/tmp/images/$1/MANIFEST
type='bios'
#mux info
i2c_bus=0
i2c_addr=0xd
switch_reg=0x51
tpcm_status_reg=0x42
#platform info
bmc_spi_bus_info="1e630000.spi"
aspeed_smc_bind_path="/sys/bus/platform/drivers/aspeed-smc/"
bios_mtd_path="/dev/mtd/bios"
#dbus info for ipmb
ipmb_obj="xyz.openbmc_project.Ipmi.Channel.Ipmb"
ipmb_path="/xyz/openbmc_project/Ipmi/Channel/Ipmb"
ipmb_if="org.openbmc.Ipmb"
ipmb_call="sendRequest yyyyay"
#me cmd info
me_recovery_args="0x01 0x2e 0x0 0xdf 0x04 0x57 0x01 0x00 0x01"
me_reset_args="0x01 0x06 0x00 0x02 0x0"
me_query_args="0x01 0x06 0x00 0x04 0x0"

function flash_bios() {
    gen-bios-fw $image $bios_mtd_path
    flashcp $image $bios_mtd_path
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
    reg_value="`i2ctransfer -f -y $i2c_bus w1@$i2c_addr $tpcm_status_reg r1`"
    tpcm_exist="`expr $[$reg_value & 0x40]`"
    if [[ $tpcm_exist -eq 0 ]]; then
        echo "[Info]: TPCM exists, checking TPCM status"
        reg_value="`i2ctransfer -f -y $i2c_bus w1@$i2c_addr $tpcm_status_reg r1`"
        tpcm_done="`expr $[$reg_value & 0x80]`"
        if [[ $tpcm_done -ne 0 ]]; then
            echo "[Error]: TPCM is being measured, exiting"
            exit -4
        fi
    fi
}

function switch_rom_to_bmc() {
    echo "[Info]: Set ME into recovery mode"
    busctl call $ipmb_obj $ipmb_path $ipmb_if $ipmb_call $me_recovery_args
    sleep 3
    me_res="`busctl call $ipmb_obj $ipmb_path $ipmb_if $ipmb_call $me_query_args`"
    retry=3
    while [[ 0 -ne retry ]];do
        if [[ $me_res == *"129 2"* ]];then
            echo "[Info]: ME is in recovery mode"
            break
        fi
        echo "[Info]: ME is not in recovery mode, retrying"
        busctl call $ipmb_obj $ipmb_path $ipmb_if $ipmb_call $me_recovery_args
        sleep 3
        me_res="`busctl call $ipmb_obj $ipmb_path $ipmb_if $ipmb_call $me_query_args`"
        retry=$[$retry - 1]
    done
    if [[ $me_res != *"129 2"* ]];then
        echo "[Error]: Can not set ME into recovery mode, exiting"
        exit -5
    fi
    reg_status="`i2ctransfer -f -y $i2c_bus w1@$i2c_addr $switch_reg r1`"
    write_reg="`expr $[$reg_status | 0x2]`"
    reg_hex="`printf 0x%x $write_reg`"
    i2ctransfer -f -y $i2c_bus w2@$i2c_addr $switch_reg $reg_hex
    echo -n $bmc_spi_bus_info > ${aspeed_smc_bind_path}/bind
    sleep 3
    if [[ ! -e $bios_mtd_path ]];then
        echo "[Error]: Can not find ${type} flash, exiting"
        switch_rom_to_soc
        busctl call $ipmb_obj $ipmb_path $ipmb_if $ipmb_call $me_reset_args
        exit -6
    fi
}

function switch_rom_to_soc() {
    echo "[Info]: Switch $type flash into SOC access mode"
    echo -n $bmc_spi_bus_info > ${aspeed_smc_bind_path}/unbind
    reg_status="`i2ctransfer -f -y $i2c_bus w1@$i2c_addr $switch_reg r1`"
    write_reg="`expr $[$reg_status & 0xfd]`"
    reg_hex="`printf 0x%x $write_reg`"
    i2ctransfer -f -y $i2c_bus w2@0xd $switch_reg $reg_hex
    sleep 5
    echo "[Info]: Reset ME"
    busctl call $ipmb_obj $ipmb_path $ipmb_if $ipmb_call $me_reset_args
}

#require_check
#switch_rom_to_bmc
#flash_bios
#switch_rom_to_soc
# test bios
echo test bios $@ >> /testbios.log
