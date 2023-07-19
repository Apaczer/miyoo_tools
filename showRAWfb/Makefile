CHAINPREFIX :=/opt/miyoo
CROSS_COMPILE := $(CHAINPREFIX)/usr/bin/arm-linux-

CC = $(CROSS_COMPILE)gcc
STRIP = $(CROSS_COMPILE)strip

SYSROOT     := $(shell $(CC) --print-sysroot)
SDL_CFLAGS  := $(shell $(SYSROOT)/usr/bin/sdl-config --cflags)
SDL_LIBS    := $(shell $(SYSROOT)/usr/bin/sdl-config --libs)

CFLAGS = $(SDL_CFLAGS) #-I$(CHAINPREFIX)/usr/include/ -I$(SYSROOT)/usr/include/  -I$(SYSROOT)/usr/include/SDL/
LDFLAGS = $(SDL_LIBS) -lSDL

all:
	$(CC) $(CFLAGS) $(LDFLAGS) *.c -o showRAWfb

clean:
	rm -rf showRAWfb*
