by @gameblabla

You need to make sure...
- that the kernel is built with Squashfs support + cramfs.
If unsure about it, try to mount it with the ``mount`` and see if it works.

- The rootfs needs to be mounted as read-write, not read-only.
Buildroot mounts it as read only by default.
The following line in /etc/inittab usually fixes this :
::sysinit:/bin/mount -o remount,rw /

- You need to have the opkrun utility in /usr/bin.
opkrun is used for mounting OPK files to run them.

- You must have GMenu2X with OPKs support.