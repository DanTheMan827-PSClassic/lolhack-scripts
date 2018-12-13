#!/bin/sh
#
# This script will dump the root, data, and gaadata filesystems onto the usb splitting gaadata every 4GB.
#
mediafs="$(df -T | grep -Ee ' /media$' | awk -e '{ print $2 }')"
killall -KILL sonyapp

mount -o remount,ro /data
mount -o remount,ro /gaadata

if [ "$mediafs" == "vfat" ]; then
  dd if=/dev/mapper/gaadata bs=1M | split -a3 -b4294967295 - "/media/gaadata.bin."
else
  dd if=/dev/mapper/gaadata bs=1M > /media/gaadata.bin
fi

dd if=/dev/mmcblk0p10 bs=1M > /media/data.bin

rootdevice="$(mount | grep ' on / ' | awk -e '{ print $1 }')"
dd "if=$rootdevice" bs=1M > /media/root.bin

sync

mount -o remount,rw /data
mount -o remount,rw /gaadata

systemctl start sonyapp.service &
