#!/bin/sh
image_path=/tmp/images/$1/
image=/tmp/images/$1/cpld.jed
manifest=/tmp/images/$1/MANIFEST
type='cpld'
cfg_i2c_bus=/dev/i2c-54

function flash_cpld() {
    if [[ ! -f $image ]]; then
        echo "[Error]: $image not found"
        exit -3
    fi
    echo "[Info]: Start flashing {${type}} using Bus {${cfg_i2c_bus}} , address {${cfg_i2c_addr}(7-bit)}"
	cpld_update_tool --i2cDev ${cfg_i2c_bus} --update ${image}
    if [[ $? -ne 0 ]];then
        echo "[Error]: Flash ${type} failed"
        exit -4
    fi
    echo "[Info]: Flash ${type} sucessfully"
}

function require_check() {
    status="`ipmitool power status`"
    if [[ $? -ne 0 ]]; then
        echo "[Error]: Can not get power status , exiting"
        exit -1
    fi
    if [[ $status == *"on"* ]]; then
        echo "[Error]: Power is on can not flash cpld , exiting"
        exit -2
    fi
}

# require_check
flash_cpld
