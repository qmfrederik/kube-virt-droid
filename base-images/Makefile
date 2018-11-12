TAG_PREFIX="quamotion/android-x86"
TAG_SUFFIX="7.1-r2"
LIVECD="android-x86_64-7.1-r2.iso"
ISO_URL="https://osdn.net/dl/android-x86/android-x86_64-7.1-r2.iso"

all: docker-kernel docker-system docker-initrd docker-ramdisk

docker-kernel: kernel/kernel.tar
	( cd kernel && sudo docker build . -t ${TAG_PREFIX}-kernel:${TAG_SUFFIX} )

docker-system: system/system.tar
	( cd system && sudo docker build . -t ${TAG_PREFIX}-system:${TAG_SUFFIX} )

docker-initrd: initrd/initrd.tar
	( cd initrd && sudo docker build . -t ${TAG_PREFIX}-initrd:${TAG_SUFFIX} )

docker-ramdisk: ramdisk/ramdisk.tar
	( cd ramdisk && sudo docker build . -t ${TAG_PREFIX}-ramdisk:${TAG_SUFFIX} )

obj/system.img:
	[ -f ${LIVECD} ] || wget ${ISO_URL}

	[ -d obj/iso ] || mkdir -p obj/iso
	sudo mount -o loop ${LIVECD} obj/iso
	cp obj/iso/system.sfs obj/system.sfs
	cp obj/iso/initrd.img obj/initrd.img
	cp obj/iso/ramdisk.img obj/ramdisk.img
	cp obj/iso/kernel obj/kernel
	sudo umount obj/iso

	unsquashfs -f -d obj obj/system.sfs system.img

obj/kernel: obj/system.img
obj/ramdisk.img: obj/system.img
obj/initrd.img: obj/system.img

kernel/kernel.tar: obj/kernel
	tar -cpf kernel/kernel.tar -C obj/ ./kernel

system/system.tar: obj/system.img
	[ -d obj/system ] || mkdir obj/system
	sudo mount -o ro obj/system.img obj/system
	sudo tar --exclude="system/lost+found" -cpf system/system.tar -C obj/system .
	sudo umount obj/system

initrd/initrd.tar: obj/initrd.img
	[ -d obj/initrd ] || mkdir -p obj/initrd
	(cd obj/initrd && zcat ../initrd.img | cpio -idv)
	sudo tar -cpf initrd/initrd.tar -C obj/initrd .

ramdisk/ramdisk.tar: obj/ramdisk.img
	[ -d obj/ramdisk ] || mkdir -p obj/ramdisk
	(cd obj/ramdisk && zcat ../ramdisk.img | cpio -idv)
	sudo tar -cpf ramdisk/ramdisk.tar -C obj/ramdisk .

clean:
	[ -d obj ] && rm -rf obj
	rm ${LIVECD}
