#!/bin/bash
dnf5 config-manager addrepo --from-repofile=https://repo.fortinet.com/repo/forticlient/7.4/centos/8/os/x86_64/fortinet.repo
dnf5 install -y forticlient

cp -r /opt/forticlient /usr/share/
rm -r /opt/forticlient
sed -i 's,/opt/,/usr/share/,' \
	/lib/systemd/system/forticlient.service \
	/usr/share/applications/forticlient-register.desktop \
	/usr/share/applications/forticlient.desktop \
	/usr/share/polkit-1/actions/org.fortinet.fortitray.policy \
	/usr/share/polkit-1/actions/org.fortinet.forticlient.policy

cat >/usr/lib/tmpfiles.d/forticlient.conf <<EOF
d /var/log/forticlient 0755 root root 5d -
d /var/lib/forticlient 0755 root root - -
f /var/lib/forticlient/config.db 0600 root root - -
EOF

