#!/bin/bash

#machine=g220a-bmc
#target="./build/palos/tmp/deploy/images/palos/image-bmc"
##target="./obmc-phosphor-image-evb-ast2500-20220713080538.static.mtd"
#
#if [ -z $1 ];then
#./qemu-system-arm -m 512 -machine $machine -nographic -drive file=$target,format=raw,if=mtd -net nic -net user,hostfwd=:$1:2222-:22,hostfwd=:$1:2443-:443,hostname=qemu
#elif [ -z $2 ];then
#./qemu-system-arm -m 512 -machine $machine -nographic -drive file=$2,format=raw,if=mtd -net nic -net user,hostfwd=:$1:2222-:22,hostfwd=:$1:2443-:443,hostname=qemu
#else
#./qemu-system-arm -m 512 -machine $machine -nographic -drive file=$target,format=raw,if=mtd -net nic -net user,hostfwd=:10.53.17.25:2222-:22,hostfwd=:10.53.17.25:2443-:443,hostname=qemu
#fi

function usage()
{
	echo "Usage:"
	echo "    $0 <image> <machine>"
	echo "Example:"
	echo "    $0                      Start qemu use default image"
	echo "    $0 xxx.mtd              Start qemu use specify image"
	echo "    $0 xxx.mtd ast2500-evb  Start qemu use specify image and machine"
	echo
}

if [[ -n $1 ]] && [[ $1 == "-h" ]]; then
	usage
	exit 0
fi

echo "Info: check image..."
if [[ -n $1 ]] && [[ -e $1 ]]; then
        image=$1
else
        image=./build/palos/tmp/deploy/images/palos/image-bmc
fi
if [[ ! -e $image ]]; then
	echo "Warning: Not found $image, use default image"
	image=./obmc-phosphor-image-evb-ast2500-20220713080538.static.mtd
fi
echo "Info: image is $image"

if [[ -n $2 ]]; then
        machine=$2
else
        #machine=ast2500-evb
        machine=g220a-bmc
fi
echo "Info: Machine is $machine"

# Get local host ip address
dev=`ip route  | grep default | egrep -o "dev [a-z0-9]*" | cut -d " " -f2`
if [[ -z $dev ]]; then
        dev=`ip route  | head -1 | egrep -o "dev [a-z0-9]*" | cut -d " " -f2`
fi
ip=`ip addr show $dev | egrep -o "inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | egrep -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"`
if [[ -z $ip ]]; then
        ip=127.0.0.1
fi
echo "Info: bind ip is $ip"

# Check 2443 port
fwd=2
if netstat -natp | grep 2443 &> /dev/null; then
	echo "Warning: Tcp port 2443 is in use, Please select another port to use"
	read -p "input 3-9: " fwd
fi
echo "Info: Map qemu net port to host:"
echo "tcp port 22  -> ${fwd}222"
echo "tcp port 443 -> ${fwd}443"
echo "tcp port 80  -> ${fwd}080"
echo "udp port 623 -> ${fwd}623"

# Check qemu tools
qemu=/home/openbmc/qemu-system-arm
if [[ ! -e $qemu ]]; then
        if [[ ! -e ./qemu-system-arm ]]; then
                echo "Error: not found qemu-system-arm"
                exit
        fi
        qemu=./qemu-system-arm
fi

echo "Run qemu..."
$qemu -m 512 -machine $machine -nographic \
    -drive file=$image,format=raw,if=mtd \
    -net nic \
    -net user,hostfwd=:$ip:${fwd}222-:22,hostfwd=:$ip:${fwd}443-:443,hostfwd=tcp:$ip:${fwd}080-:80,hostfwd=udp:$ip:${fwd}623-:623,hostname=qemu

