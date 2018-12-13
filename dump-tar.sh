#!/bin/sh
#
# This script will dump the root, data, and gaadata partitions onto the usb as tar archives splitting gaadata every 4GB.
#
killall -KILL sonyapp

mount -o remount,ro /data
mount -o remount,ro /gaadata

tar -cf - -C "/gaadata" . bs=1M | split -a3 -b4294967295 - "/media/gaadata.tar."
tar -cf - -C /data . > /media/data.tar

mkdir /tmp/root
mount -o ro /dev/root /tmp/root
tar -cf - -C /tmp/root . > /media/root.tar
umount /tmp/root
rmdir /tmp/root

sync

mount -o remount,rw /data
mount -o remount,rw /gaadata

systemctl start sonyapp.service &
