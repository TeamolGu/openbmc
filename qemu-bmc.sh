#!/bin/bash

machine=g220a-bmc
target="./build/palos/tmp/deploy/images/palos/image-bmc"
#target="./obmc-phosphor-image-evb-ast2500-20220713080538.static.mtd"

if [ -z $1 ];then
./qemu-system-arm -m 512 -machine $machine -nographic -drive file=$target,format=raw,if=mtd -net nic -net user,hostfwd=:$1:2222-:22,hostfwd=:$1:2443-:443,hostname=qemu
elif [ -z $2 ];then
./qemu-system-arm -m 512 -machine $machine -nographic -drive file=$2,format=raw,if=mtd -net nic -net user,hostfwd=:$1:2222-:22,hostfwd=:$1:2443-:443,hostname=qemu
else
./qemu-system-arm -m 512 -machine $machine -nographic -drive file=$target,format=raw,if=mtd -net nic -net user,hostfwd=:10.53.17.25:2222-:22,hostfwd=:10.53.17.25:2443-:443,hostname=qemu
fi
