#!/bin/bash

set -ouex pipefail

mkdir /var/opt /var/roothome

### Install packages

# use negativo17 for 3rd party packages with higher priority than default
dnf5 config-manager addrepo --from-repofile="https://negativo17.org/repos/fedora-multimedia.repo"
dnf5 config-manager setopt fedora-multimedia.priority=90
# Disable opneh264 since negativo17's ffmpeg-libs does it better
dnf5 config-manager setopt fedora-cisco-openh264.enabled=0

# Installs packages from fedora repos
dnf5 install -y \
	tmux \
	ansible-core \
	btrbk \
	NetworkManager-l2tp-gnome \
	NetworkManager-strongswan-gnome \
	distrobox \
	fish \
	lm_sensors \
	lshw \
	tcpdump \
	wl-clipboard \
	virt-manager \
	vim \
	ffmpeg-libs \
	fzf \
	subscription-manager

dnf5 remove -y toolbox

/ctx/1password.sh

cp /ctx/cosign.pub /etc/pki/davidagardh-cosign.pub
rsync -r /ctx/root_files/ /
rm /etc/profile.d/nano-default-editor.sh

/ctx/lint-fixes.sh

