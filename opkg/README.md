@turtleletortue 

Merge the ../usr folder with the one on the _rootfs_ partition of your sd card (should work on both bittboy and pocketgo). then mount main as /mnt on your computer, make a folder called .opkg on /mnt, and run sudo ln -s /mnt/.opkg/ (location of rootfs mount)/var/lib/opkg  
the version provided uses ipks, so it won't cause performance decrease

Turtle