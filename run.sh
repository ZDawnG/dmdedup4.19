#!/bin/bash
META_DEV=/dev/nvme0n1
DATA_DEV=/dev/nvme1n1
DATA_DEV_SIZE=$(sudo blockdev --getsz $DATA_DEV)
TARGET_SIZE=$(expr $DATA_DEV_SIZE \* 15 / 10)
sudo cp ./dm-dedup.ko /lib/modules/4.19.0/kernel/drivers/md
sudo depmod -a
sudo modprobe dm-dedup
sudo dd if=/dev/zero of=$META_DEV bs=4096 count=1
echo "0 $TARGET_SIZE dedup $META_DEV $DATA_DEV 4096 md5 cowbtree 100 0" | sudo dmsetup create mydedup
