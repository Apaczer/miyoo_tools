### Tearing - framebuffer I/O method:
To compile run locally:  
```sh
/opt/miyoo/usr/bin/arm-linux-gcc -o tear_fbio tear_fbio.c
```

or in docker:  
```sh
${CROSS_COMPILE}gcc -o tear_fbio tear_fbio.c
```
______________________
### Tearing - SDL loop method:

To compile run locally:  
```sh
/opt/miyoo/usr/bin/arm-linux-gcc -o tear_sdl -lSDL -I/opt/miyoo/arm-miyoo-linux-uclibcgnueabi/sysroot/usr/include/SDL tear_sdl.c
```

or in docker:  
```sh
${CROSS_COMPILE}gcc -o tear_sdl -lSDL -I${SYSROOT}/usr/include/SDL tear_sdl.c
```

______________________
### INFO

**binary**: compiled with uClibc dynamicly shared MiyooCFW SDK

**credits**: @steward-fu