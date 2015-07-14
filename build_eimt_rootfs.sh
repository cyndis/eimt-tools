#!/bin/sh

set -e

# Configuration

BASE_ROOTFS_URL=http://cdimage.ubuntu.com/ubuntu-core/releases/14.04/release/ubuntu-core-14.04.1-core-armhf.tar.gz
TARGET_DIR=$PWD/eimt_rootfs

# Download rootfs if required

if [ -e $TARGET_DIR ]
then
	echo "Target directory $TARGET_DIR already exists, quitting."
	exit 1
fi

BASE_ROOTFS=$(basename $BASE_ROOTFS_URL)
if [ ! -e $BASE_ROOTFS ]
then
	wget $BASE_ROOTFS_URL
fi

DATA_PATH=$PWD

# Extract rootfs

mkdir -p $TARGET_DIR
cd $TARGET_DIR

echo "Using 'sudo' to extract rootfs base image in order to preserve UNIX permissions."
sudo tar xf $DATA_PATH/$BASE_ROOTFS

# Add test scripts

cat << 'EOF' > ./test_init
#!/bin/sh

mount -t proc proc proc/
mount --rbind /sys sys/
mount --rbind /dev dev/

chroot $PWD /test/run.sh
EOF

mkdir test

cat << 'EOF' > test/run.sh
#!/bin/sh

cd /test/tegra-tests
python3 tegra-tests.py
echo "tegra-tests return status: $?"
EOF

chmod ugo=rx ./test_init test/run.sh

# Add tegra test suite

cd test/

git clone git://github.com/cyndis/tegra-tests.git
cd tegra-tests
git checkout master

# Done!

echo "Done!"
