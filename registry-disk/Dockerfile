FROM quamotion/android-x86-kernel:7.1-r2 AS kernel

FROM quamotion/android-x86-ramdisk:7.1-r2 AS ramdisk

FROM quamotion/android-x86-initrd:7.1-r2 AS initrd

FROM quamotion/android-x86-system:7.1-r2 AS system

FROM quamotion/android-x86-build:latest

WORKDIR /android/initrd
COPY --from=initrd / .

WORKDIR /android/ramdisk
COPY --from=ramdisk / .

# Copy the kernel and system images "as is",
# extract the compressed initrd and ramdisk images

WORKDIR /android/rootfs
COPY --from=kernel /kernel .

WORKDIR /android/rootfs/system
COPY --from=system / .

# Update the ramdisk
WORKDIR /android
RUN mkbootfs ./ramdisk | gzip > rootfs/ramdisk.img \
&& mkbootfs ./initrd | gzip > rootfs/initrd.img

# Make the vhd
WORKDIR /android/rootfs
RUN mkdir data

WORKDIR /android
COPY grub.cfg /android/rootfs/grub/grub.cfg
COPY android-x86.sfdisk .
COPY make-vhd.sh .

CMD [ /android/make-vhd.sh ]
