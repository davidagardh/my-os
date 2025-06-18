#!/bin/bash

set -ouex pipefail

mkdir /var/opt /var/roothome

### Install packages

# Installs packages from fedora repos
dnf5 install -y \
	tmux \
	btrbk \
	NetworkManager-l2tp-gnome \
	distrobox \
	fish \
	lm_sensors \
	wl-clipboard \
	virt-manager \
	vim \
	fzf

dnf5 remove -y toolbox

/ctx/1password.sh

cp /ctx/cosign.pub /etc/pki/davidagardh-cosign.pub
rsync -r /ctx/root_files/ /
rm /etc/profile.d/nano-default-editor.sh

# Fix distrobox-init fish problem
# Only until https://github.com/89luca89/distrobox/pull/1672 is merged
dnf5 install -y patch
patch -p1 /usr/bin/distrobox-init /ctx/distrobox-autoload-fish_prompt.patch
dnf5 remove -y patch

/ctx/lint-fixes.sh

