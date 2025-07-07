#!/bin/bash
dnf5 config-manager addrepo --from-repofile=https://repo.fortinet.com/repo/forticlient/7.4/centos/8/os/x86_64/fortinet.repo
dnf5 install -y forticlient

cp -r /opt/forticlient /usr/share/
rm -r /opt/forticlient
grep -Rl '/opt/forticlient' '/usr/share/forticlient' | xargs sed -i 's,/opt/forticlient,/usr/share/forticlient,g'

cat >/usr/lib/tmpfiles.d/forticlient.conf <<EOF
d /var/log/forticlient 0755 root root 5d -
d /var/lib/forticlient 0755 root root - -
EOF
rm /var/lib/forticlient/config.db

