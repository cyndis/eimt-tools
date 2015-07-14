#!/bin/sh

set -e

echo "Generating initramfs.."

git clone git://github.com/cyndis/bbinitramfs.git
cd bbinitramfs
make

cp ramfs.img.gz ..

echo "initramfs built!"
