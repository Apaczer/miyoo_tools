#!/bin/sh

#EXEC commands (change to 1 to commence):
PACKAGE=0
ZIP=1
IPK=0
CLEAN=0

#ENV VAR.
##Generic
HOMEPATH="/mnt"
TARGET=audioctrl
VERSION=$(shell date +%Y-%m-%d\ %H:%M)
RELEASEDIR=package
ASSETSDIR=assets
OPKG_ASSETSDIR=opkg_assets
LINK=$TARGET.lnk
DESTDIR=apps
SECTION=applications
ALIASES=aliases.txt

##Link entries:
TITLE=$TARGET
DESCRI="Disable/Enable alsa audio output"
SELDIR=""

##IPK control entries:
PRIORITY=optional
MAINTAINER=Unknown
ARCH=arm
CONTROL="Package: ${TARGET}\n\
Version: ${VERSION}\n\
Description: ${DESCRI}\n\
Section: ${SECTION}\n\
Priority: ${PRIORITY}\n\
Maintainer: ${MAINTAINER}\n\
Architecture: ${ARCH}"

if (test $PACKAGE -ne 0 || test $ZIP -ne 0 || test $IPK -ne 0); then
	rm -rf $RELEASEDIR
	mkdir -p $RELEASEDIR
	mkdir -p $ASSETSDIR
	mkdir -p $OPKG_ASSETSDIR
	cp *$TARGET $RELEASEDIR/
	mkdir -p $RELEASEDIR/$DESTDIR/$TARGET
	mkdir -p $RELEASEDIR/gmenu2x/sections/$SECTION
	mv $RELEASEDIR/*$TARGET $RELEASEDIR/$DESTDIR/$TARGET/
	cp -r $ASSETSDIR/* $RELEASEDIR/$DESTDIR/$TARGET
	if !(test -e $OPKG_ASSETSDIR/$LINK); then
		touch $OPKG_ASSETSDIR/$LINK
		echo -e "title=${TITLE}\ndescription=${DESCRI}\nexec=" > $OPKG_ASSETSDIR/$LINK
		test -n "$SELDIR" && echo "selectordir=${SELDIR}" >> $OPKG_ASSETSDIR/$LINK
	fi
	cp $OPKG_ASSETSDIR/$LINK $RELEASEDIR/gmenu2x/sections/$SECTION
	sed "s/^exec=.*/exec=\/mnt\/${DESTDIR}\/${TARGET}\/${TARGET}/" $OPKG_ASSETSDIR/$LINK > $RELEASEDIR/gmenu2x/sections/$SECTION/$LINK
	cp $OPKG_ASSETSDIR/$ALIASES $RELEASEDIR/$DESTDIR/$TARGET

	if test $ZIP -ne 0; then
		rm -rf $RELEASEDIR/*.ipk
		cd $RELEASEDIR && zip -rq $TARGET$VERSION.zip ./* && mv *.zip ..
		rm -rf $RELEASEDIR/*
		mv $TARGET*.zip $RELEASEDIR/
	fi

	if test $IPK -ne 0; then
		rm -rf $RELEASEDIR/*.zip
		mkdir -p .$HOMEPATH
		mv $RELEASEDIR/* .$HOMEPATH && mv .$HOMEPATH $RELEASEDIR
		mkdir -p $RELEASEDIR/data
		mv $RELEASEDIR$HOMEPATH $RELEASEDIR/data/
		if !(test -e $$OPKG_ASSETSDIR/CONTROL); then
			mkdir -p $OPKG_ASSETSDIR/CONTROL
			echo -e "#!/bin/sh\nsync; echo 'Installing new ${TARGET}..'; rm /var/lib/opkg/info/${TARGET}.list; exit 0" > $OPKG_ASSETSDIR/CONTROL/preinst
			echo -e "#!/bin/sh\nsync; echo 'Installation finished.'; echo 'Restarting ${TARGET}..'; sleep 1; killall ${TARGET}; exit 0" > $OPKG_ASSETSDIR/CONTROL/postinst
			echo -e $CONTROL > $OPKG_ASSETSDIR/CONTROL/control
		fi
		chmod +x $OPKG_ASSETSDIR/CONTROL/postinst $OPKG_ASSETSDIR/CONTROL/preinst
		cp -r $OPKG_ASSETSDIR/CONTROL $RELEASEDIR
		sed "s/^Version:.*/Version: ${VERSION}/" $OPKG_ASSETSDIR/CONTROL/control > $RELEASEDIR/CONTROL/control
		echo 2.0 > $RELEASEDIR/debian-binary
		tar --owner=0 --group=0 -czvf $RELEASEDIR/data.tar.gz -C $RELEASEDIR/data/ . >/dev/null 2>&1
		tar --owner=0 --group=0 -czvf $RELEASEDIR/control.tar.gz -C $RELEASEDIR/CONTROL/ . >/dev/null 2>&1
		ar r $TARGET.ipk $RELEASEDIR/control.tar.gz $RELEASEDIR/data.tar.gz $RELEASEDIR/debian-binary
		rm -rf $RELEASEDIR/*
		mv $TARGET.ipk $RELEASEDIR/
	fi
fi

if test $CLEAN -ne 0; then
	# rm -f $TARGET *.o
	rm -rf $RELEASEDIR
	rm -f *.ipk
	rm -f *.zip
fi
