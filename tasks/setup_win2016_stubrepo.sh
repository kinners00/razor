#!/bin/bash
echo "Checking for existence of Windows 2016 ISO..."
if [ -e /root/SW_DVD9_Win_Svr_STD_Core_and_DataCtr_Core_2016_64Bit_English_-2_MLF_X21-22843.ISO ]
 then
  echo "Windows 2016 ISO found, continuing..."
  echo "Creating win2016 repository..."
  razor create-repo --name win2016 --task windows/2016 --no-content true
  echo "Filling win2016 repository with contents of Windows 2016 ISO..."
  mount -o loop /root/SW_DVD9_Win_Svr_STD_Core_and_DataCtr_Core_2016_64Bit_English_-2_MLF_X21-22843.ISO /mnt
  cp -pr /mnt/* /opt/puppetlabs/server/data/razor-server/repo/win2016
  umount /mnt
  chown -R pe-razor: /opt/puppetlabs/server/data/razor-server/repo/win2016
  echo "Done!"
 else
  echo "Windows 2016 ISO not found, canceling..."
  echo "Ensure this file exists: /root/SW_DVD9_Win_Svr_STD_Core_and_DataCtr_Core_2016_64Bit_English_-2_MLF_X21-22843.ISO"
  exit 1
fi