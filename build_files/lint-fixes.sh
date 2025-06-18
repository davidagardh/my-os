#!/bin/bash

echo 'u gluster 992:964 "GlusterFS daemons" /run/gluster /sbin/nologin' > /usr/lib/sysusers.d/gluster.conf
echo 'g gluster 964' >> /usr/lib/sysusers.d/gluster.conf

echo 'g libvirt 963' > /usr/lib/sysusers.d/libvirt.conf
echo 'g qat 995' > /usr/lib/sysusers.d/qat.conf

rm -rf /var/lib/ipsec /var/lib/iscsi
rm -rf /var/roothome/
rm -rf /var/lib/rpm-state/

cat << EOF > /usr/lib/tmpfiles.d/libvirt.conf
d /var/lib/libvirt 0755 root root - -
d /var/lib/libvirt/images 0711 root root - -
h /var/lib/libvirt/images NODATACOW
d /var/lib/libvirt/boot 0711 root root - -
d /var/lib/libvirt/dnsmasq 0755 root root - -
d /var/lib/libvirt/filesystems 0711 root root - -
d /var/lib/libvirt/network 0700 root root - -
d /var/lib/libvirt/swtpm 0711 root root - -
d /var/lib/libvirt/qemu 0751 qemu qemu - -
d /var/lib/libvirt/qemu/checkpoint 0751 qemu qemu - -
d /var/lib/libvirt/qemu/dump 0751 qemu qemu - -
d /var/lib/libvirt/qemu/nvram 0751 qemu qemu - -
d /var/lib/libvirt/qemu/ram 0751 qemu qemu - -
d /var/lib/libvirt/qemu/save 0751 qemu qemu - -
d /var/lib/libvirt/qemu/snapshot 0751 qemu qemu - -
d /var/lib/swtpm-localca 0750 root root - -
d /var/log/libvirt 0750 root root - -
d /var/log/libvirt/qemu 0750 root root - -
EOF

