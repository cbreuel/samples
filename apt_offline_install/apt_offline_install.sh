#!/bin/bash

# Utility to install packages in a machine without internet access.
#
# Run this script in a machine that has access to both the internet and the
# target machine via SSH. The script will
#
# * Download the target package with all its dependencies to a temp directory
# * Copy all package files to the target machine
# * Install the packages in the target machine
#
# This assumes that the jump server (where you run the script) and the target
# host have the same OS and architecture. It won't work otherwise.
#
# Usage:
#   apt_offline_install.sh <package name> <target host IP or name>

PACKAGE_NAME=$1
OFFLINE_HOST=$2

echo -e "\033[1mInstalling package $PACKAGE_NAME and depencies in host $OFFLINE_HOST\033[0m"

TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR

DEPENDS_OPTIONS='--recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances'

for i in $(apt-cache depends $DEPENDS_OPTIONS $PACKAGE_NAME | cut -d ':' -f 2,3 | sed -e s/'<'/''/ -e s/'>'/''/)
do
  sudo apt-get download $i 2>>errors.txt
done

echo -e "\033[1mDownloaded packages to $TEMP_DIR\033[0m"

ssh $OFFLINE_HOST "mkdir $TEMP_DIR"
scp *.deb $OFFLINE_HOST:$TEMP_DIR

echo -e "\033[1mCopied packages to $OFFLINE_HOST\033[0m"

ssh $OFFLINE_HOST "cd $TEMP_DIR && yes | sudo dpkg --skip-same-version --refuse-downgrade -i *"
