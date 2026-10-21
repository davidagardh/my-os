#!/bin/bash

set -ouex pipefail

rm -rf /var/lib/ipsec /var/lib/iscsi
# libreswan's own libreswan.conf covers /run/pluto and /var/lib/ipsec/nss
cat << EOF > /usr/lib/tmpfiles.d/libreswan-var.conf
d /var/lib/ipsec 0700 root root - -
EOF
rm -rf /var/roothome/
rm -rf /var/lib/rpm-state/ /var/lib/dnf/

cat << EOF > /usr/lib/tmpfiles.d/libvirt.conf
d /var/lib/libvirt 0755 root root - -
d /var/lib/libvirt/images 0711 root root - -
h /var/lib/libvirt/images - - - - +C
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
d /var/lib/libvirt/qemu/varstore 0751 qemu qemu - -
d /var/lib/libvirt/secrets 0700 root root - -
d /var/lib/swtpm-localca 0750 root root - -
d /var/log/libvirt 0750 root root - -
d /var/log/libvirt/qemu 0750 root root - -
EOF


cat << EOF > /usr/lib/tmpfiles.d/rhsm.conf
d /var/lib/rhsm 0750 root root - -
d /var/lib/rhsm/cache 0750 root root - -
d /var/lib/rhsm/facts 0750 root root - -
d /var/lib/rhsm/packages 0750 root root - -
d /var/lib/rhsm/repo_server_val 0750 root root - -
EOF
rm -r /var/spool/rhsm
