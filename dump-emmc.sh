#!/bin/sh
#
# This script will dump the raw emmc onto the usb splitting every 4GB if needed.
#
mediafs="$(df -T | grep -Ee ' /media$' | awk -e '{ print $2 }')"
killall -KILL sonyapp

mount -o remount,ro /data
mount -o remount,ro /gaadata

if [ "$mediafs" == "vfat" ]; then
  dd if=/dev/mmcblk0 bs=1M | split -a3 -b4294967295 - "/media/mmcblk0.bin."
else
  dd if=/dev/mmcblk0 bs=1M > /media/mmcblk0.bin
fi

sync

mount -o remount,rw /data
mount -o remount,rw /gaadata

systemctl start sonyapp.service &
