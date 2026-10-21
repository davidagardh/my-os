#!/bin/bash

set -ouex pipefail

# Install 1password repo
rpm --import https://downloads.1password.com/linux/keys/1password.asc
cat << EOF > /etc/yum.repos.d/1password.repo
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF

dnf5 install -y 1password-cli 1password
rm /etc/yum.repos.d/1password.repo -f

# Move 1Password from /opt/
# Needed on Silverblue because Silverblue treats /opt/ as persistent.
# The bootc images do not.

mv /var/opt/1Password /usr/lib/1Password
rm /usr/bin/1password
ln -s /opt/1Password/1password /usr/bin/1password

GID_ONEPASSWORD=1001
# Any available value over 1000 should do
GID_ONEPASSWORDCLI=1019
GID_ONEPASSWORDMCP=1020

chgrp "${GID_ONEPASSWORD}" /usr/lib/1Password/1Password-BrowserSupport
chmod g+s /usr/lib/1Password/1Password-BrowserSupport

chgrp "${GID_ONEPASSWORDMCP}" /usr/lib/1Password/1password-mcp
chmod g+s /usr/lib/1Password/1password-mcp

chgrp "${GID_ONEPASSWORDCLI}" /usr/bin/op
chmod g+s /usr/bin/op

# The RPM scriptlets have already added the groups to /etc/group with the
# first free GIDs (1000 and up). Move them to the GIDs above so fresh installs,
# which start from the image's /etc/group, match the files we just chgrp'd.
# The MCP group goes first since it was given 1001.
groupmod -g "${GID_ONEPASSWORDMCP}" onepassword-mcp
groupmod -g "${GID_ONEPASSWORDCLI}" onepassword-cli
groupmod -g "${GID_ONEPASSWORD}" onepassword

# Dynamically create the required groups via sysusers.d
# and set the GID based on the files we just chgrp'd
cat >/usr/lib/sysusers.d/onepassword.conf <<EOF
g onepassword ${GID_ONEPASSWORD}
EOF
cat >/usr/lib/sysusers.d/onepassword-cli.conf <<EOF
g onepassword-cli ${GID_ONEPASSWORDCLI}
EOF
cat >/usr/lib/sysusers.d/onepassword-mcp.conf <<EOF
g onepassword-mcp ${GID_ONEPASSWORDMCP}
EOF

# Register path symlink
# We do this via tmpfiles.d so that it is created by the live system.
cat >/usr/lib/tmpfiles.d/onepassword.conf <<EOF
L  /opt/1Password  -  -  -  -  /usr/lib/1Password
EOF

