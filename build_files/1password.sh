#!/bin/bash

# Install 1password repo
rpm --import https://downloads.1password.com/linux/keys/1password.asc
echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo

dnf5 install -y 1password-cli 1password

# Move 1Password from /opt/
# Needed on Silverblue because Silverblue treats /opt/ as persistent.
# The bootc images do not.

cp -r /opt/1Password /usr/share/
rm -r /opt/1Password

sed -i 's,/opt/1Password/,/usr/share/1Password/,' /usr/share/1Password/after-install.sh /usr/share/1Password/resources/1password.desktop /usr/share/applications/1password.desktop
/usr/share/1Password/after-install.sh
