#!/bin/bash
#
# Shell script to install Bluetooth firmware and attach BT part of
# RTL8723BS
#
# Find the TTY attached to the BT device
TTYSTRING=`dmesg -t | grep tty | grep MMIO | cut -b 14-18`
TTY=`expr substr "$TTYSTRING" 1 5`

if [ "$TTYSTRING" = "" ]
then
	echo
	echo "No BT TTY device has been found"
	echo "Either this computer has no BT device that uses hciattach, or"
	echo "Your kernel does not have module 8250_dw configured."
	echo "Note: The configuration variable is CONFIG_SERIAL_8250_DW."
	echo
	exit 1
fi

TTY="/dev/$TTY"
echo "Using device $TTY for Bluetooth"

if [ ! -f /lib/firmware/rtlbt/rtlbt_config ];
then
	mkdir -p /lib/firmware/rtlbt/
	cp rtlbt_* /lib/firmware/rtlbt/.
fi
./rtk_hciattach -n -s 115200 $TTY rtk_h5 > hciattach.txt 2>&1 &

