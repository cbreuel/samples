# Utility to install packages in a machine without internet access.

Run this script in a machine that has access to both the internet and the
target machine via SSH. The script will

* Download the target package with all its dependencies to a temp directory
* Copy all package files to the target machine
* Install the packages in the target machine

This assumes that the jump server (where you run the script) and the target
host have the same OS and architecture. It won't work otherwise.

Usage:
```
  apt_offline_install.sh <package name> <target host IP or name>
```

Most of the script is based on tips from [this blog post](https://www.ostechnix.com/download-packages-dependencies-locally-ubuntu/).
