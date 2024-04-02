#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <linux/fb.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <time.h>
  
#define FB_SIZE (320 * 240 * 2 * 2)
  
static int fb_dev = -1;
static uint16_t *fb_mem = NULL;
struct fb_var_screeninfo vinfo={0};
  
static int fb_init(void)
{
    fb_dev = open("/dev/fb0", O_RDWR);
    if (fb_dev < 0) {
        printf("failed to open /dev/fb0\n");
        return -1;
    }
  
    if (ioctl(fb_dev, FBIOGET_VSCREENINFO, &vinfo) < 0) {
        close(fb_dev);
        printf("failed to ioctl /dev/fb0\n");
        return -1;
    }
    
    fb_mem = (uint16_t*)mmap(NULL, FB_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fb_dev, 0);
    if (fb_mem == (void*)-1) {
        close(fb_dev);
        printf("failed to mmap /dev/fb0\n");
        return -1;
    }
    memset(fb_mem, 0 , FB_SIZE);
    return 0;
}
  
static int fb_uninit(void)
{
    munmap(fb_mem, FB_SIZE);
    fb_mem = NULL;
  
    close(fb_dev);
    fb_dev = -1;
    return 0;
}
  
int main(int argc, char **argv)
{
    int x = 0, y = 0;
    uint16_t *p = NULL, cc = 0, ret = 0;
    uint16_t col[] = {0xf800, 0x07e0, 0x001f};
  
    fb_init();
  
    vinfo.yres_virtual = vinfo.yres * 2;
    ioctl(fb_dev, FBIOPUT_VSCREENINFO, &vinfo);
    while (1) {
        p = fb_mem + (320 * 240 * (cc % 2));
        for (y=0; y<240; y++) {
            for (x=0; x<320; x++) {
                *p++= col[cc % 3];
            }
        }
        vinfo.yoffset = (cc % 2) * vinfo.yres;
        ioctl(fb_dev, FBIOPAN_DISPLAY, &vinfo);
        ioctl(fb_dev, FBIO_WAITFORVSYNC, &ret);
        cc+= 1;
    }
    fb_uninit();
    return 0;
}
