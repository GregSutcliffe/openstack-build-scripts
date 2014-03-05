#!/bin/bash

# Build using ./build-openstack-debian-image -r wheezy -hs ./customize.sh -ar

# Set a passwd since we can't deploy keys - using the passwd field in cloud-init
# doesn't seem happy...
echo "debian:debian" | chroot $BODI_CHROOT_PATH chpasswd

chroot $BODI_CHROOT_PATH wget http://ftp.de.debian.org/debian/pool/main/c/cloud-utils/cloud-utils_0.26-2~bpo70+1_all.deb
chroot $BODI_CHROOT_PATH wget http://ftp.de.debian.org/debian/pool/main/c/cloud-initramfs-tools/cloud-initramfs-growroot_0.18.debian3~bpo70+1_all.deb
chroot $BODI_CHROOT_PATH dpkg -i *deb
chroot $BODI_CHROOT_PATH rm *deb

cp ./growroot.new ${BODI_CHROOT_PATH}/usr/share/initramfs-tools/scripts/local-bottom/growroot
echo "
copy_exec /sbin/fsck /sbin
copy_exec /sbin/fsck.ext2 /sbin
copy_exec /sbin/fsck.ext3 /sbin
copy_exec /sbin/fsck.ext4 /sbin
copy_exec /sbin/resize2fs /sbin
" >> ${BODI_CHROOT_PATH}/usr/share/initramfs-tools/hooks/growroot 

chroot $BODI_CHROOT_PATH update-initramfs -u
