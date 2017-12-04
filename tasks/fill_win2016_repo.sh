#!/bin/bash
mount -o loop /root/SW_DVD9_Win_Svr_STD_Core_and_DataCtr_Core_2016_64Bit_English_-2_MLF_X21-22843.ISO /mnt
cp -pr /mnt/* /opt/puppetlabs/server/data/razor-server/repo/win2016
umount /mnt
chown -R pe-razor: /opt/puppetlabs/server/data/razor-server/repo/win2016