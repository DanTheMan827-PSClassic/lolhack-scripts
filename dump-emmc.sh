#!/bin/sh
#
# This script will dump the raw emmc onto the usb splitting every 4GB if needed.
#
mediafs="$(df -T | grep -Ee ' /media$' | awk -e '{ print $2 }')"
killall -KILL sonyapp

mount -o remount,ro /data
mount -o remount,ro /gaadata

if [ "$mediafs" == "vfat" ]; then
  dd if=/dev/mmcblk0 bs=1M | gzip | split -a3 -b4294967295 - "/media/mmcblk0.bin.gz."
else
  dd if=/dev/mmcblk0 bs=1M | gzip > /media/mmcblk0.bin.gz
fi

sync

shutdown -h
