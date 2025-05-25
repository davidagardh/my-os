# Fedora à la David

# Purpose

This repository builds a bootc compatible container image optimized for desktop linux use in just the way I like it. It's based on the [image-temlate repo](https://github.com/ublue-os/image-template) by the Universal Blue Project.

A GitHub workflow builds a new version of the container image every night and on changes to the repo. The image is signed with a private key and pushed to the GitHub Container Registry.

# How to use the image

Start from a working installation of Silverblue (or similar distro that has bootc). Rebasing to this repo is done in two steps. The first step installs the image without verifying signatures, because those signatures would not be trusted. The second step enables image signature verification.

```bash
bootc switch quay.io/davidagardh/atomic-test:latest
```

Reboot

```bash
bootc switch quay.io/davidagardh/atomic-test:latest --enforce-container-sigpolicy
```

# Understanding the repo

## Containerfile

This file defines the base image and operations used to customize the selected image.

## build_files/build.sh

This bash script is run by the containerfile as part of the build process and does most of the customizations, including installing packages and modifying config files. It also calls out to other scripts in `build_files/`

## build_files/root_files

The contents of `root_files` is copied into the image.

## GitHub Actions Workflow

### build.yml

This workflow creates custom OCI image and publishes it to the quay.io container registry. Any image metadata is set here, including the name which by default is the same as the repo name.

### Container Signing

Images built with the GitHub are signed with cosign using a key pair. The cosign public key is stored in the repo and included in every built image. The private key is stored as a secret in GitHub.

