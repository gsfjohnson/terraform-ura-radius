#!/bin/bash
set -e

## xxx: Ideally move all this to a proper config management tool

yum install -y dracut-modules-growroot

cat <<EOF >>/etc/cloud/cloud.cfg
growpart:
  mode: auto
  devices: ['/']
  ignore_growroot_disabled: false
  resize_rootfs: True
  # dracut -f
EOF
