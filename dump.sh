#!/bin/sh
#
# This script will dump the root, data, and gaadata filesystems onto the usb splitting gaadata every 4GB.
#
killall -KILL sonyapp
mount -o remount,ro /data
mount -o remount,ro /gaadata
dd if=/dev/mapper/gaadata | split -a3 -b4294967295 - "/media/gaadata.bin."
dd if=/dev/mmcblk0p10 > /media/data.bin
dd if=/dev/root > /media/root.bin
sync
mount -o remount,rw /data
mount -o remount,rw /gaadata
systemctl start sonyapp.service &
