#!/bin/sh
set -xe
image_name=android-x86

dd if=/dev/zero of=/android/target/$image_name.img bs=1M count=$((1024*4))
sfdisk /android/target/$image_name.img < android-x86.sfdisk

lofile=`losetup -f`

losetup -P $lofile /android/target/$image_name.img

mkfs -t ext4 ${lofile}p1
mkdir -p /mnt/$image_name
mount ${lofile}p1 /mnt/$image_name

mkdir -p /mnt/$image_name/boot/
mkdir -p /mnt/$image_name/grub/

echo "(hd0) $lofile" > $image_name.map
grub-install --no-floppy --grub-mkdevicemap=$image_name.map --modules="part_msdos" --boot-directory=/mnt/$image_name $lofile

mkdir -p /mnt/$image_name/data
mkdir -p /mnt/$image_name/system

cp -r /android/rootfs/* /mnt/$image_name

umount /mnt/$image_name
losetup -d $lofile

qemu-img convert -f raw -O vpc /android/target/$image_name.img /android/target/$image_name.vhd
# tar -zvcf $image_name.tar.gz $image_name.vhd
